# Project Structure

This document explains the organization of the Weather App Flutter project.

## Folder Structure

```
lib/
├── main.dart                 # App entry point
├── constants/               # App-wide constants
│   ├── api_constants.dart   # API endpoints and keys
│   └── app_constants.dart   # UI constants (colors, sizes, etc.)
├── models/                  # Data models
│   ├── weather_model.dart   # Weather data structure
│   └── location_model.dart  # Location data structure
├── providers/               # Riverpod state management
│   ├── weather_provider.dart  # Weather data provider
│   ├── location_provider.dart # Location data provider
│   └── search_provider.dart   # Search functionality provider
├── screens/                 # App screens/pages
│   ├── home_screen.dart     # Current location weather
│   └── search_screen.dart   # Searched places weather
├── services/                # External service integrations
│   ├── weather_service.dart # Weather API service
│   └── location_service.dart # Location services
├── utils/                   # Utility functions and helpers
│   ├── helpers.dart         # General utility functions
│   └── app_theme.dart       # App theme configuration
└── widgets/                 # Reusable UI components
    ├── weather_card.dart    # Weather display card
    ├── search_bar.dart      # Search input widget
    ├── loading_widget.dart  # Loading indicator
    └── error_widget.dart    # Error display widget
```

## Architecture Overview

### State Management
- **Riverpod**: Used for state management throughout the app
- **Providers**: Separate providers for weather, location, and search functionality

### Data Flow
1. **Services** handle external API calls and location services
2. **Providers** manage state and business logic using Riverpod
3. **Screens** consume provider data and display UI
4. **Widgets** are reusable components shared across screens
5. **Models** define data structures for type safety

### Key Features
- **Current Location Weather**: Home screen shows weather for user's current location
- **Search Functionality**: Search screen allows users to find weather for any location
- **Modular Design**: Clean separation of concerns for easy maintenance
- **Reusable Components**: Shared widgets for consistent UI

## Implementation Guidelines

1. **Models**: Define clear data structures with proper serialization
2. **Services**: Keep API logic separate and testable
3. **Providers**: Use Riverpod best practices for state management
4. **Screens**: Keep UI logic minimal, delegate to providers
5. **Widgets**: Create reusable components for common UI patterns
6. **Constants**: Centralize configuration and magic numbers
7. **Utils**: Place helper functions and theme configuration here
