# AI Web Builders Hub

A comprehensive Flutter mobile application that aggregates 32+ AI-powered web building tools with integrated WebView browsing and Supabase backend.

## Features

### 🔧 Core Features
- **Tool Directory**: Browse 32+ AI web building tools in organized grid layout
- **In-App WebView**: Browse tools without leaving the app using flutter_inappwebview
- **Search & Filter**: Advanced filtering by category, price, rating, skill level
- **Favorites Management**: Save and organize preferred tools
- **User Authentication**: Supabase auth integration with email/password
- **Rating System**: Rate and review tools (coming soon)
- **Dark/Light Mode**: Complete theme switching capability

### 📱 User Interface
- Material Design 3.0 components
- Responsive grid layout (2 columns mobile, 3+ tablet)
- Bottom navigation (Home, Favorites, Categories, Settings)
- Custom WebView with navigation controls
- Search and filter functionality
- Professional Blue (#2196F3) primary color theme

### 🏗️ Technical Architecture
- **Frontend**: Flutter (iOS + Android)
- **Backend**: Supabase (PostgreSQL database)
- **WebView**: flutter_inappwebview package
- **State Management**: Riverpod
- **Architecture**: MVVM (Model-View-ViewModel)

## Project Structure

```
lib/
├── core/
│   ├── constants/        # App constants and configuration
│   ├── themes/          # Material Design 3.0 themes
│   ├── utils/           # Helper functions and utilities
│   └── services/        # Supabase service integration
├── data/
│   ├── models/          # Data models (Tool, User, Category, etc.)
│   ├── repositories/    # Data layer abstraction
│   └── providers/       # Riverpod providers
├── presentation/
│   ├── screens/         # All app screens
│   ├── widgets/         # Reusable UI components
│   └── providers/       # UI state providers
├── domain/
│   ├── entities/        # Business logic entities
│   └── usecases/        # Business logic use cases
└── main.dart           # App entry point
```

## Key Screens

1. **Splash Screen** - App initialization with animations
2. **Authentication** - Login/Register with Supabase
3. **Home Screen** - Tool grid with search and filtering
4. **WebView Screen** - In-app browsing with custom controls
5. **Favorites Screen** - User's saved tools
6. **Categories Screen** - Browse tools by category
7. **Settings Screen** - Theme switching and user preferences

## Database Schema

The Supabase database includes:
- **Categories**: 5 main categories (Website Builders, Development Tools, Design Tools, WordPress Tools, Hosting Platforms)
- **Tools**: 32 AI tools with complete metadata
- **Users**: User authentication and profiles
- **Favorites**: User favorite tools
- **Ratings**: Tool ratings and reviews

## Getting Started

### Prerequisites
- Flutter SDK (3.19.6 or later)
- Dart SDK
- Android Studio or VS Code
- Android device/emulator or iOS device/simulator

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Ahmedsabah1/ai_web_builders_hub.git
cd ai_web_builders_hub
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

The app is pre-configured with Supabase credentials. The database is already populated with categories and tools data.

- **Supabase URL**: `https://ggjptiveqqqubrhtdniy.supabase.co`
- **API Key**: Pre-configured in `lib/core/constants/app_constants.dart`

## Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.0      # State management
  supabase_flutter: ^2.0.0      # Backend integration
  flutter_inappwebview: ^6.0.0  # WebView functionality
  cached_network_image: ^3.3.0  # Image caching
  flutter_staggered_grid_view: ^0.7.0  # Grid layouts
  url_launcher: ^6.2.0          # External URL handling
  share_plus: ^7.2.0            # Share functionality
  flutter_rating_bar: ^4.0.1    # Rating components
```

## Build Commands

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Analysis and Testing
```bash
# Code analysis
flutter analyze

# Run tests
flutter test

# Format code
flutter format .
```

## Features Implementation Status

- ✅ Project setup and architecture
- ✅ Supabase integration
- ✅ Authentication system
- ✅ Home screen with tool grid
- ✅ Search and filtering
- ✅ Categories browsing
- ✅ Favorites management
- ✅ WebView integration
- ✅ Settings and theme switching
- ✅ Responsive design
- 🔄 Rating and review system (in progress)
- 🔄 Offline capabilities (in progress)
- 🔄 Performance optimizations (in progress)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support or questions, please open an issue in the GitHub repository.
