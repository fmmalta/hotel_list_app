# Error Handling System

This module provides a comprehensive error handling solution for the entire app.

## Overview

The error handling system consists of:

1. **Exception & Failure Classes** - Define types of errors
2. **Error Handler** - Convert exceptions to user-friendly messages
3. **BlocErrorHandlerMixin** - Standardized error handling for Bloc/Cubit classes
4. **Widgets & Extensions** - UI components for displaying errors
5. **Context Extensions** - Methods to easily show error messages
6. **State Checkers** - Utility to verify error states and extract messages

## How to Use

### 1. In Bloc/Cubit Classes

```dart
class MyBloc extends Bloc<MyEvent, MyState> with BlocErrorHandlerMixin {

  Future<void> _onSomeEvent(SomeEvent event, Emitter<MyState> emit) async {
    emit(MyStateLoading());
    try {
      // Your operation here
      emit(MyStateLoaded(...));
    } catch (e) {
      final failure = handleException(e);
      final errorMessage = getErrorMessage(e);

      emit(MyStateError(
        message: errorMessage,
        failure: failure,
        isRecoverable: !(failure is CacheFailure),
      ));
    }
  }
}
```

### 2. For Error UI in Widgets

```dart
// Using ErrorDisplayWidget
ErrorDisplayWidget(
  message: "Error message here",
  title: "Optional title",
  onRetry: () => doSomething(),
  additionalActions: [
    TextButton(
      onPressed: () => otherAction(),
      child: Text('Other action'),
    ),
  ],
)

// Or use context extensions
context.showErrorSnackBar("Error occurred");
context.showErrorForException(exception);
context.showErrorDialog(message: "Error details");

// Or use ErrorListener for reactive handling
ErrorListener.forErrorState(
  bloc: myBloc,
  child: myWidget,
  isErrorState: (prev, curr) => curr is ErrorState,
  errorMessageExtractor: (state) => (state as ErrorState).message,
  onRetry: () => retryAction(),
)

// Or use extension methods
myWidget.withVenueDetailErrorListener(
  context,
  bloc: venueDetailBloc,
  onRetry: () => retryAction(),
)
```

## Components

### Exceptions and Failures

- **Exceptions**: `ServerException`, `NetworkException`, `CacheException`, etc.
- **Failures**: `ServerFailure`, `NetworkFailure`, `CacheFailure`, etc.

### Error Handler

`ErrorHandler` class provides methods to convert exceptions to user-friendly messages and create appropriate UI.

### BlocErrorHandlerMixin

A mixin that provides standard error handling for Bloc/Cubit classes:
- `handleSafeExecution()`
- `getErrorMessage()`
- `handleException()`

### Widgets

- `ErrorDisplayWidget`: Displays error with icon, message, and actions
- `ErrorListener`: BlocListener wrapper that handles error states automatically

### Extensions

- `ErrorHandlingExtensions`: Methods on BuildContext for showing errors
- `ErrorListenerWidgetExtension`: Add error listeners to widgets

## Best Practices

1. **Always use the mixin** in your Bloc/Cubit classes for consistent error handling
2. **Use selectable text** for error messages so users can copy them if needed
3. **Provide recovery options** whenever possible
4. **Log errors** appropriately using the builtin mechanisms
5. **Be specific** with error messages to help users understand what went wrong
6. **Categorize errors** correctly (server, network, cache, etc.)
7. **Add error listeners** to important screens for reactive error handling
