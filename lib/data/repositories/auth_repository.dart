import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import '../../core/services/supabase_service.dart';

class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  Future<AppUser> signUpWithEmail(String email, String password) async {
    try {
      final response = await _supabaseService.signUpWithEmail(email, password);
      if (response.user == null) {
        throw Exception('Sign up failed');
      }
      return AppUser(
        id: response.user!.id,
        email: response.user!.email!,
        createdAt: DateTime.parse(response.user!.createdAt),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseService.signInWithEmail(email, password);
      if (response.user == null) {
        throw Exception('Sign in failed');
      }
      return AppUser(
        id: response.user!.id,
        email: response.user!.email!,
        createdAt: DateTime.parse(response.user!.createdAt),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  AppUser? getCurrentUser() {
    final user = _supabaseService.currentUser;
    if (user == null) return null;
    
    return AppUser(
      id: user.id,
      email: user.email!,
      createdAt: DateTime.parse(user.createdAt),
      updatedAt: DateTime.now(),
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _supabaseService.authStateChanges.map((authState) {
      final user = authState.session?.user;
      if (user == null) return null;
      
      return AppUser(
        id: user.id,
        email: user.email!,
        createdAt: DateTime.parse(user.createdAt),
        updatedAt: DateTime.now(),
      );
    });
  }

  Future<AppUser?> getUserProfile(String userId) async {
    try {
      final response = await _supabaseService.getUserProfile(userId);
      if (response == null) return null;
      return AppUser.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabaseService.updateUserProfile(userId, data);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}