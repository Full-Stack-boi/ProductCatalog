import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'CatalogX'**
  String get appName;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get navWishlist;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products, brands, or categories...'**
  String get searchHint;

  /// No description provided for @searchVoiceStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting voice search...'**
  String get searchVoiceStarting;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @showingCountOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Showing {loaded} of {total} items'**
  String showingCountOfTotal(int loaded, int total);

  /// No description provided for @clearSearchAndFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear search and filters'**
  String get clearSearchAndFilters;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortPopular;

  /// No description provided for @sortRatingDesc.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get sortRatingDesc;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceDesc;

  /// No description provided for @sortTitleAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A - Z'**
  String get sortTitleAsc;

  /// No description provided for @filterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTooltip;

  /// No description provided for @pageOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfTotal(int current, int total);

  /// No description provided for @loadedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Loaded {loaded} of {total} items'**
  String loadedOfTotal(int loaded, int total);

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading next page...'**
  String get loadingMore;

  /// No description provided for @loadMoreButton.
  ///
  /// In en, this message translates to:
  /// **'Load more products...'**
  String get loadMoreButton;

  /// No description provided for @retryLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retryLoadMore;

  /// No description provided for @allLoaded.
  ///
  /// In en, this message translates to:
  /// **'All products loaded'**
  String get allLoaded;

  /// No description provided for @discountBadge.
  ///
  /// In en, this message translates to:
  /// **'-{percent}%'**
  String discountBadge(int percent);

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'• Out of stock'**
  String get outOfStock;

  /// No description provided for @outOfStockBadge.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStockBadge;

  /// No description provided for @maxStockReached.
  ///
  /// In en, this message translates to:
  /// **'• Max stock ({stock} items)'**
  String maxStockReached(int stock);

  /// No description provided for @maxStockReachedShort.
  ///
  /// In en, this message translates to:
  /// **'• Max stock ({stock})'**
  String maxStockReachedShort(int stock);

  /// No description provided for @onlyStockLeft.
  ///
  /// In en, this message translates to:
  /// **'• Only {stock} left!'**
  String onlyStockLeft(int stock);

  /// No description provided for @inStockCount.
  ///
  /// In en, this message translates to:
  /// **'• In stock ({stock} items)'**
  String inStockCount(int stock);

  /// No description provided for @inStockCountShort.
  ///
  /// In en, this message translates to:
  /// **'• In stock ({stock})'**
  String inStockCountShort(int stock);

  /// No description provided for @addToCartTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCartTooltip;

  /// No description provided for @reduceQuantityTooltip.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get reduceQuantityTooltip;

  /// No description provided for @increaseQuantityTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantityTooltip;

  /// No description provided for @maxStockTooltip.
  ///
  /// In en, this message translates to:
  /// **'Maximum stock reached'**
  String get maxStockTooltip;

  /// No description provided for @addedToCartSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Added \"{title}\" to cart'**
  String addedToCartSnackbar(String title);

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart ({count})'**
  String cartTitle(int count);

  /// No description provided for @emptyCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCartTitle;

  /// No description provided for @emptyCartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore products you like and add them to your cart'**
  String get emptyCartSubtitle;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get browseProducts;

  /// No description provided for @removeCartItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove this item'**
  String get removeCartItemTooltip;

  /// No description provided for @removedFromCartSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Removed \"{title}\" from cart'**
  String removedFromCartSnackbar(String title);

  /// No description provided for @lineTotalPrefix.
  ///
  /// In en, this message translates to:
  /// **'Subtotal {amount}'**
  String lineTotalPrefix(String amount);

  /// No description provided for @cartSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotalLabel;

  /// No description provided for @checkoutButton.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get checkoutButton;

  /// No description provided for @checkoutSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Proceeding to checkout, total {amount}'**
  String checkoutSnackbar(String amount);

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist ({count})'**
  String wishlistTitle(int count);

  /// No description provided for @emptyWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved items'**
  String get emptyWishlistTitle;

  /// No description provided for @emptyWishlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any product to save it here'**
  String get emptyWishlistSubtitle;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @allCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all products'**
  String get allCategoriesSubtitle;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// No description provided for @shareSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Product link shared successfully'**
  String get shareSuccessSnackbar;

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share product'**
  String get shareTooltip;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{rating} ({count} reviews)'**
  String reviewsCount(String rating, int count);

  /// No description provided for @saveAmount.
  ///
  /// In en, this message translates to:
  /// **'Save {amount}'**
  String saveAmount(String amount);

  /// No description provided for @temporarilyOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Temporarily out of stock'**
  String get temporarilyOutOfStock;

  /// No description provided for @readyToShipWithStatus.
  ///
  /// In en, this message translates to:
  /// **'Ready to ship ({status})'**
  String readyToShipWithStatus(String status);

  /// No description provided for @colorOrOption.
  ///
  /// In en, this message translates to:
  /// **'Color / Option'**
  String get colorOrOption;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @inCartIndicator.
  ///
  /// In en, this message translates to:
  /// **'In cart ({count})'**
  String inCartIndicator(int count);

  /// No description provided for @maxStockReachedBanner.
  ///
  /// In en, this message translates to:
  /// **'Maximum stock reached'**
  String get maxStockReachedBanner;

  /// No description provided for @stockLimitExceededSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Product \"{title}\" only has {stock} items in stock'**
  String stockLimitExceededSnackbar(String title, int stock);

  /// No description provided for @contactSupportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get contactSupportTooltip;

  /// No description provided for @contactSupportSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Connecting to customer support...'**
  String get contactSupportSnackbar;

  /// No description provided for @addToCartButton.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCartButton;

  /// No description provided for @viewCartButton.
  ///
  /// In en, this message translates to:
  /// **'View Cart ({count})'**
  String viewCartButton(int count);

  /// No description provided for @buyNowButton.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNowButton;

  /// No description provided for @buyNowCheckoutSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Proceeding to checkout for {title}'**
  String buyNowCheckoutSnackbar(String title);

  /// No description provided for @addedItemsToCartSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Added {count} items to cart'**
  String addedItemsToCartSnackbar(int count);

  /// No description provided for @tabDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get tabDescription;

  /// No description provided for @tabShippingAndReturns.
  ///
  /// In en, this message translates to:
  /// **'Shipping & Returns'**
  String get tabShippingAndReturns;

  /// No description provided for @specDimensionsAndWeight.
  ///
  /// In en, this message translates to:
  /// **'Dimensions & Weight'**
  String get specDimensionsAndWeight;

  /// No description provided for @specSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get specSku;

  /// No description provided for @reviewsHeader.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews ({count})'**
  String reviewsHeader(int count);

  /// No description provided for @infoShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping Information'**
  String get infoShipping;

  /// No description provided for @infoShippingDefault.
  ///
  /// In en, this message translates to:
  /// **'Standard delivery within 2-3 business days'**
  String get infoShippingDefault;

  /// No description provided for @infoReturnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return Policy'**
  String get infoReturnPolicy;

  /// No description provided for @infoReturnPolicyDefault.
  ///
  /// In en, this message translates to:
  /// **'Returns accepted per store conditions'**
  String get infoReturnPolicyDefault;

  /// No description provided for @infoWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty Information'**
  String get infoWarranty;

  /// No description provided for @infoWarrantyDefault.
  ///
  /// In en, this message translates to:
  /// **'Official manufacturer warranty'**
  String get infoWarrantyDefault;

  /// No description provided for @infoMinOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Quantity'**
  String get infoMinOrder;

  /// No description provided for @infoMinOrderValue.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String infoMinOrderValue(int count);

  /// No description provided for @badgeAuthentic.
  ///
  /// In en, this message translates to:
  /// **'100% Authentic'**
  String get badgeAuthentic;

  /// No description provided for @badgeInstallment.
  ///
  /// In en, this message translates to:
  /// **'0% Installment'**
  String get badgeInstallment;

  /// No description provided for @badgeInstallmentSub.
  ///
  /// In en, this message translates to:
  /// **'Up to 10 months'**
  String get badgeInstallmentSub;

  /// No description provided for @badgeEasyReturn.
  ///
  /// In en, this message translates to:
  /// **'Easy Returns'**
  String get badgeEasyReturn;

  /// No description provided for @badgeEasyReturnSub.
  ///
  /// In en, this message translates to:
  /// **'Within 30 days'**
  String get badgeEasyReturnSub;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @memberStatus.
  ///
  /// In en, this message translates to:
  /// **'Gold Member'**
  String get memberStatus;

  /// No description provided for @savedItemsStat.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get savedItemsStat;

  /// No description provided for @inCartStat.
  ///
  /// In en, this message translates to:
  /// **'In Cart'**
  String get inCartStat;

  /// No description provided for @orderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistoryTitle;

  /// No description provided for @orderHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check order status and tracking'**
  String get orderHistorySubtitle;

  /// No description provided for @orderHistorySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Opening order history...'**
  String get orderHistorySnackbar;

  /// No description provided for @shippingAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipping Addresses'**
  String get shippingAddressTitle;

  /// No description provided for @shippingAddressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage shipping and billing addresses'**
  String get shippingAddressSubtitle;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethodsTitle;

  /// No description provided for @paymentMethodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit cards & PromptPay'**
  String get paymentMethodsSubtitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current: {language}'**
  String languageSubtitle(String language);

  /// No description provided for @appLanguageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get appLanguageName;

  /// No description provided for @currencyNameThb.
  ///
  /// In en, this message translates to:
  /// **'Thai Baht'**
  String get currencyNameThb;

  /// No description provided for @currencyNameUsd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get currencyNameUsd;

  /// No description provided for @currencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyTitle;

  /// No description provided for @currencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current: {currency}'**
  String currencySubtitle(String currency);

  /// No description provided for @currencyExchangeRateNotice.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate: 1 USD = {rate} THB'**
  String currencyExchangeRateNotice(String rate);

  /// No description provided for @helpCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenterTitle;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and Customer Service'**
  String get helpCenterSubtitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About Application'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 0.1.0 (Build 1)'**
  String get aboutAppSubtitle;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutTitle;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get filterClearAll;

  /// No description provided for @filterResetSnackbar.
  ///
  /// In en, this message translates to:
  /// **'All filters have been reset'**
  String get filterResetSnackbar;

  /// No description provided for @priceRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRangeTitle;

  /// No description provided for @minRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Minimum Rating'**
  String get minRatingTitle;

  /// No description provided for @ratingAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get ratingAny;

  /// No description provided for @ratingAndAbove.
  ///
  /// In en, this message translates to:
  /// **'{rating} ★ and above'**
  String ratingAndAbove(String rating);

  /// No description provided for @inStockOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'In-stock items only'**
  String get inStockOnlyTitle;

  /// No description provided for @applyFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFiltersButton;

  /// No description provided for @loadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load data'**
  String get loadErrorTitle;

  /// No description provided for @emptyProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get emptyProductsTitle;

  /// No description provided for @emptyProductsDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'No products match your criteria'**
  String get emptyProductsDefaultMessage;

  /// No description provided for @noProductsMatchingQuery.
  ///
  /// In en, this message translates to:
  /// **'No products found matching \"{query}\"'**
  String noProductsMatchingQuery(String query);

  /// No description provided for @noProductsMatchingFilters.
  ///
  /// In en, this message translates to:
  /// **'No products match selected filters'**
  String get noProductsMatchingFilters;

  /// No description provided for @switchLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguageTooltip;

  /// No description provided for @categoriesFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesFilterTitle;

  /// No description provided for @clearCategorySelection.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCategorySelection;

  /// No description provided for @clearFiltersChip.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFiltersChip;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @weightGrams.
  ///
  /// In en, this message translates to:
  /// **'{weight} g'**
  String weightGrams(int weight);

  /// No description provided for @dailyExchangeRateBadge.
  ///
  /// In en, this message translates to:
  /// **'Daily Reference Rate'**
  String get dailyExchangeRateBadge;

  /// No description provided for @fallbackExchangeRateBadge.
  ///
  /// In en, this message translates to:
  /// **'Offline (Default)'**
  String get fallbackExchangeRateBadge;

  /// No description provided for @exchangeRateAsOfDate.
  ///
  /// In en, this message translates to:
  /// **'As of {date}'**
  String exchangeRateAsOfDate(String date);

  /// No description provided for @refreshExchangeRateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh live exchange rate'**
  String get refreshExchangeRateTooltip;

  /// No description provided for @exchangeRateUpdatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate updated: 1 USD = {rate} THB'**
  String exchangeRateUpdatedSnackbar(String rate);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
