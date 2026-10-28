// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CatalogX';

  @override
  String get pullToRefresh => 'Pull down to refresh';

  @override
  String get retry => 'Retry';

  @override
  String get undo => 'Undo';

  @override
  String get clearAll => 'Clear All';

  @override
  String get loading => 'Loading...';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navCategories => 'Categories';

  @override
  String get navWishlist => 'Wishlist';

  @override
  String get navProfile => 'Profile';

  @override
  String get navCart => 'Cart';

  @override
  String get searchHint => 'Search products, brands, or categories...';

  @override
  String get searchVoiceStarting => 'Starting voice search...';

  @override
  String get allCategory => 'All';

  @override
  String showingCountOfTotal(int loaded, int total) {
    return 'Showing $loaded of $total items';
  }

  @override
  String get clearSearchAndFilters => 'Clear search and filters';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortPopular => 'Popular';

  @override
  String get sortRatingDesc => 'Top Rated';

  @override
  String get sortPriceAsc => 'Price: Low to High';

  @override
  String get sortPriceDesc => 'Price: High to Low';

  @override
  String get sortTitleAsc => 'Name A - Z';

  @override
  String get filterTooltip => 'Filter';

  @override
  String pageOfTotal(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String loadedOfTotal(int loaded, int total) {
    return 'Loaded $loaded of $total items';
  }

  @override
  String get loadingMore => 'Loading next page...';

  @override
  String get loadMoreButton => 'Load more products...';

  @override
  String get retryLoadMore => 'Try again';

  @override
  String get allLoaded => 'All products loaded';

  @override
  String discountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get outOfStock => '• Out of stock';

  @override
  String get outOfStockBadge => 'Out of stock';

  @override
  String maxStockReached(int stock) {
    return '• Max stock ($stock items)';
  }

  @override
  String maxStockReachedShort(int stock) {
    return '• Max stock ($stock)';
  }

  @override
  String onlyStockLeft(int stock) {
    return '• Only $stock left!';
  }

  @override
  String inStockCount(int stock) {
    return '• In stock ($stock items)';
  }

  @override
  String inStockCountShort(int stock) {
    return '• In stock ($stock)';
  }

  @override
  String get addToCartTooltip => 'Add to cart';

  @override
  String get reduceQuantityTooltip => 'Decrease quantity';

  @override
  String get increaseQuantityTooltip => 'Increase quantity';

  @override
  String get maxStockTooltip => 'Maximum stock reached';

  @override
  String addedToCartSnackbar(String title) {
    return 'Added \"$title\" to cart';
  }

  @override
  String cartTitle(int count) {
    return 'Cart ($count)';
  }

  @override
  String get emptyCartTitle => 'Your cart is empty';

  @override
  String get emptyCartSubtitle =>
      'Explore products you like and add them to your cart';

  @override
  String get browseProducts => 'Browse Products';

  @override
  String get removeCartItemTooltip => 'Remove this item';

  @override
  String removedFromCartSnackbar(String title) {
    return 'Removed \"$title\" from cart';
  }

  @override
  String lineTotalPrefix(String amount) {
    return 'Subtotal $amount';
  }

  @override
  String get cartSubtotalLabel => 'Subtotal';

  @override
  String get checkoutButton => 'Proceed to Checkout';

  @override
  String checkoutSnackbar(String amount) {
    return 'Proceeding to checkout, total $amount';
  }

  @override
  String wishlistTitle(int count) {
    return 'Wishlist ($count)';
  }

  @override
  String get emptyWishlistTitle => 'No saved items';

  @override
  String get emptyWishlistSubtitle =>
      'Tap the heart icon on any product to save it here';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get allCategoriesSubtitle => 'View all products';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get shareSuccessSnackbar => 'Product link shared successfully';

  @override
  String get shareTooltip => 'Share product';

  @override
  String reviewsCount(String rating, int count) {
    return '$rating ($count reviews)';
  }

  @override
  String saveAmount(String amount) {
    return 'Save $amount';
  }

  @override
  String get temporarilyOutOfStock => 'Temporarily out of stock';

  @override
  String readyToShipWithStatus(String status) {
    return 'Ready to ship ($status)';
  }

  @override
  String get colorOrOption => 'Color / Option';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String inCartIndicator(int count) {
    return 'In cart ($count)';
  }

  @override
  String get maxStockReachedBanner => 'Maximum stock reached';

  @override
  String stockLimitExceededSnackbar(String title, int stock) {
    return 'Product \"$title\" only has $stock items in stock';
  }

  @override
  String get contactSupportTooltip => 'Customer Support';

  @override
  String get contactSupportSnackbar => 'Connecting to customer support...';

  @override
  String get addToCartButton => 'Add to Cart';

  @override
  String viewCartButton(int count) {
    return 'View Cart ($count)';
  }

  @override
  String get buyNowButton => 'Buy Now';

  @override
  String buyNowCheckoutSnackbar(String title) {
    return 'Proceeding to checkout for $title';
  }

  @override
  String addedItemsToCartSnackbar(int count) {
    return 'Added $count items to cart';
  }

  @override
  String get tabDescription => 'Description';

  @override
  String get tabShippingAndReturns => 'Shipping & Returns';

  @override
  String get specDimensionsAndWeight => 'Dimensions & Weight';

  @override
  String get specSku => 'SKU';

  @override
  String reviewsHeader(int count) {
    return 'Customer Reviews ($count)';
  }

  @override
  String get infoShipping => 'Shipping Information';

  @override
  String get infoShippingDefault =>
      'Standard delivery within 2-3 business days';

  @override
  String get infoReturnPolicy => 'Return Policy';

  @override
  String get infoReturnPolicyDefault => 'Returns accepted per store conditions';

  @override
  String get infoWarranty => 'Warranty Information';

  @override
  String get infoWarrantyDefault => 'Official manufacturer warranty';

  @override
  String get infoMinOrder => 'Minimum Order Quantity';

  @override
  String infoMinOrderValue(int count) {
    return '$count items';
  }

  @override
  String get badgeAuthentic => '100% Authentic';

  @override
  String get badgeInstallment => '0% Installment';

  @override
  String get badgeInstallmentSub => 'Up to 10 months';

  @override
  String get badgeEasyReturn => 'Easy Returns';

  @override
  String get badgeEasyReturnSub => 'Within 30 days';

  @override
  String get profileTitle => 'Profile';

  @override
  String get memberStatus => 'Gold Member';

  @override
  String get savedItemsStat => 'Wishlist';

  @override
  String get inCartStat => 'In Cart';

  @override
  String get orderHistoryTitle => 'Order History';

  @override
  String get orderHistorySubtitle => 'Check order status and tracking';

  @override
  String get orderHistorySnackbar => 'Opening order history...';

  @override
  String get shippingAddressTitle => 'Shipping Addresses';

  @override
  String get shippingAddressSubtitle => 'Manage shipping and billing addresses';

  @override
  String get paymentMethodsTitle => 'Payment Methods';

  @override
  String get paymentMethodsSubtitle => 'Credit/Debit cards & PromptPay';

  @override
  String get languageTitle => 'Language';

  @override
  String languageSubtitle(String language) {
    return 'Current: $language';
  }

  @override
  String get appLanguageName => 'English';

  @override
  String get currencyNameThb => 'Thai Baht';

  @override
  String get currencyNameUsd => 'US Dollar';

  @override
  String get currencyTitle => 'Currency';

  @override
  String currencySubtitle(String currency) {
    return 'Current: $currency';
  }

  @override
  String currencyExchangeRateNotice(String rate) {
    return 'Exchange rate: 1 USD = $rate THB';
  }

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpCenterSubtitle => 'FAQs and Customer Service';

  @override
  String get aboutAppTitle => 'About Application';

  @override
  String get aboutAppSubtitle => 'Version 0.1.0 (Build 1)';

  @override
  String get signOutTitle => 'Sign Out';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterClearAll => 'Reset All';

  @override
  String get filterResetSnackbar => 'All filters have been reset';

  @override
  String get priceRangeTitle => 'Price Range';

  @override
  String get minRatingTitle => 'Minimum Rating';

  @override
  String get ratingAny => 'Any';

  @override
  String ratingAndAbove(String rating) {
    return '$rating ★ and above';
  }

  @override
  String get inStockOnlyTitle => 'In-stock items only';

  @override
  String get applyFiltersButton => 'Apply Filters';

  @override
  String get loadErrorTitle => 'Unable to load data';

  @override
  String get emptyProductsTitle => 'No products found';

  @override
  String get emptyProductsDefaultMessage => 'No products match your criteria';

  @override
  String noProductsMatchingQuery(String query) {
    return 'No products found matching \"$query\"';
  }

  @override
  String get noProductsMatchingFilters => 'No products match selected filters';

  @override
  String get switchLanguageTooltip => 'Switch language';

  @override
  String get categoriesFilterTitle => 'Categories';

  @override
  String get clearCategorySelection => 'Clear';

  @override
  String get clearFiltersChip => 'Clear filters';

  @override
  String get unitCm => 'cm';

  @override
  String weightGrams(int weight) {
    return '$weight g';
  }

  @override
  String get dailyExchangeRateBadge => 'Daily Reference Rate';

  @override
  String get fallbackExchangeRateBadge => 'Offline (Default)';

  @override
  String exchangeRateAsOfDate(String date) {
    return 'As of $date';
  }

  @override
  String get refreshExchangeRateTooltip => 'Refresh live exchange rate';

  @override
  String exchangeRateUpdatedSnackbar(String rate) {
    return 'Exchange rate updated: 1 USD = $rate THB';
  }
}
