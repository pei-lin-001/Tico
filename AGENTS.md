# Project: Tico
A cross-platform Pomodoro timer app built with Flutter.

## Build & Run Commands
- `flutter pub get` - Install dependencies
- `dart run build_runner build --delete-conflicting-outputs` - Generate code (Drift, Freezed, JSON)
- `flutter run` - Run the app
- `flutter test` - Run tests
- `flutter analyze` - Run linter

## Code Style
- Follow Flutter/Dart conventions
- Use `snake_case` for file names
- Use `UpperCamelCase` for class names
- Use `lowerCamelCase` for variables and functions
- Require trailing commas
- Prefer const constructors
- Use single quotes for strings

## Architecture
- Clean Architecture + Feature-First
- State management: Riverpod 2.x
- Database: Drift (SQLite)
- Routing: GoRouter
- Theme: Material 3 with dynamic accent colors

## Key Dependencies
- flutter_riverpod, riverpod_annotation
- go_router
- drift, sqlite3_flutter_libs
- freezed_annotation, json_annotation
- fl_chart
- firebase_core, firebase_auth, cloud_firestore
- flutter_local_notifications, audioplayers