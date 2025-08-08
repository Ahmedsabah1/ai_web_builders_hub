import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../core/constants/app_constants.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1, // +1 for "All" chip
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" chip
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: selectedCategory == null,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(selectedCategoryProvider.notifier).state = null;
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: selectedCategory == null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: selectedCategory == null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              }

              final category = categories[index - 1];
              final isSelected = selectedCategory == category.id;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(selectedCategoryProvider.notifier).state =
                        selected ? category.id : null;
                  },
                  backgroundColor: category.color != null
                      ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                          .withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  selectedColor: category.color != null
                      ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                          .withOpacity(0.3)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: category.color != null
                      ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                      : Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? (category.color != null
                            ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                            : Theme.of(context).colorScheme.primary)
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  avatar: category.toolCount > 0
                      ? CircleAvatar(
                          backgroundColor: category.color != null
                              ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                                  .withOpacity(0.2)
                              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          radius: 10,
                          child: Text(
                            category.toolCount.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: category.color != null
                                  ? Color(int.parse('0xFF${category.color!.replaceAll('#', '')}'))
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
        );
      },
      loading: () => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}