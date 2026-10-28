import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';

class ProductBottomBar extends ConsumerWidget {
  final Product product;
  final int quantity;

  const ProductBottomBar({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inCartQuantity = ref.watch(cartProvider)[product.id] ?? 0;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF0F172A),
                size: 20,
              ),
              tooltip: context.l10n.contactSupportTooltip,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.contactSupportSnackbar),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: product.isOutOfStock
                    ? null
                    : () {
                        if (inCartQuantity > 0) {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/');
                          }
                          ref.read(navigationTabProvider.notifier).toCart();
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .addItem(product.id, quantity);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.addedItemsToCartSnackbar(quantity),
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                icon: Icon(
                  inCartQuantity > 0
                      ? Icons.shopping_cart_checkout_rounded
                      : Icons.shopping_bag_outlined,
                  size: 18,
                  color: inCartQuantity > 0
                      ? AppTheme.primary
                      : const Color(0xFF0F172A),
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    inCartQuantity > 0
                        ? context.l10n.viewCartButton(inCartQuantity)
                        : context.l10n.addToCartButton,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: inCartQuantity > 0
                          ? AppTheme.primary
                          : const Color(0xFF0F172A),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: inCartQuantity > 0
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : const Color(0xFFF1F5F9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: inCartQuantity > 0
                        ? const BorderSide(color: AppTheme.primary, width: 1)
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: product.isOutOfStock
                    ? null
                    : () {
                        if (inCartQuantity == 0) {
                          ref
                              .read(cartProvider.notifier)
                              .addItem(product.id, quantity);
                        }
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.buyNowCheckoutSnackbar(
                                product.title,
                              ),
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                        ref.read(navigationTabProvider.notifier).toCart();
                      },
                icon: const Icon(
                  Icons.bolt_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    context.l10n.buyNowButton,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: const Color(0xFF2563EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
