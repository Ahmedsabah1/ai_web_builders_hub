import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/tool.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/tool_card.dart';
import '../webview/webview_screen.dart';

class CategoryToolsScreen extends ConsumerWidget {
  final Category category;

  const CategoryToolsScreen({
    super.key,
    required this.category,
  });

  int _getGridColumns(double screenWidth) {
    if (screenWidth >= AppConstants.desktopBreakpoint) {
      return AppConstants.desktopGridColumns;
    } else if (screenWidth >= AppConstants.tabletBreakpoint) {
      return AppConstants.tabletGridColumns;
    } else {
      return AppConstants.mobileGridColumns;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = _getGridColumns(screenWidth);
    final categoryToolsAsync = ref.watch(toolsByCategoryProvider(category.id));
    final currentUser = ref.watch(currentUserProvider);
    
    final categoryColor = category.color != null
        ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: categoryColor.withOpacity(0.1),
        foregroundColor: categoryColor,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(toolsByCategoryProvider(category.id));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: categoryToolsAsync.when(
        data: (tools) {
          if (tools.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.web_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tools in this category',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new additions',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Category Header
              Container(
                width: double.infinity,
                color: categoryColor.withOpacity(0.05),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            _getCategoryIcon(category.name),
                            size: 24,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                              Text(
                                '${tools.length} tool${tools.length == 1 ? '' : 's'}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (category.description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        category.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Tools Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: MasonryGridView.count(
                    crossAxisCount: columns,
                    mainAxisSpacing: AppConstants.gridSpacing,
                    crossAxisSpacing: AppConstants.gridSpacing,
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      final tool = tools[index];
                      
                      return ToolCard(
                        tool: tool,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: tool.url,
                                title: tool.name,
                                tool: tool,
                              ),
                            ),
                          );
                        },
                        onFavoriteToggle: currentUser != null
                            ? () async {
                                try {
                                  final toolRepository = ref.read(toolRepositoryProvider);
                                  if (tool.isFavorite) {
                                    await toolRepository.removeFromFavorites(
                                      currentUser.id,
                                      tool.id,
                                    );
                                  } else {
                                    await toolRepository.addToFavorites(
                                      currentUser.id,
                                      tool.id,
                                    );
                                  }
                                  // Refresh the providers
                                  ref.invalidate(toolsByCategoryProvider(category.id));
                                  ref.invalidate(favoriteToolsProvider);
                                  ref.invalidate(toolsProvider);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading tools',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(toolsByCategoryProvider(category.id));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'website builders':
        return Icons.web;
      case 'development tools':
        return Icons.code;
      case 'design tools':
        return Icons.brush;
      case 'wordpress tools':
        return Icons.pages;
      case 'hosting platforms':
        return Icons.cloud;
      default:
        return Icons.category;
    }
  }
}