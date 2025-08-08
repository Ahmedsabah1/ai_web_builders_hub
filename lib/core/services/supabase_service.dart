import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();
  
  SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }
  
  // Authentication methods
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await client.auth.signOut();
  }
  
  User? get currentUser => client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
  
  // Tools methods
  Future<List<Map<String, dynamic>>> getTools() async {
    final response = await client
        .from(AppConstants.toolsTable)
        .select('*, categories(name, color)')
        .order('name');
    return response;
  }
  
  Future<List<Map<String, dynamic>>> getToolsByCategory(String categoryId) async {
    final response = await client
        .from(AppConstants.toolsTable)
        .select('*, categories(name, color)')
        .eq('category_id', categoryId)
        .order('name');
    return response;
  }
  
  Future<Map<String, dynamic>> getTool(String toolId) async {
    final response = await client
        .from(AppConstants.toolsTable)
        .select('*, categories(name, color)')
        .eq('id', toolId)
        .single();
    return response;
  }
  
  // Categories methods
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from(AppConstants.categoriesTable)
        .select()
        .order('name');
    return response;
  }
  
  // Favorites methods
  Future<List<Map<String, dynamic>>> getUserFavorites(String userId) async {
    final response = await client
        .from(AppConstants.favoritesTable)
        .select('tool_id, tools(*, categories(name, color))')
        .eq('user_id', userId);
    return response;
  }
  
  Future<void> addToFavorites(String userId, String toolId) async {
    await client
        .from(AppConstants.favoritesTable)
        .insert({
          'user_id': userId,
          'tool_id': toolId,
        });
  }
  
  Future<void> removeFromFavorites(String userId, String toolId) async {
    await client
        .from(AppConstants.favoritesTable)
        .delete()
        .eq('user_id', userId)
        .eq('tool_id', toolId);
  }
  
  Future<bool> isFavorite(String userId, String toolId) async {
    final response = await client
        .from(AppConstants.favoritesTable)
        .select()
        .eq('user_id', userId)
        .eq('tool_id', toolId);
    return response.isNotEmpty;
  }
  
  // Ratings methods
  Future<List<Map<String, dynamic>>> getToolRatings(String toolId) async {
    final response = await client
        .from(AppConstants.ratingsTable)
        .select('*, users(email)')
        .eq('tool_id', toolId)
        .order('created_at', ascending: false);
    return response;
  }
  
  Future<void> addRating(String userId, String toolId, double rating, String? review) async {
    await client
        .from(AppConstants.ratingsTable)
        .insert({
          'user_id': userId,
          'tool_id': toolId,
          'rating': rating,
          'review': review,
        });
  }
  
  Future<void> updateRating(String ratingId, double rating, String? review) async {
    await client
        .from(AppConstants.ratingsTable)
        .update({
          'rating': rating,
          'review': review,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', ratingId);
  }
  
  Future<Map<String, dynamic>?> getUserRating(String userId, String toolId) async {
    final response = await client
        .from(AppConstants.ratingsTable)
        .select()
        .eq('user_id', userId)
        .eq('tool_id', toolId);
    return response.isNotEmpty ? response.first : null;
  }
  
  // Search methods
  Future<List<Map<String, dynamic>>> searchTools(String query) async {
    final response = await client
        .from(AppConstants.toolsTable)
        .select('*, categories(name, color)')
        .or('name.ilike.%$query%,description.ilike.%$query%')
        .order('name');
    return response;
  }
  
  // User profile methods
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await client
        .from(AppConstants.usersTable)
        .update(data)
        .eq('id', userId);
  }
  
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from(AppConstants.usersTable)
        .select()
        .eq('id', userId);
    return response.isNotEmpty ? response.first : null;
  }
}