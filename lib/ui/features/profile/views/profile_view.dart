import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/l10n/app_localizations.dart';
import 'package:product_catalog/ui/core/currency_provider.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/locale_provider.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistCount = ref.watch(wishlistProvider.select((w) => w.length));
    final cartCount = ref.watch(
      cartProvider.select((c) => c.values.fold(0, (sum, val) => sum + val)),
    );
    final currentLocale = ref.watch(localeProvider);
    final currencyState = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          context.l10n.profileTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFF1F5F9),
                  child: Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nattawut (Customer)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'member@catalogx.com',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.memberStatus,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: context.l10n.savedItemsStat,
                  value: '$wishlistCount',
                  icon: Icons.favorite_border_rounded,
                  iconColor: AppTheme.discountRed,
                  onTap: () =>
                      ref.read(navigationTabProvider.notifier).toWishlist(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickStatCard(
                  title: context.l10n.inCartStat,
                  value: '$cartCount',
                  icon: Icons.shopping_cart_outlined,
                  iconColor: AppTheme.primary,
                  onTap: () =>
                      ref.read(navigationTabProvider.notifier).toCart(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.border),
            ),
            child: Column(
              children: [
                _ProfileListTile(
                  icon: Icons.receipt_long_outlined,
                  title: context.l10n.orderHistoryTitle,
                  subtitle: context.l10n.orderHistorySubtitle,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.orderHistorySnackbar),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.location_on_outlined,
                  title: context.l10n.shippingAddressTitle,
                  subtitle: context.l10n.shippingAddressSubtitle,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.credit_card_outlined,
                  title: context.l10n.paymentMethodsTitle,
                  subtitle: context.l10n.paymentMethodsSubtitle,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.language_rounded,
                  title: context.l10n.languageTitle,
                  subtitle: context.l10n.languageSubtitle(
                    currentLocale.nativeDisplayName,
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentLocale.languageCode.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  onTap: () => _showLanguageDialog(context, ref, currentLocale),
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.payments_outlined,
                  title: context.l10n.currencyTitle,
                  subtitle: context.l10n.currencySubtitle(
                    '${currencyState.currency.code} (${currencyState.currency.symbol})',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currencyState.currency.code,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  onTap: () => _showCurrencyDialog(context, ref, currencyState),
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.help_outline_rounded,
                  title: context.l10n.helpCenterTitle,
                  subtitle: context.l10n.helpCenterSubtitle,
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, color: AppTheme.border),
                _ProfileListTile(
                  icon: Icons.info_outline_rounded,
                  title: context.l10n.aboutAppTitle,
                  subtitle: context.l10n.aboutAppSubtitle,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sign out'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(context.l10n.signOutTitle),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppTheme.background,
              backgroundColor: AppTheme.discountRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(context.l10n.languageTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocalizations.supportedLocales.map((locale) {
              final isSelected =
                  currentLocale.languageCode == locale.languageCode;
              return ListTile(
                title: Text(locale.nativeDisplayName),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.primary,
                      )
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(locale);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    CurrencyState currencyState,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final liveCurrencyState = ref.watch(currencyProvider);
            final rateFormatted = liveCurrencyState.usdToThbRate
                .toStringAsFixed(2);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.l10n.currencyTitle),
                  if (liveCurrencyState.isFetching)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.sync_rounded, size: 20),
                      tooltip: context.l10n.refreshExchangeRateTooltip,
                      onPressed: () async {
                        await ref
                            .read(currencyProvider.notifier)
                            .refreshLiveRate();
                        if (context.mounted) {
                          final newRate = ref
                              .read(currencyProvider)
                              .usdToThbRate
                              .toStringAsFixed(2);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.exchangeRateUpdatedSnackbar(
                                  newRate,
                                ),
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.currencyExchangeRateNotice(
                            rateFormatted,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: liveCurrencyState.isLive
                                    ? AppTheme.stockGreen
                                    : AppTheme.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                liveCurrencyState.isLive
                                    ? context.l10n.dailyExchangeRateBadge
                                    : context.l10n.fallbackExchangeRateBadge,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: liveCurrencyState.isLive
                                      ? AppTheme.stockGreen
                                      : AppTheme.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (liveCurrencyState.rateDate != null &&
                                liveCurrencyState.rateDate!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  context.l10n.exchangeRateAsOfDate(
                                    liveCurrencyState.rateDate!,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ...AppCurrency.values.map((currency) {
                    final isSelected = liveCurrencyState.currency == currency;
                    return ListTile(
                      title: Text(
                        '${currency.symbol} ${currency.localizedName(context.l10n)} (${currency.code})',
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.primary,
                            )
                          : null,
                      onTap: () {
                        ref
                            .read(currencyProvider.notifier)
                            .setCurrency(currency);
                        Navigator.pop(ctx);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF0F172A), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
      trailing:
          trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textMuted,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}
