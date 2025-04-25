import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hotel_list_app/core/error/error_handler.dart';
import 'package:hotel_list_app/core/error/exceptions.dart';
import 'package:hotel_list_app/core/error/failures.dart';

mixin BlocErrorHandlerMixin {
  Future<(bool, String?)> handleSafeExecution(
    Future<void> Function() operation, {
    String? customErrorMessage,
    bool logError = true,
  }) async {
    try {
      await operation();
      return (true, null);
    } catch (e, stackTrace) {
      if (logError) {
        log(customErrorMessage ?? 'Error in bloc operation', error: e, stackTrace: stackTrace);
      }

      final errorMessage = ErrorHandler.getErrorMessage(e);
      return (false, errorMessage);
    }
  }

  String getErrorMessage(dynamic error) {
    return ErrorHandler.getErrorMessage(error);
  }

  Failure handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message, statusCode: exception.statusCode);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else if (exception is DioException) {
      final message = ErrorHandler.getErrorMessage(exception);

      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return NetworkFailure(message: message);
        case DioExceptionType.badResponse:
          return ServerFailure(message: message, statusCode: exception.response?.statusCode);
        default:
          return UnknownFailure(message: message);
      }
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
