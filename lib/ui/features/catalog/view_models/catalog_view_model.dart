import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../data/models/product_sort_option.dart';
import '../../../../data/repositories/product_repository.dart';
import 'catalog_ui_state.dart';

final catalogViewModelProvider =
    NotifierProvider<CatalogViewModel, CatalogUiState>(CatalogViewModel.new);

class CatalogViewModel extends Notifier<CatalogUiState> {
  late final ProductRepository _repository;
  Timer? _debounceTimer;

  @override
  CatalogUiState build() {
    _repository = ref.watch(productRepositoryProvider);
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    Future.microtask(loadInitial);
    return const CatalogUiState();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(
      isLoadingInitial: true,
      clearError: true,
      clearLoadMoreError: true,
    );

    try {
      final categoriesFuture = state.categories.isEmpty
          ? _repository.getCategories()
          : Future.value(state.categories);

      final productsFuture = _repository.getProducts(
        limit: state.limit,
        skip: 0,
        categorySlug: state.selectedCategorySlug,
        searchQuery: state.searchQuery,
        sortOption: state.sortOption,
      );

      final results = await Future.wait([categoriesFuture, productsFuture]);
      final categories = results[0] as List<dynamic>;
      final paginated = results[1] as dynamic;

      state = state.copyWith(
        categories: categories.cast(),
        rawProducts: paginated.products,
        total: paginated.total,
        skip: paginated.skip,
        isLoadingInitial: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingInitial: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoadingInitial: false,
        errorMessage: 'เกิดข้อผิดพลาดในการโหลดข้อมูลสินค้า',
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(clearError: true, clearLoadMoreError: true);

    try {
      final paginated = await _repository.getProducts(
        limit: state.limit,
        skip: 0,
        categorySlug: state.selectedCategorySlug,
        searchQuery: state.searchQuery,
        sortOption: state.sortOption,
      );

      state = state.copyWith(
        rawProducts: paginated.products,
        total: paginated.total,
        skip: paginated.skip,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(errorMessage: 'ไม่สามารถรีเฟรชข้อมูลได้');
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoadingInitial) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);

    try {
      final nextSkip = state.rawProducts.length;
      final paginated = await _repository.getProducts(
        limit: state.limit,
        skip: nextSkip,
        categorySlug: state.selectedCategorySlug,
        searchQuery: state.searchQuery,
        sortOption: state.sortOption,
      );

      state = state.copyWith(
        rawProducts: [...state.rawProducts, ...paginated.products],
        total: paginated.total,
        skip: paginated.skip,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, loadMoreError: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: 'เกิดข้อผิดพลาดในการโหลดสินค้าเพิ่มเติม',
      );
    }
  }

  void onSearchChanged(String query) {
    if (query == state.searchQuery) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(
        searchQuery: query,
        clearCategory: true,
        clearCategories: true,
      );
      loadInitial();
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    state = state.copyWith(searchQuery: '');
    loadInitial();
  }

  void selectCategory(String? slug) {
    if (slug == state.selectedCategorySlug &&
        state.selectedCategories.length <= 1 &&
        (slug == null || state.selectedCategories.contains(slug))) {
      return;
    }

    state = state.copyWith(
      selectedCategorySlug: slug,
      clearCategory: slug == null,
      selectedCategories: slug == null ? const {} : {slug},
      searchQuery: '',
    );
    loadInitial();
  }

  void setSortOption(ProductSortOption option) {
    if (option == state.sortOption) return;

    state = state.copyWith(sortOption: option);
    loadInitial();
  }

  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool inStockOnly = false,
    Set<String>? selectedCategories,
  }) async {
    final categories = selectedCategories ?? state.selectedCategories;
    final hasFilters =
        minPrice != null ||
        maxPrice != null ||
        minRating != null ||
        inStockOnly ||
        categories.isNotEmpty;

    final needsFetchAll =
        hasFilters &&
        (state.rawProducts.length < state.total ||
            state.selectedCategorySlug != null);

    state = state.copyWith(
      isLoadingInitial: needsFetchAll ? true : state.isLoadingInitial,
      minPrice: minPrice,
      clearMinPrice: minPrice == null,
      maxPrice: maxPrice,
      clearMaxPrice: maxPrice == null,
      minRating: minRating,
      clearMinRating: minRating == null,
      inStockOnly: inStockOnly,
      selectedCategories: categories,
      selectedCategorySlug: categories.length == 1 ? categories.first : null,
      clearCategory: categories.length != 1,
    );

    if (needsFetchAll) {
      try {
        final paginated = await _repository.getProducts(
          limit: 0,
          skip: 0,
          categorySlug: null,
          searchQuery: state.searchQuery,
          sortOption: state.sortOption,
        );
        state = state.copyWith(
          rawProducts: paginated.products,
          total: paginated.total,
          skip: 0,
          isLoadingInitial: false,
        );
      } catch (_) {
        state = state.copyWith(isLoadingInitial: false);
      }
    }
  }

  Future<void> resetFilters() async {
    state = state.copyWith(
      clearFilters: true,
      clearCategories: true,
      clearCategory: true,
    );
    await loadInitial();
  }

  void setPreviewMode(StatePreviewMode mode) {
    state = state.copyWith(
      previewMode: state.previewMode == mode ? StatePreviewMode.none : mode,
    );
  }

  void retry() {
    loadInitial();
  }

  void retryLoadMore() {
    loadMore();
  }
}
