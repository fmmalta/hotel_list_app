# Flutter App Flavors

This project supports multiple flavors (environments) to make development and deployment easier.

## Available Flavors

- **Development (dev)**: Used for local development with development API endpoints.
- **Staging (staging)**: Used for testing with staging environment API endpoints.
- **Production (prod)**: Used for production releases with production API endpoints.

## How to Run

### Using VSCode

1. Open the Run and Debug panel in VSCode
2. Select one of the following launch configurations:
   - `hotel_list_app (Development)`
   - `hotel_list_app (Staging)`
   - `hotel_list_app (Production)`
3. Press the Run button or F5

### Using Terminal

Run the app with a specific flavor:

```bash
# Development
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Production
flutter run --flavor prod -t lib/main_prod.dart
```

## Building the App

Build the app for a specific flavor:

```bash
# Development APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Staging APK
flutter build apk --flavor staging -t lib/main_staging.dart

# Production APK
flutter build apk --flavor prod -t lib/main_prod.dart

# For iOS builds
flutter build ios --flavor dev -t lib/main_dev.dart
```

## Configuration

Flavor-specific configuration is managed in the `lib/core/flavor/base_flavor.dart` file. You can modify API endpoints, timeouts, and other environment-specific settings there.

## Extending Flavors

To add more flavor-specific configurations:

1. Add new properties to the `BaseFlavor` class
2. Update the switch statement in the relevant getter methods
3. Use the new properties in your app as needed
