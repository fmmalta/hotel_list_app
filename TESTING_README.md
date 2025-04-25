# Testing Documentation

## Overview

This directory contains tests for the Hotel List App. We have two main types of tests:

1. **Widget Tests** - Testing individual UI components
2. **Integration Tests** - Testing how multiple components work together

## Running the Tests

### Prerequisites

Make sure you have all dependencies installed:

```bash
flutter pub get
```

### Widget Tests

To run all widget tests:

```bash
flutter test
```

To run a specific widget test:

```bash
flutter test test/features/venues/presentation/widgets/filter_chip_widget_test.dart
```

### Integration Tests

To run integration tests:

```bash
flutter test integration_test/venue_filtering_test.dart
```

To run integration tests on a connected device:

```bash
flutter test integration_test/venue_filtering_test.dart -d <device_id>
```

## Test Structure

### Widget Tests

We test the following UI components:

1. **FilterChipWidget** - Tests for selected/unselected states and interaction
2. **VenueCard** - Tests for correct display of venue information
3. **FilterChipsRow** - Tests for loading states and correct display of filter options

### Integration Tests

We test the following user flows:

1. **Venue Filtering** - Tests that users can filter venues by category
2. **Venue Search** - Tests the search functionality
3. **Loading States** - Tests the loading and transition between states

## Mocking

We use the following mocking libraries:

- **mocktail** - For mocking Bloc classes
- **network_image_mock** - For mocking network images
- **bloc_test** - For testing Bloc states and events

## Debugging Tests

If a test is failing, you can add more detailed logging:

```dart
testWidgets('Test with detailed logging', (WidgetTester tester) async {
  // Add this to get more verbose logs
  debugPrint = (String? message, {int? wrapWidth}) {
    print(message);
  };

  // Your test code...
});
```

## Best Practices

1. Test each widget in isolation
2. Mock dependencies to avoid network requests
3. Test both success and failure states
4. Use descriptive test names
5. Group related tests together
