import 'package:product_catalog/l10n/app_localizations.dart';

enum ProductSortOption {
  popular(apiSortBy: null, apiOrder: null),
  ratingDesc(apiSortBy: 'rating', apiOrder: 'desc'),
  priceAsc(apiSortBy: 'price', apiOrder: 'asc'),
  priceDesc(apiSortBy: 'price', apiOrder: 'desc'),
  titleAsc(apiSortBy: 'title', apiOrder: 'asc');

  final String? apiSortBy;
  final String? apiOrder;

  const ProductSortOption({required this.apiSortBy, required this.apiOrder});

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ProductSortOption.popular:
        return l10n.sortPopular;
      case ProductSortOption.ratingDesc:
        return l10n.sortRatingDesc;
      case ProductSortOption.priceAsc:
        return l10n.sortPriceAsc;
      case ProductSortOption.priceDesc:
        return l10n.sortPriceDesc;
      case ProductSortOption.titleAsc:
        return l10n.sortTitleAsc;
    }
  }
}
