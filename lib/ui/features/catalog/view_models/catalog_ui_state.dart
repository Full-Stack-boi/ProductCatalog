import '../../../../data/models/category_item.dart';
import '../../../../data/models/product.dart';
import '../../../../data/models/product_sort_option.dart';

enum StatePreviewMode { none, loading, error, empty }

class CatalogUiState {
  final List<Product> rawProducts;
  final List<CategoryItem> categories;
  final int total;
  final int skip;
  final int limit;
  final String? selectedCategorySlug;
  final Set<String> selectedCategories;
  final String searchQuery;
  final ProductSortOption sortOption;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? loadMoreError;
  final StatePreviewMode previewMode;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool inStockOnly;

  const CatalogUiState({
    this.rawProducts = const [],
    this.categories = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 20,
    this.selectedCategorySlug,
    this.selectedCategories = const {},
    this.searchQuery = '',
    this.sortOption = ProductSortOption.popular,
    this.isLoadingInitial = true,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreError,
    this.previewMode = StatePreviewMode.none,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly = false,
  });

  List<Product> get products {
    return rawProducts.where((p) {
      if (selectedCategories.isNotEmpty &&
          !selectedCategories.contains(p.category)) {
        return false;
      }
      if (inStockOnly && p.isOutOfStock) return false;
      if (minRating != null && p.rating < minRating!) return false;
      if (minPrice != null && p.price < minPrice!) return false;
      if (maxPrice != null && p.price > maxPrice!) return false;
      return true;
    }).toList();
  }

  bool get hasActiveFilters =>
      selectedCategories.isNotEmpty ||
      minPrice != null ||
      maxPrice != null ||
      minRating != null ||
      inStockOnly;

  int get effectiveTotal => hasActiveFilters ? products.length : total;

  bool get hasMore => hasActiveFilters ? false : rawProducts.length < total;

  bool get isEmpty =>
      !isLoadingInitial && errorMessage == null && products.isEmpty;

  bool get isSuccess =>
      !isLoadingInitial && errorMessage == null && products.isNotEmpty;

  int get currentPage {
    final pageSize = limit > 0 ? limit : 20;
    return (skip / pageSize).floor() + 1;
  }

  int get totalPages {
    final pageSize = limit > 0 ? limit : 20;
    final pages = (total / pageSize).ceil();
    return pages > 0 ? pages : 1;
  }

  int get loadedCount => products.length;

  CatalogUiState copyWith({
    List<Product>? rawProducts,
    List<CategoryItem>? categories,
    int? total,
    int? skip,
    int? limit,
    String? selectedCategorySlug,
    bool clearCategory = false,
    Set<String>? selectedCategories,
    bool clearCategories = false,
    String? searchQuery,
    ProductSortOption? sortOption,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    String? loadMoreError,
    bool clearLoadMoreError = false,
    StatePreviewMode? previewMode,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    double? minRating,
    bool clearMinRating = false,
    bool? inStockOnly,
    bool clearFilters = false,
  }) {
    return CatalogUiState(
      rawProducts: rawProducts ?? this.rawProducts,
      categories: categories ?? this.categories,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      selectedCategorySlug: clearCategory
          ? null
          : (selectedCategorySlug ?? this.selectedCategorySlug),
      selectedCategories: clearFilters || clearCategories
          ? const {}
          : (selectedCategories ?? this.selectedCategories),
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
      previewMode: previewMode ?? this.previewMode,
      minPrice: clearFilters || clearMinPrice
          ? null
          : (minPrice ?? this.minPrice),
      maxPrice: clearFilters || clearMaxPrice
          ? null
          : (maxPrice ?? this.maxPrice),
      minRating: clearFilters || clearMinRating
          ? null
          : (minRating ?? this.minRating),
      inStockOnly: clearFilters ? false : (inStockOnly ?? this.inStockOnly),
    );
  }
}
