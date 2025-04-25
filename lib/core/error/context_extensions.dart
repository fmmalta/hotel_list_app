import 'package:flutter/material.dart';
import 'package:hotel_list_app/core/error/error_handler.dart';

extension ErrorHandlingExtensions on BuildContext {
  void showErrorSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    VoidCallback? onVisible,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
        duration: duration,
        action: action,
        onVisible: onVisible,
      ),
    );
  }

  void showErrorForException(
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onRetry,
    String? retryText,
  }) {
    final errorMessage = ErrorHandler.getErrorMessage(error);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(this).colorScheme.error,
        duration: duration,
        action:
            onRetry != null
                ? SnackBarAction(label: retryText ?? 'Retry', textColor: Colors.white, onPressed: onRetry)
                : null,
      ),
    );
  }

  Future<T?> showErrorDialog<T>({
    required String message,
    String? title,
    VoidCallback? onRetry,
    String? retryText,
    String? cancelText,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: this,
      builder:
          (context) => AlertDialog(
            title: title != null ? Text(title, style: TextStyle(color: Theme.of(context).colorScheme.error)) : null,
            content: SelectableText(message),
            actions:
                actions ??
                [
                  if (onRetry != null)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(retryText ?? 'Retry'),
                    ),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancelText ?? 'Close')),
                ],
          ),
    );
  }
}
