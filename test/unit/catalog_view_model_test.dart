import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/data/models/category_item.dart';
import 'package:product_catalog/data/models/paginated_products.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/data/models/product_sort_option.dart';
import 'package:product_catalog/data/repositories/product_repository.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_ui_state.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';

class FakeProductRepository implements ProductRepository {
  final List<Product> mockProducts;
  final List<CategoryItem> mockCategories;

  FakeProductRepository({
    required this.mockProducts,
    required this.mockCategories,
  });

  @override
  Future<PaginatedProducts> getProducts({
    int limit = 20,
    int skip = 0,
    String? categorySlug,
    String? searchQuery,
    ProductSortOption sortOption = ProductSortOption.popular,
  }) async {
    var filtered = mockProducts;
    if (categorySlug != null) {
      filtered = filtered.where((p) => p.category == categorySlug).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    final paged = limit == 0
        ? filtered.skip(skip).toList()
        : filtered.skip(skip).take(limit).toList();
    return PaginatedProducts(
      products: paged,
      total: filtered.length,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return mockCategories;
  }

  @override
  Future<Product> getProductById(int id) async {
    return mockProducts.firstWhere((p) => p.id == id);
  }
}

void main() {
  late List<Product> testProducts;
  late List<CategoryItem> testCategories;
  late FakeProductRepository fakeRepo;

  setUp(() {
    testCategories = [
      const CategoryItem(slug: 'smartphones', name: 'Smartphones', url: ''),
      const CategoryItem(slug: 'laptops', name: 'Laptops', url: ''),
    ];

    testProducts = List.generate(
      25,
      (i) => Product(
        id: i + 1,
        title: 'Product ${i + 1}',
        description: 'Description ${i + 1}',
        category: i < 15 ? 'smartphones' : 'laptops',
        price: (i + 1) * 100.0,
        discountPercentage: 10.0,
        rating: 4.5,
        stock: 10,
        tags: const ['test'],
        reviews: const [],
        images: const ['https://example.com/img.jpg'],
        thumbnail: 'https://example.com/thumb.jpg',
      ),
    );

    fakeRepo = FakeProductRepository(
      mockProducts: testProducts,
      mockCategories: testCategories,
    );
  });

  test('CatalogViewModel loads initial products and categories', () async {
    final container = ProviderContainer(
      overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(catalogViewModelProvider.notifier);
    await viewModel.loadInitial();

    final state = container.read(catalogViewModelProvider);
    expect(state.isLoadingInitial, isFalse);
    expect(state.products.length, 20);
    expect(state.total, 25);
    expect(state.categories.length, 2);
    expect(state.hasMore, isTrue);
  });

  test('CatalogViewModel loads more items when paginating', () async {
    final container = ProviderContainer(
      overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(catalogViewModelProvider.notifier);
    await viewModel.loadInitial();
    await viewModel.loadMore();

    final state = container.read(catalogViewModelProvider);
    expect(state.products.length, 25);
    expect(state.hasMore, isFalse);
  });

  test('CatalogViewModel filters by category', () async {
    final container = ProviderContainer(
      overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(catalogViewModelProvider.notifier);
    await viewModel.loadInitial();
    viewModel.selectCategory('laptops');
    await Future.delayed(Duration.zero);

    final state = container.read(catalogViewModelProvider);
    expect(state.selectedCategorySlug, 'laptops');
    expect(state.products.every((p) => p.category == 'laptops'), isTrue);
    expect(state.total, 10);
  });

  test('CatalogViewModel toggles PreviewMode correctly', () {
    final container = ProviderContainer(
      overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
    );
    addTearDown(container.dispose);

    final viewModel = container.read(catalogViewModelProvider.notifier);
    viewModel.setPreviewMode(StatePreviewMode.loading);
    expect(
      container.read(catalogViewModelProvider).previewMode,
      StatePreviewMode.loading,
    );

    viewModel.setPreviewMode(StatePreviewMode.none);
    expect(
      container.read(catalogViewModelProvider).previewMode,
      StatePreviewMode.none,
    );
  });

  test('Wishlist & Cart ViewModel operations', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final wishlist = container.read(wishlistProvider.notifier);
    wishlist.toggle(101);
    expect(wishlist.isFavorite(101), isTrue);
    wishlist.toggle(101);
    expect(wishlist.isFavorite(101), isFalse);

    final cart = container.read(cartProvider.notifier);
    cart.addItem(201, 2);
    cart.addItem(202, 1);
    expect(cart.totalItemCount, 3);
    cart.removeItem(201);
    expect(cart.totalItemCount, 2);
  });

  test(
    'CatalogViewModel applyFilters and resetFilters works correctly',
    () async {
      final container = ProviderContainer(
        overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final viewModel = container.read(catalogViewModelProvider.notifier);
      await viewModel.loadInitial();

      expect(container.read(catalogViewModelProvider).products.length, 20);
      expect(container.read(catalogViewModelProvider).effectiveTotal, 25);

      await viewModel.applyFilters(minPrice: 500, maxPrice: 1500);
      expect(container.read(catalogViewModelProvider).hasActiveFilters, isTrue);
      expect(
        container
            .read(catalogViewModelProvider)
            .products
            .every((p) => p.price >= 500 && p.price <= 1500),
        isTrue,
      );
      final filteredCount = container
          .read(catalogViewModelProvider)
          .products
          .length;
      expect(
        container.read(catalogViewModelProvider).effectiveTotal,
        filteredCount,
      );
      expect(
        container.read(catalogViewModelProvider).effectiveTotal != 25,
        isTrue,
      );

      await viewModel.applyFilters(minPrice: null, maxPrice: 1500);
      expect(container.read(catalogViewModelProvider).minPrice, isNull);
      expect(container.read(catalogViewModelProvider).maxPrice, 1500);

      await viewModel.resetFilters();
      expect(
        container.read(catalogViewModelProvider).hasActiveFilters,
        isFalse,
      );
      expect(container.read(catalogViewModelProvider).minPrice, isNull);
      expect(container.read(catalogViewModelProvider).maxPrice, isNull);
      expect(container.read(catalogViewModelProvider).products.length, 20);
      expect(container.read(catalogViewModelProvider).effectiveTotal, 25);
    },
  );

  test(
    'CatalogViewModel multi-category filtering selects multiple categories and resets properly',
    () async {
      final container = ProviderContainer(
        overrides: [productRepositoryProvider.overrideWithValue(fakeRepo)],
      );
      addTearDown(container.dispose);

      final viewModel = container.read(catalogViewModelProvider.notifier);
      await viewModel.loadInitial();

      expect(container.read(catalogViewModelProvider).products.length, 20);

      await viewModel.applyFilters(selectedCategories: {'laptops'});
      var state = container.read(catalogViewModelProvider);
      expect(state.hasActiveFilters, isTrue);
      expect(state.selectedCategories, {'laptops'});
      expect(state.products.every((p) => p.category == 'laptops'), isTrue);
      expect(state.products.length, 10);

      await viewModel.applyFilters(
        selectedCategories: {'smartphones', 'laptops'},
      );
      state = container.read(catalogViewModelProvider);
      expect(state.hasActiveFilters, isTrue);
      expect(state.selectedCategories, {'smartphones', 'laptops'});
      expect(state.products.length, 25);
      expect(
        state.products.every(
          (p) => p.category == 'smartphones' || p.category == 'laptops',
        ),
        isTrue,
      );

      await viewModel.resetFilters();
      state = container.read(catalogViewModelProvider);
      expect(state.hasActiveFilters, isFalse);
      expect(state.selectedCategories.isEmpty, isTrue);
      expect(state.products.length, 20);
    },
  );

  test(
    'CatalogUiState calculates hasMore accurately across multi-page accumulation',
    () {
      final dummyProduct = Product(
        id: 1,
        title: 'Item',
        description: '',
        category: 'cat',
        price: 10,
        discountPercentage: 0,
        rating: 4.5,
        stock: 10,
        brand: 'Brand',
        shippingInformation: '',
        tags: const [],
        reviews: const [],
        images: const [],
        thumbnail: '',
      );

      final page6State = CatalogUiState(
        rawProducts: List.filled(120, dummyProduct),
        skip: 100,
        total: 194,
        limit: 20,
      );
      expect(page6State.hasMore, isTrue);
      expect(page6State.currentPage, 6);
      expect(page6State.totalPages, 10);
      expect(page6State.loadedCount, 120);

      final completedState = CatalogUiState(
        rawProducts: List.filled(194, dummyProduct),
        skip: 180,
        total: 194,
        limit: 20,
      );
      expect(completedState.hasMore, isFalse);
      expect(completedState.currentPage, 10);
      expect(completedState.totalPages, 10);
      expect(completedState.loadedCount, 194);
    },
  );
}
