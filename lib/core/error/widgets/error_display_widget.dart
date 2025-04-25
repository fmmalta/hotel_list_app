import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? retryText;
  final List<Widget>? additionalActions;
  final Icon? errorIcon;
  final Color errorColor;
  final double iconSize;
  final bool isSelectable;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryText,
    this.additionalActions,
    this.errorIcon,
    this.errorColor = Colors.red,
    this.iconSize = 50,
    this.isSelectable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorIcon ?? Icon(Icons.error_outline, size: iconSize, color: errorColor),
            const SizedBox(height: 16),
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            isSelectable
                ? SelectableText.rich(
                  TextSpan(text: message, style: TextStyle(color: errorColor, fontSize: 16)),
                  textAlign: TextAlign.center,
                )
                : Text(message, style: TextStyle(color: errorColor, fontSize: 16), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
            if (additionalActions != null) ...[const SizedBox(height: 16), ...additionalActions!],
          ],
        ),
      ),
    );
  }
}
