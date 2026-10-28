import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(
      catalogViewModelProvider.select((s) => s.categories),
    );
    final selectedCategories = ref.watch(
      catalogViewModelProvider.select((s) => s.selectedCategories),
    );
    final selectedSlug = ref.watch(
      catalogViewModelProvider.select((s) => s.selectedCategorySlug),
    );

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected =
                selectedSlug == null && selectedCategories.isEmpty;
            return _FilterChip(
              label: context.l10n.allCategory,
              isSelected: isSelected,
              onTap: () {
                ref
                    .read(catalogViewModelProvider.notifier)
                    .selectCategory(null);
              },
            );
          }

          final category = categories[index - 1];
          final isSelected =
              selectedSlug == category.slug ||
              selectedCategories.contains(category.slug);

          return _FilterChip(
            label: category.name,
            isSelected: isSelected,
            onTap: () {
              ref
                  .read(catalogViewModelProvider.notifier)
                  .selectCategory(category.slug);
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
