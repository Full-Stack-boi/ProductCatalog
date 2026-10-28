import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/utils/responsive_layout.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(
      catalogViewModelProvider.select((s) => s.categories),
    );
    final selectedCategory = ref.watch(
      catalogViewModelProvider.select((s) => s.selectedCategorySlug),
    );
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = !ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          context.l10n.categoriesTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? (screenWidth > 900 ? 4 : 3) : 2,
                childAspectRatio: isTablet ? 1.4 : 1.22,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = selectedCategory == null;
                  return _CategoryTile(
                    title: context.l10n.allCategory,
                    subtitle: context.l10n.allCategoriesSubtitle,
                    icon: Icons.apps_rounded,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(catalogViewModelProvider.notifier)
                          .selectCategory(null);
                      ref.read(navigationTabProvider.notifier).toCatalog();
                    },
                  );
                }

                final item = categories[index - 1];
                final isSelected = selectedCategory == item.slug;
                return _CategoryTile(
                  title: item.name,
                  subtitle: item.slug,
                  icon: _getCategoryIcon(item.slug),
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(catalogViewModelProvider.notifier)
                        .selectCategory(item.slug);
                    ref.read(navigationTabProvider.notifier).toCatalog();
                  },
                );
              },
            ),
    );
  }

  IconData _getCategoryIcon(String slug) {
    switch (slug) {
      case 'beauty':
      case 'skin-care':
        return Icons.face_retouching_natural_rounded;
      case 'fragrances':
        return Icons.bubble_chart_outlined;
      case 'furniture':
      case 'home-decoration':
        return Icons.chair_outlined;
      case 'groceries':
      case 'kitchen-accessories':
        return Icons.kitchen_outlined;
      case 'laptops':
      case 'tablets':
        return Icons.laptop_mac_rounded;
      case 'smartphones':
      case 'mobile-accessories':
        return Icons.phone_android_rounded;
      case 'mens-shirts':
      case 'tops':
      case 'womens-dresses':
        return Icons.checkroom_rounded;
      case 'mens-shoes':
      case 'womens-shoes':
        return Icons.directions_walk_rounded;
      case 'mens-watches':
      case 'womens-watches':
        return Icons.watch_rounded;
      case 'sunglasses':
        return Icons.visibility_outlined;
      case 'sports-accessories':
        return Icons.fitness_center_rounded;
      case 'motorcycle':
      case 'vehicle':
        return Icons.directions_car_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primary,
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
