import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/tool_card.dart';
import '../webview/webview_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

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
    final favoriteToolsAsync = ref.watch(favoriteToolsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(favoriteToolsProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: favoriteToolsAsync.when(
        data: (favoriteTools) {
          if (favoriteTools.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any tool to add it to your favorites',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Switch to home tab
                      ref.read(bottomNavIndexProvider.notifier).state = 0;
                    },
                    child: const Text('Browse Tools'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Favorites Count
                Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                  child: Text(
                    '${favoriteTools.length} favorite${favoriteTools.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Favorites Grid
                Expanded(
                  child: MasonryGridView.count(
                    crossAxisCount: columns,
                    mainAxisSpacing: AppConstants.gridSpacing,
                    crossAxisSpacing: AppConstants.gridSpacing,
                    itemCount: favoriteTools.length,
                    itemBuilder: (context, index) {
                      final tool = favoriteTools[index].copyWith(isFavorite: true);
                      
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
                                  await toolRepository.removeFromFavorites(
                                    currentUser.id,
                                    tool.id,
                                  );
                                  
                                  // Show confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${tool.name} removed from favorites'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () async {
                                          try {
                                            await toolRepository.addToFavorites(
                                              currentUser.id,
                                              tool.id,
                                            );
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
                                        },
                                      ),
                                    ),
                                  );
                                  
                                  // Refresh the providers
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
              ],
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
                'Error loading favorites',
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
                  ref.invalidate(favoriteToolsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}