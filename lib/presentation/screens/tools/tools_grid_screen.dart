import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/tool_card.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/category_filter_chips.dart';
import '../webview/webview_screen.dart';

class ToolsGridScreen extends ConsumerStatefulWidget {
  const ToolsGridScreen({super.key});

  @override
  ConsumerState<ToolsGridScreen> createState() => _ToolsGridScreenState();
}

class _ToolsGridScreenState extends ConsumerState<ToolsGridScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = _getGridColumns(screenWidth);
    final filteredTools = ref.watch(filteredToolsProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          const Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: CustomSearchBar(),
          ),
          
          // Category Filter Chips
          const CategoryFilterChips(),
          
          // Tools Grid
          Expanded(
            child: filteredTools.when(
              data: (tools) {
                if (tools.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.isNotEmpty || selectedCategory != null
                              ? Icons.search_off
                              : Icons.web_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty || selectedCategory != null
                              ? 'No tools found'
                              : 'No tools available',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (searchQuery.isNotEmpty || selectedCategory != null) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              ref.read(searchQueryProvider.notifier).state = '';
                              ref.read(selectedCategoryProvider.notifier).state = null;
                            },
                            child: const Text('Clear filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: MasonryGridView.count(
                    controller: _scrollController,
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
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final errorColor = Theme.of(context).colorScheme.error;
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
                                  ref.invalidate(toolsProvider);
                                  ref.invalidate(favoriteToolsProvider);
                                } catch (e) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: errorColor,
                                    ),
                                  );
                                }
                              }
                            : null,
                      );
                    },
                  ),
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
                        ref.invalidate(toolsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}