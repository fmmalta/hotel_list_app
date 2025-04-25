import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/core/error/context_extensions.dart';

class ErrorListener<B extends BlocBase<S>, S> extends BlocListener<B, S> {
  ErrorListener({
    super.key,
    required super.bloc,
    required super.child,
    required BlocListenerCondition<S> listenWhen,
    required String Function(S state) errorMessageExtractor,
    VoidCallback? onRetry,
    bool showDialog = false,
    String? dialogTitle,
    String? retryText,
    ErrorDisplayType displayType = ErrorDisplayType.snackbar,
  }) : super(
         listenWhen: listenWhen,
         listener: (context, state) {
           final errorMessage = errorMessageExtractor(state);

           switch (displayType) {
             case ErrorDisplayType.snackbar:
               context.showErrorSnackBar(
                 errorMessage,
                 action:
                     onRetry != null
                         ? SnackBarAction(label: retryText ?? 'Retry', textColor: Colors.white, onPressed: onRetry)
                         : null,
               );
               break;
             case ErrorDisplayType.dialog:
               context.showErrorDialog(
                 message: errorMessage,
                 title: dialogTitle ?? 'Error',
                 onRetry: onRetry,
                 retryText: retryText,
               );
               break;
           }
         },
       );

  static ErrorListener<B, S> forErrorState<B extends BlocBase<S>, S>({
    Key? key,
    required B bloc,
    required Widget child,
    required bool Function(S previous, S current) isErrorState,
    required String Function(S state) errorMessageExtractor,
    VoidCallback? onRetry,
    bool showDialog = false,
    String? dialogTitle,
    String? retryText,
    ErrorDisplayType displayType = ErrorDisplayType.snackbar,
  }) {
    return ErrorListener<B, S>(
      key: key,
      bloc: bloc,
      listenWhen: isErrorState,
      errorMessageExtractor: errorMessageExtractor,
      onRetry: onRetry,
      showDialog: showDialog,
      dialogTitle: dialogTitle,
      retryText: retryText,
      displayType: displayType,
      child: child,
    );
  }
}

enum ErrorDisplayType { snackbar, dialog }
