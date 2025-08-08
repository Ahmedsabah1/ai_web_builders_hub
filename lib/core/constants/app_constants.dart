class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://ggjptiveqqqubrhtdniy.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdnanB0aXZlcXFxdWJyaHRkbml5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ2NzI3ODQsImV4cCI6MjA3MDI0ODc4NH0.gTQWYjeQ2QVSKCS-xixdp8I8se8cfg1J5hDZLS3ohps';
  
  // App Information
  static const String appName = 'AI Web Builders Hub';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Comprehensive platform for AI-powered web building tools';
  
  // API Endpoints
  static const String toolsTable = 'tools';
  static const String categoriesTable = 'categories';
  static const String favoritesTable = 'favorites';
  static const String ratingsTable = 'ratings';
  static const String usersTable = 'users';
  
  // UI Constants
  static const double gridSpacing = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Grid Layout
  static const int mobileGridColumns = 2;
  static const int tabletGridColumns = 3;
  static const int desktopGridColumns = 4;
  
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Cache Keys
  static const String themeModeKey = 'theme_mode';
  static const String favoritesKey = 'favorites';
  static const String userDataKey = 'user_data';
  
  // Default Values
  static const String defaultToolImage = 'assets/images/default_tool.png';
  static const String appLogo = 'assets/images/app_logo.png';
}