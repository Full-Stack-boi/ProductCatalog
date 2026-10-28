import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/ui/core/currency_provider.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final allProducts = ref.watch(
      catalogViewModelProvider.select((s) => s.products),
    );

    final cartProductMap = <Product, int>{};
    for (final entry in cartItems.entries) {
      final product = allProducts.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => Product(
          id: entry.key,
          title: 'สินค้า #${entry.key}',
          description: '',
          category: '',
          price: 0,
          discountPercentage: 0,
          rating: 0,
          stock: 99,
          tags: const [],
          reviews: const [],
          images: const [],
          thumbnail: '',
        ),
      );
      cartProductMap[product] = entry.value;
    }

    final subtotal = cartProductMap.entries.fold<double>(
      0.0,
      (sum, entry) => sum + (entry.key.price * entry.value),
    );

    final totalItems = cartItems.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          context.l10n.cartTitle(totalItems),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
              child: Text(
                context.l10n.clearAll,
                style: const TextStyle(color: AppTheme.discountRed),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: cartItems.isEmpty
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
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppTheme.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.l10n.emptyCartTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.emptyCartSubtitle,
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
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartProductMap.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final product = cartProductMap.keys.elementAt(index);
                          final quantity = cartProductMap.values.elementAt(
                            index,
                          );
                          final isMaxStock = quantity >= product.stock;

                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () => context.push(
                                        '/products/${product.id}',
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width: 84,
                                          height: 84,
                                          color: const Color(0xFFF8FAFC),
                                          child: product.thumbnail.isNotEmpty
                                              ? Image.network(
                                                  product.thumbnail,
                                                  fit: BoxFit.contain,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        color:
                                                            AppTheme.textMuted,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.shopping_bag_outlined,
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => context.push(
                                          '/products/${product.id}',
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${product.displayBrand.toUpperCase()} • ${product.category.toUpperCase()}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              product.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.textPrimary,
                                                height: 1.25,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 6,
                                              runSpacing: 4,
                                              children: [
                                                Text(
                                                  ref.formatPrice(
                                                    product.price,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppTheme.primary,
                                                  ),
                                                ),
                                                if (product.hasDiscount) ...[
                                                  Text(
                                                    ref.formatPrice(
                                                      product.originalPrice,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: AppTheme.textMuted,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 1.5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme
                                                          .discountRed
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      context.l10n.discountBadge(
                                                        product
                                                            .discountPercentage
                                                            .round(),
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppTheme
                                                            .discountRed,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              product.isOutOfStock
                                                  ? context.l10n.outOfStock
                                                  : isMaxStock
                                                  ? context.l10n
                                                        .maxStockReached(
                                                          product.stock,
                                                        )
                                                  : product.isLowStock
                                                  ? context.l10n.onlyStockLeft(
                                                      product.stock,
                                                    )
                                                  : context.l10n.inStockCount(
                                                      product.stock,
                                                    ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: product.isOutOfStock
                                                    ? AppTheme.textMuted
                                                    : isMaxStock
                                                    ? AppTheme.discountRed
                                                    : product.isLowStock
                                                    ? AppTheme.discountRed
                                                    : AppTheme.stockGreen,
                                              ),
                                            ),
                                            if (product.shippingInformation !=
                                                    null &&
                                                product
                                                    .shippingInformation!
                                                    .isNotEmpty) ...[
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .local_shipping_outlined,
                                                    size: 12,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      product
                                                          .shippingInformation!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 20,
                                      ),
                                      color: const Color(0xFF94A3B8),
                                      splashRadius: 18,
                                      tooltip:
                                          context.l10n.removeCartItemTooltip,
                                      onPressed: () {
                                        final prevQty = quantity;
                                        ref
                                            .read(cartProvider.notifier)
                                            .deleteItem(product.id);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.l10n
                                                  .removedFromCartSnackbar(
                                                    product.title,
                                                  ),
                                            ),
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            action: SnackBarAction(
                                              label: context.l10n.undo,
                                              onPressed: () {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .addItem(
                                                      product.id,
                                                      prevQty,
                                                    );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 18,
                                  thickness: 1,
                                  color: Color(0xFFF1F5F9),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        context.l10n.lineTotalPrefix(
                                          ref.formatPrice(
                                            product.price * quantity,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.border,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .removeItem(product.id);
                                            },
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                  left: Radius.circular(7),
                                                ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              child: Icon(
                                                Icons.remove_rounded,
                                                size: 15,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 20,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '$quantity',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: isMaxStock
                                                ? null
                                                : () {
                                                    ref
                                                        .read(
                                                          cartProvider.notifier,
                                                        )
                                                        .addItem(product.id);
                                                  },
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                  right: Radius.circular(7),
                                                ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              child: Icon(
                                                Icons.add_rounded,
                                                size: 15,
                                                color: isMaxStock
                                                    ? AppTheme.textMuted
                                                    : AppTheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    MediaQuery.paddingOf(context).bottom + 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppTheme.border)),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  context.l10n.cartSubtotalLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                ref.formatPrice(subtotal),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.l10n.checkoutSnackbar(
                                        ref.formatPrice(subtotal),
                                      ),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Text(context.l10n.checkoutButton),
                            ),
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
