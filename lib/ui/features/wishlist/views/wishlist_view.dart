import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/utils/responsive_layout.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/product_card.dart';

class WishlistView extends ConsumerWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(wishlistProvider);
    final allProducts = ref.watch(
      catalogViewModelProvider.select((s) => s.products),
    );

    final wishlistProducts = allProducts
        .where((p) => favoriteIds.contains(p.id))
        .toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = !ResponsiveLayout.isMobile(context);
    final columnCount = ResponsiveLayout.getGridColumnCount(screenWidth);
    final aspectRatio = ResponsiveLayout.getCardAspectRatio(screenWidth);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          context.l10n.wishlistTitle(wishlistProducts.length),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: wishlistProducts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.discountRed.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: AppTheme.discountRed,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.l10n.emptyWishlistTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.emptyWishlistSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(navigationTabProvider.notifier).toCatalog();
                      },
                      icon: const Icon(Icons.grid_view_rounded, size: 18),
                      label: Text(context.l10n.browseProducts),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? columnCount : 2,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    context.push('/products/${product.id}');
                  },
                );
              },
            ),
    );
  }
}
