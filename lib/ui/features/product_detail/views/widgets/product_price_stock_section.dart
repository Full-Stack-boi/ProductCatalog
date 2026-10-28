import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/ui/core/currency_provider.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';

class ProductPriceStockSection extends ConsumerStatefulWidget {
  final Product product;
  final ValueChanged<int> onQuantityChanged;

  const ProductPriceStockSection({
    super.key,
    required this.product,
    required this.onQuantityChanged,
  });

  @override
  ConsumerState<ProductPriceStockSection> createState() =>
      _ProductPriceStockSectionState();
}

class _ProductPriceStockSectionState
    extends ConsumerState<ProductPriceStockSection> {
  int _unaddedQuantity = 1;
  int _selectedOptionIndex = 0;

  void _increment() {
    final inCartQty = ref.read(cartProvider)[widget.product.id] ?? 0;
    final current = inCartQty > 0 ? inCartQty : _unaddedQuantity;
    if (current >= widget.product.stock) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.stockLimitExceededSnackbar(
              widget.product.title,
              widget.product.stock,
            ),
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (inCartQty > 0) {
      ref.read(cartProvider.notifier).addItem(widget.product.id);
      widget.onQuantityChanged(inCartQty + 1);
    } else {
      setState(() {
        _unaddedQuantity++;
      });
      widget.onQuantityChanged(_unaddedQuantity);
    }
  }

  void _decrement() {
    final inCartQty = ref.read(cartProvider)[widget.product.id] ?? 0;
    if (inCartQty > 0) {
      ref.read(cartProvider.notifier).removeItem(widget.product.id);
      final remaining = inCartQty - 1;
      if (remaining == 0) {
        setState(() {
          _unaddedQuantity = 1;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.removedFromCartSnackbar(widget.product.title),
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      widget.onQuantityChanged(remaining > 0 ? remaining : 1);
    } else {
      if (_unaddedQuantity > 1) {
        setState(() {
          _unaddedQuantity--;
        });
        widget.onQuantityChanged(_unaddedQuantity);
      }
    }
  }

  List<String> get _options {
    final availableColors = widget.product.tags.where((tag) {
      final t = tag.toLowerCase();
      return t == 'black' ||
          t == 'white' ||
          t == 'silver' ||
          t == 'gold' ||
          t == 'blue' ||
          t == 'red' ||
          t == 'green';
    }).toList();
    if (availableColors.isNotEmpty) {
      return availableColors
          .map((c) => c[0].toUpperCase() + c.substring(1))
          .toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final inCartQuantity = ref.watch(cartProvider)[product.id] ?? 0;
    final currentQuantity = inCartQuantity > 0
        ? inCartQuantity
        : _unaddedQuantity;
    final isMaxStock = currentQuantity >= product.stock;
    final canIncrement = !product.isOutOfStock && !isMaxStock;
    final canDecrement = inCartQuantity > 0 || _unaddedQuantity > 1;
    final isFavorite = ref.watch(
      wishlistProvider.select((set) => set.contains(product.id)),
    );
    final options = _options;
    final selectedOption = options.isNotEmpty
        ? options[_selectedOptionIndex % options.length]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${product.displayBrand} • ${product.category}${product.sku != null ? ' • SKU: ${product.sku}' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? AppTheme.discountRed : AppTheme.textMuted,
              ),
              onPressed: () {
                ref.read(wishlistProvider.notifier).toggle(product.id);
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.ratingAmber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppTheme.ratingAmber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.reviewsCount(
                      product.rating.toStringAsFixed(1),
                      product.reviews.length,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (product.warrantyInformation != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 14,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.warrantyInformation!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  Text(
                    ref.formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  if (product.hasDiscount) ...[
                    Text(
                      ref.formatPrice(product.originalPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        context.l10n.saveAmount(
                          ref.formatPrice(product.savedAmount),
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16,
                        color: product.isOutOfStock
                            ? AppTheme.discountRed
                            : AppTheme.stockGreen,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          product.isOutOfStock
                              ? context.l10n.temporarilyOutOfStock
                              : context.l10n.readyToShipWithStatus(
                                  product.availabilityStatus ??
                                      '${product.stock}',
                                ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: product.isOutOfStock
                                ? AppTheme.discountRed
                                : AppTheme.stockGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (product.shippingInformation != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            product.shippingInformation!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (options.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                context.l10n.colorOrOption,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                selectedOption,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(options.length, (idx) {
              final isSel = idx == _selectedOptionIndex;
              final opt = options[idx];
              return InkWell(
                onTap: () => setState(() => _selectedOptionIndex = idx),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFF1F5F9) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSel ? const Color(0xFF0F172A) : AppTheme.border,
                      width: isSel ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSel
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        opt,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.quantityLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (inCartQuantity > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      context.l10n.inCartIndicator(inCartQuantity),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
                if (isMaxStock) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.discountRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      context.l10n.maxStockReachedBanner,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.discountRed,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: canDecrement ? _decrement : null,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 36),
                    alignment: Alignment.center,
                    child: Text(
                      currentQuantity.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: canIncrement ? _increment : null,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
