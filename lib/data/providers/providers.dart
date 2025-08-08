import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/tool_repository.dart';
import '../repositories/auth_repository.dart';
import '../models/tool.dart';
import '../models/user.dart';

// Repository Providers
final toolRepositoryProvider = Provider<ToolRepository>((ref) {
  return ToolRepository();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth Providers
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

// Tools Providers
final toolsProvider = FutureProvider<List<Tool>>((ref) async {
  final toolRepository = ref.watch(toolRepositoryProvider);
  return await toolRepository.getTools();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final toolRepository = ref.watch(toolRepositoryProvider);
  return await toolRepository.getCategories();
});

final toolsByCategoryProvider = FutureProvider.family<List<Tool>, String>((ref, categoryId) async {
  final toolRepository = ref.watch(toolRepositoryProvider);
  return await toolRepository.getToolsByCategory(categoryId);
});

final searchToolsProvider = FutureProvider.family<List<Tool>, String>((ref, query) async {
  final toolRepository = ref.watch(toolRepositoryProvider);
  if (query.isEmpty) {
    return await toolRepository.getTools();
  }
  return await toolRepository.searchTools(query);
});

final favoriteToolsProvider = FutureProvider<List<Tool>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  
  final toolRepository = ref.watch(toolRepositoryProvider);
  return await toolRepository.getFavoriteTools(user.id);
});

// UI State Providers
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

final themeProvider = StateProvider<bool>((ref) => false); // false = light, true = dark

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Filtered Tools Provider
final filteredToolsProvider = Provider<AsyncValue<List<Tool>>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  if (selectedCategory != null) {
    return ref.watch(toolsByCategoryProvider(selectedCategory));
  } else if (searchQuery.isNotEmpty) {
    return ref.watch(searchToolsProvider(searchQuery));
  } else {
    return ref.watch(toolsProvider);
  }
});