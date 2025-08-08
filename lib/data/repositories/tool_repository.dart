import '../models/tool.dart';
import '../../core/services/supabase_service.dart';

class ToolRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  Future<List<Tool>> getTools() async {
    try {
      final response = await _supabaseService.getTools();
      return response.map((json) => Tool.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tools: $e');
    }
  }

  Future<List<Tool>> getToolsByCategory(String categoryId) async {
    try {
      final response = await _supabaseService.getToolsByCategory(categoryId);
      return response.map((json) => Tool.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tools by category: $e');
    }
  }

  Future<Tool> getTool(String toolId) async {
    try {
      final response = await _supabaseService.getTool(toolId);
      return Tool.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch tool: $e');
    }
  }

  Future<List<Tool>> searchTools(String query) async {
    try {
      final response = await _supabaseService.searchTools(query);
      return response.map((json) => Tool.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search tools: $e');
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _supabaseService.getCategories();
      return response.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Tool>> getFavoriteTools(String userId) async {
    try {
      final response = await _supabaseService.getUserFavorites(userId);
      return response
          .map((item) => Tool.fromJson(item['tools'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite tools: $e');
    }
  }

  Future<void> addToFavorites(String userId, String toolId) async {
    try {
      await _supabaseService.addToFavorites(userId, toolId);
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String toolId) async {
    try {
      await _supabaseService.removeFromFavorites(userId, toolId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  Future<bool> isFavorite(String userId, String toolId) async {
    try {
      return await _supabaseService.isFavorite(userId, toolId);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
}