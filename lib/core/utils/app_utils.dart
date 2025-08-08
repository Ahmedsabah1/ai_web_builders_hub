import 'package:flutter/foundation.dart';

class AppUtils {
  /// Logs debug information only in debug mode
  static void debugLog(String message) {
    if (kDebugMode) {
      print('[AI Web Builders Hub] $message');
    }
  }

  /// Formats error messages for user display
  static String formatErrorMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';
    
    final String errorMessage = error.toString();
    
    // Handle common Supabase errors
    if (errorMessage.contains('Invalid login credentials')) {
      return 'Invalid email or password. Please try again.';
    }
    
    if (errorMessage.contains('User already registered')) {
      return 'An account with this email already exists.';
    }
    
    if (errorMessage.contains('Email not confirmed')) {
      return 'Please check your email and confirm your account.';
    }
    
    if (errorMessage.contains('Network request failed')) {
      return 'Network error. Please check your connection and try again.';
    }
    
    if (errorMessage.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    // Return a generic message for other errors
    return 'Something went wrong. Please try again later.';
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validates password strength
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    if (password.length > 100) {
      return 'Password must be less than 100 characters';
    }
    
    return null; // Password is valid
  }

  /// Generates a color from a string (for categories)
  static int colorFromString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Generate a color with good contrast
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;
    
    // Ensure the color is not too dark or too light
    final adjustedR = ((r * 0.7) + 80).clamp(0, 255).toInt();
    final adjustedG = ((g * 0.7) + 80).clamp(0, 255).toInt();
    final adjustedB = ((b * 0.7) + 80).clamp(0, 255).toInt();
    
    return (0xFF << 24) | (adjustedR << 16) | (adjustedG << 8) | adjustedB;
  }

  /// Truncates text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formats rating to display string
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Checks if URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Gets domain from URL
  static String getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  /// Debounce function for search
  static void debounce(
    Function() action, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    // Simple debounce implementation
    // In a real app, you might want to use a more sophisticated debounce
    Future.delayed(delay, action);
  }
}