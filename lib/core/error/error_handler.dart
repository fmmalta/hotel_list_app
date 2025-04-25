import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is ServerException) {
      return _handleServerException(error);
    } else if (error is NetworkException) {
      return _handleNetworkException(error);
    } else if (error is CacheException) {
      return _handleCacheException(error);
    } else if (error is DioException) {
      return _handleDioException(error);
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network settings and try again.';
    } else if (error is FormatException) {
      return 'Data format error. Please contact support if this persists.';
    } else if (error is Failure) {
      return error.message;
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  static String getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error${failure.statusCode != null ? ' (${failure.statusCode})' : ''}: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message}';
    } else if (failure is CacheFailure) {
      return 'Storage error: ${failure.message}';
    } else {
      return failure.message;
    }
  }

  static Widget buildErrorWidget({
    required String message,
    String? title,
    VoidCallback? onRetry,
    String? retryText,
    List<Widget>? additionalActions,
  }) {
    return ErrorDisplay(
      message: message,
      title: title ?? 'Something went wrong',
      onRetry: onRetry,
      retryText: retryText ?? 'Try Again',
      additionalActions: additionalActions,
    );
  }

  static String _handleServerException(ServerException exception) {
    final statusCode = exception.statusCode;
    final message = exception.message;

    if (statusCode == null) {
      return 'Server error: $message';
    }

    switch (statusCode) {
      case 400:
        return 'Invalid request: $message';
      case 401:
        return 'Authentication required: $message';
      case 403:
        return 'Access denied: $message';
      case 404:
        return 'Resource not found: $message';
      case 500:
        return 'Server error: $message';
      case 503:
        return 'Service unavailable: $message';
      default:
        return 'Server error ($statusCode): $message';
    }
  }

  static String _handleNetworkException(NetworkException exception) {
    return 'Network error: ${exception.message}';
  }

  static String _handleCacheException(CacheException exception) {
    return 'Storage error: ${exception.message}';
  }

  static String _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again later.';
      case DioExceptionType.receiveTimeout:
        return 'Response timeout. Please try again later.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final errorMessage = error.response?.data?['message'] ?? error.response?.statusMessage ?? 'Unknown error';

        if (statusCode == null) {
          return 'Server error: $errorMessage';
        }

        switch (statusCode) {
          case 400:
            return 'Invalid request: $errorMessage';
          case 401:
            return 'Authentication required: $errorMessage';
          case 403:
            return 'Access denied: $errorMessage';
          case 404:
            return 'Resource not found: $errorMessage';
          case 500:
            return 'Server error: $errorMessage';
          case 503:
            return 'Service unavailable: $errorMessage';
          default:
            return 'Server error ($statusCode): $errorMessage';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please contact support.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

class ErrorDisplay extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? retryText;
  final List<Widget>? additionalActions;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryText,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
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
            SelectableText.rich(
              TextSpan(text: message, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16)),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Try Again'),
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
