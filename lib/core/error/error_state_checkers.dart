import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/venue_detail_bloc/venue_detail_bloc.dart';
import 'package:hotel_list_app/features/venues/presentation/venue_detail_bloc/venue_state.dart';

class ErrorStateCheckers {
  static bool isVenueDetailErrorState(VenueDetailState previous, VenueDetailState current) {
    return current is VenueDetailError;
  }

  static String getVenueDetailErrorMessage(VenueDetailState state) {
    if (state is VenueDetailError) {
      return state.message;
    }
    return 'Unknown error';
  }
}

extension ErrorListenerWidgetExtension on Widget {
  Widget withVenueDetailErrorListener(
    BuildContext context, {
    required VenueDetailBloc bloc,
    VoidCallback? onRetry,
    bool showSnackBarInsteadOfDialog = true,
  }) {
    return BlocListener<VenueDetailBloc, VenueDetailState>(
      bloc: bloc,
      listenWhen: ErrorStateCheckers.isVenueDetailErrorState,
      listener: (context, state) {
        if (state is VenueDetailError) {
          final errorMessage = state.message;

          if (!showSnackBarInsteadOfDialog) {
            showDialog<void>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    content: Text(errorMessage),
                    actions: [
                      if (state.isRecoverable && onRetry != null)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onRetry();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
                    ],
                  ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
                action:
                    state.isRecoverable && onRetry != null
                        ? SnackBarAction(label: 'Retry', textColor: Colors.white, onPressed: onRetry)
                        : null,
              ),
            );
          }
        }
      },
      child: this,
    );
  }
}
