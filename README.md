# Hotel List App

A Flutter application for browsing and viewing hotel listings with detailed information.

## Project Architecture

This project follows Clean Architecture principles with a feature-first organization:

```
lib/
├── core/            # Core functionality and utilities
│   ├── api/         # API-related code
│   ├── error/       # Error handling
│   ├── injection/   # Dependency injection
│   └── network/     # Network layer
└── features/        # App features
    └── venues/      # Hotel venues feature
        ├── data/        # Data layer (repositories, DTOs)
        ├── domain/      # Domain layer (entities, use cases)
        └── presentation/ # UI layer (pages, widgets, bloc)
```

### Architecture Layers

1. **Data Layer**: Handles external data sources and transformations (API calls, local storage)
2. **Domain Layer**: Contains business logic and entities
3. **Presentation Layer**: UI components and state management with Bloc pattern

## Getting Started

### Prerequisites

- Flutter SDK (version >=3.7.2)
- Dart SDK (version >=3.7.2)
- Node.js (version >=16)
- Yarn or npm
- Android Studio / VS Code with Flutter extensions

### Installation

#### Frontend (Flutter App)

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/hotel_list_app.git
   ```

2. Navigate to the project directory:
   ```
   cd hotel_list_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run code generation for JSON serialization:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Configure the backend URL:
   - Open `lib/core/flavor/base_flavor.dart`
   - Update the `baseUrl` getter method's `FlavorType.dev` case with your local IP address:
   - Set the BASE_URL as a .env parameter in your project's root folder
     ```dart
     static String get baseUrl {
       switch (flavor) {
        final baseUrl = dotenv.env['BASE_URL'];
         case FlavorType.dev:
           return baseUrl;
         // ... other cases ...
       }
     }
     ```
   - Note: Do not use `localhost` or `127.0.0.1` when running on a physical device
   - You can run the app with different environments by selecting the appropriate launch configuration in VSCode or using the commands in the FLAVOR_README.md file

6. Run the app:
   ```
   flutter run
   ```

#### Backend (NestJS)

The backend is built with NestJS, using Prisma as an ORM for database access.

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Install dependencies:
   ```
   yarn install
   ```
   or
   ```
   npm install
   ```

3. Run the development server:
   ```
   yarn start:dev
   ```
   or
   ```
   npm run start:dev
   ```

4. Seed the database (if needed):
   ```
   yarn seed
   ```
   or
   ```
   npm run seed
   ```

The backend server will be available at http://localhost:3000.

## Backend Architecture

The backend follows NestJS's modular architecture:

```
backend/
├── src/
│   ├── main.ts                 # Application entry point
│   ├── app.module.ts           # Main application module
│   ├── venues/                 # Venues module
│   │   ├── controllers/        # HTTP request handlers
│   │   ├── services/           # Business logic
│   │   ├── dto/                # Data Transfer Objects
│   │   └── entities/           # Database entities
│   └── prisma/                 # Database connection and models
├── prisma/
│   ├── schema.prisma           # Database schema
│   └── seed.ts                 # Database seeding
└── base_data/                  # Seed data files
```

## Testing Approach

The project follows a comprehensive testing strategy:

- **Unit Tests**: For testing individual classes and functions (repositories, use cases, blocs)
- **Widget Tests**: For testing UI components in isolation (FilterChipWidget, VenueCard, FilterChipsRow)
- **Integration Tests**: For testing feature workflows (venue filtering, search functionality, loading states)

For detailed information about our testing approach, please refer to the [TESTING_README.md](./TESTING_README.md).

Run frontend tests with:
```
flutter test
```

Run integration tests with:
```
flutter test integration_test/venue_filtering_test.dart
```

Run backend tests with:
```
cd backend
yarn test
```
or
```
cd backend
npm run test
```

## Third-Party Libraries

### Frontend

| Library | Purpose |
|---------|---------|
| **flutter_bloc** (v9.1.0) | State management following the BLoC pattern |
| **bloc** (v9.0.0) | Core business logic component |
| **equatable** (v2.0.7) | Simplifies equality comparisons for immutable objects |
| **dio** (v5.8.0+1) | HTTP client for API requests with interceptors |
| **get_it** (v8.0.3) | Dependency injection for service locator pattern |
| **json_annotation/serializable** (v4.9.0/v6.9.5) | JSON serialization/deserialization |
| **connectivity_plus** (v6.1.4) | Network connectivity monitoring |
| **cached_network_image** (v3.4.1) | Image caching and loading |
| **google_maps_flutter** (v2.12.1) | Google Maps integration for hotel locations |
| **flutter_carousel_widget** (v3.1.0) | Image carousel for hotel photos |
| **skeletonizer** (v1.4.3) | Loading state UI with skeleton screens |
| **flutter_dotenv** (v5.2.1) | Environment variable management |
| **flutter_secure_storage** (v9.0.0) | Secure storage for sensitive data |
| **intl** (v0.20.2) | Internationalization and formatting |
| **dio_cookie_manager** (v3.1.1) | Cookie management for Dio |
| **cookie_jar** (v4.0.8) | Cookie storage and handling |
| **pretty_dio_logger** (v1.3.1) | Logging for Dio HTTP requests |

### Testing

| Library | Purpose |
|---------|---------|
| **mockito** (v5.4.6) | Mocking for unit tests |
| **mocktail** (v1.0.3) | Mocking library with simpler syntax |
| **bloc_test** (v10.0.0) | Testing BLoC components |
| **network_image_mock** (v2.1.1) | Mocking network images in tests |
| **integration_test** | Flutter SDK package for integration testing |

### Backend

| Library | Purpose |
|---------|---------|
| **NestJS** | Progressive Node.js framework for building server-side applications |
| **Prisma** | Next-generation ORM for Node.js and TypeScript |
| **class-validator** | Validation library for TypeScript |
| **Express** | Web application framework for Node.js |
| **Jest** | JavaScript testing framework |

## Design Decisions and Challenges

### Design Decisions

1. **Clean Architecture**: Separation of concerns between data, domain, and presentation layers improves maintainability and testability.

2. **Feature-First Organization**: Each feature is self-contained with its own layers, making the codebase more modular and scalable.

3. **BLoC Pattern**: Chosen for state management to separate business logic from UI, enabling better testability and predictable state transitions.

4. **DTOs and Entities**: Used separate data transfer objects (DTOs) for API communication and domain entities for business logic to maintain a clean separation.

5. **Dependency Injection**: Used GetIt for service location to manage dependencies and facilitate testing.

6. **NestJS Backend**: Provides a structured and modular approach to building the API with TypeScript.

7. **Prisma ORM**: Type-safe database access with auto-generated types matching the schema.

### Challenges Faced

1. **Data Transformation**: Converting between DTOs and domain entities while handling nullable fields and default values.

2. **Responsive Design**: Creating a UI that works well across different screen sizes and orientations.

3. **State Management**: Handling complex states during loading, success, and error scenarios.

4. **Network Connectivity**: Implementing a robust solution for handling network interruptions and offline mode.

5. **Maps Integration**: Integrating Google Maps with proper error handling and performance optimization.

6. **Cross-Platform Development**: Ensuring consistent behavior across iOS and Android platforms.

7. **Local Development**: Managing IP address configuration for frontend-backend communication in `lib/core/flavor/base_flavor.dart` for different environments.
