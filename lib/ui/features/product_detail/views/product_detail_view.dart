import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/utils/responsive_layout.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/core/skeleton_product_grid.dart';
import 'package:product_catalog/ui/core/state_views.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';
import 'package:product_catalog/ui/features/product_detail/view_models/product_detail_view_model.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_bottom_bar.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_image_gallery.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_info_tabs.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_price_stock_section.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final int productId;
  final VoidCallback? onClose;

  const ProductDetailView({super.key, required this.productId, this.onClose});

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(productDetailProvider(widget.productId));
    final isTabletOrDesktop = !ResponsiveLayout.isMobile(context);
    final inCartQuantity = ref.watch(cartProvider)[widget.productId] ?? 0;
    final effectiveQuantity = inCartQuantity > 0
        ? inCartQuantity
        : _selectedQuantity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.l10n.productDetailsTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        leading: widget.onClose != null
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 22),
                onPressed: widget.onClose,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    ref.read(navigationTabProvider.notifier).toCatalog();
                  }
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: context.l10n.shareTooltip,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.shareSuccessSnackbar),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: detailAsync.when(
        loading: () => const SkeletonProductDetail(),
        error: (error, _) => DioErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(productDetailProvider(widget.productId));
          },
        ),
        data: (product) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(productDetailProvider(widget.productId));
                    await ref.read(
                      productDetailProvider(widget.productId).future,
                    );
                  },
                  child: isTabletOrDesktop && widget.onClose == null
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1100),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ProductImageGallery(
                                      product: product,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ProductPriceStockSection(
                                          product: product,
                                          onQuantityChanged: (q) {
                                            setState(
                                              () => _selectedQuantity = q,
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        ProductInfoTabs(product: product),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductImageGallery(product: product),
                              const SizedBox(height: 20),
                              ProductPriceStockSection(
                                product: product,
                                onQuantityChanged: (q) {
                                  setState(() => _selectedQuantity = q);
                                },
                              ),
                              const SizedBox(height: 24),
                              ProductInfoTabs(product: product),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                ),
              ),
              ProductBottomBar(product: product, quantity: effectiveQuantity),
            ],
          );
        },
      ),
    );
  }
}
