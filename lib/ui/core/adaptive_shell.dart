import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/utils/responsive_layout.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/cart/views/cart_view.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';
import 'package:product_catalog/ui/features/catalog/views/catalog_view.dart';
import 'package:product_catalog/ui/features/categories/views/categories_view.dart';
import 'package:product_catalog/ui/features/profile/views/profile_view.dart';
import 'package:product_catalog/ui/features/wishlist/views/wishlist_view.dart';

class AdaptiveShell extends ConsumerWidget {
  final Widget? child;

  const AdaptiveShell({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navigationTabProvider);
    final isDesktopOrTablet = !ResponsiveLayout.isMobile(context);
    final cartCount = ref.watch(
      cartProvider.select((c) => c.values.fold(0, (sum, val) => sum + val)),
    );
    final wishlistCount = ref.watch(wishlistProvider.select((w) => w.length));

    final currentBody = IndexedStack(
      index: currentTab.index,
      children: [
        child ?? const CatalogView(),
        const CategoriesView(),
        const WishlistView(),
        const ProfileView(),
        const CartView(),
      ],
    );

    final Widget content;

    if (isDesktopOrTablet) {
      final railIndex = currentTab.index;
      content = Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: railIndex,
              groupAlignment: 0.0,
              onDestinationSelected: (index) {
                ref.read(navigationTabProvider.notifier).setTabIndex(index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.grid_view_outlined),
                  selectedIcon: const Icon(Icons.grid_view_rounded),
                  label: Text(context.l10n.navCatalog),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.category_outlined),
                  selectedIcon: const Icon(Icons.category_rounded),
                  label: Text(context.l10n.navCategories),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: wishlistCount > 0,
                    label: Text(wishlistCount.toString()),
                    child: const Icon(Icons.favorite_border_rounded),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: wishlistCount > 0,
                    label: Text(wishlistCount.toString()),
                    child: const Icon(Icons.favorite_rounded),
                  ),
                  label: Text(context.l10n.navWishlist),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: Text(context.l10n.navProfile),
                ),
                NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text(cartCount.toString()),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text(cartCount.toString()),
                    child: const Icon(Icons.shopping_cart_rounded),
                  ),
                  label: Text(context.l10n.navCart),
                ),
              ],
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppTheme.border,
            ),
            Expanded(child: currentBody),
          ],
        ),
      );
    } else {
      final barIndex = currentTab == NavigationTab.cart ? 0 : currentTab.index;

      content = Scaffold(
        body: currentBody,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
          ),
          child: NavigationBar(
            selectedIndex: barIndex,
            onDestinationSelected: (index) {
              ref.read(navigationTabProvider.notifier).setTabIndex(index);
            },
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFF1F5F9),
            destinations: [
              NavigationDestination(
                icon: const Icon(
                  Icons.grid_view_outlined,
                  color: AppTheme.textSecondary,
                ),
                selectedIcon: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xFF0F172A),
                ),
                label: context.l10n.navCatalog,
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.category_outlined,
                  color: AppTheme.textSecondary,
                ),
                selectedIcon: const Icon(
                  Icons.category_rounded,
                  color: Color(0xFF0F172A),
                ),
                label: context.l10n.navCategories,
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: wishlistCount > 0,
                  label: Text(wishlistCount.toString()),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    color: AppTheme.textSecondary,
                  ),
                ),
                selectedIcon: Badge(
                  isLabelVisible: wishlistCount > 0,
                  label: Text(wishlistCount.toString()),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFF0F172A),
                  ),
                ),
                label: context.l10n.navWishlist,
              ),
              NavigationDestination(
                icon: const Icon(
                  Icons.person_outline_rounded,
                  color: AppTheme.textSecondary,
                ),
                selectedIcon: const Icon(
                  Icons.person_rounded,
                  color: Color(0xFF0F172A),
                ),
                label: context.l10n.navProfile,
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: currentTab == NavigationTab.catalog,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentTab != NavigationTab.catalog) {
          ref.read(navigationTabProvider.notifier).toCatalog();
        }
      },
      child: content,
    );
  }
}
