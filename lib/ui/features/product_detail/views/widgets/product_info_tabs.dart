import 'package:flutter/material.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';

class ProductInfoTabs extends StatefulWidget {
  final Product product;

  const ProductInfoTabs({super.key, required this.product});

  @override
  State<ProductInfoTabs> createState() => _ProductInfoTabsState();
}

class _ProductInfoTabsState extends State<ProductInfoTabs> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: _TabButton(
                  title: context.l10n.tabDescription,
                  isSelected: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
              ),
              Expanded(
                child: _TabButton(
                  title: context.l10n.tabShippingAndReturns,
                  isSelected: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_activeTab == 0) ...[
          Text(
            product.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (product.dimensions != null)
                Expanded(
                  child: _SpecCard(
                    title: context.l10n.specDimensionsAndWeight,
                    value: product.dimensions!.formattedWithUnit(
                      context.l10n.unitCm,
                    ),
                    subtitle: product.weight != null
                        ? context.l10n.weightGrams(product.weight!)
                        : null,
                  ),
                ),
              if (product.dimensions != null && product.sku != null)
                const SizedBox(width: 10),
              if (product.sku != null)
                Expanded(
                  child: _SpecCard(
                    title: context.l10n.specSku,
                    value: product.sku!,
                    subtitle: product.category,
                  ),
                ),
            ],
          ),
          if (product.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    '#$tag',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (product.reviews.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              context.l10n.reviewsHeader(product.reviews.length),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ...product.reviews.map((review) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.reviewerName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: index < review.rating
                                  ? AppTheme.ratingAmber
                                  : AppTheme.border,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      review.comment,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ] else ...[
          _InfoRow(
            icon: Icons.local_shipping_outlined,
            title: context.l10n.infoShipping,
            content:
                product.shippingInformation ?? context.l10n.infoShippingDefault,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.assignment_return_outlined,
            title: context.l10n.infoReturnPolicy,
            content:
                product.returnPolicy ?? context.l10n.infoReturnPolicyDefault,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.shield_outlined,
            title: context.l10n.infoWarranty,
            content:
                product.warrantyInformation ?? context.l10n.infoWarrantyDefault,
          ),
          if (product.minimumOrderQuantity != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.shopping_basket_outlined,
              title: context.l10n.infoMinOrder,
              content: context.l10n.infoMinOrderValue(
                product.minimumOrderQuantity!,
              ),
            ),
          ],
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _TrustBadge(
                icon: Icons.verified_outlined,
                title: context.l10n.badgeAuthentic,
                subtitle: product.brand != null
                    ? '${product.brand} Official'
                    : 'Official Store',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TrustBadge(
                icon: Icons.credit_card_outlined,
                title: context.l10n.badgeInstallment,
                subtitle: context.l10n.badgeInstallmentSub,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _TrustBadge(
                icon: Icons.replay_rounded,
                title: context.l10n.badgeEasyReturn,
                subtitle: context.l10n.badgeEasyReturnSub,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  const _SpecCard({required this.title, required this.value, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
