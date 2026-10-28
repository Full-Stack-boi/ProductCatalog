import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/app.dart';
import 'package:product_catalog/data/models/category_item.dart';
import 'package:product_catalog/data/models/paginated_products.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/data/models/product_sort_option.dart';
import 'package:product_catalog/data/repositories/product_repository.dart';

class TestMockRepository implements ProductRepository {
  @override
  Future<PaginatedProducts> getProducts({
    int limit = 20,
    int skip = 0,
    String? categorySlug,
    String? searchQuery,
    ProductSortOption sortOption = ProductSortOption.popular,
  }) async {
    return PaginatedProducts(
      products: [
        Product(
          id: 1,
          title: 'iPhone 15 Pro',
          description: 'A flagship device',
          category: 'smartphones',
          price: 999.0,
          discountPercentage: 12.0,
          rating: 4.8,
          stock: 45,
          tags: const ['phone', 'apple'],
          reviews: const [],
          images: const ['https://example.com/1.png'],
          thumbnail: 'https://example.com/thumb.png',
        ),
      ],
      total: 1,
      skip: 0,
      limit: 20,
    );
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return const [
      CategoryItem(slug: 'smartphones', name: 'Smartphones', url: ''),
    ];
  }

  @override
  Future<Product> getProductById(int id) async {
    return Product(
      id: id,
      title: 'iPhone 15 Pro',
      description: 'A flagship device',
      category: 'smartphones',
      price: 999.0,
      discountPercentage: 12.0,
      rating: 4.8,
      stock: 45,
      tags: const ['phone', 'apple'],
      reviews: const [],
      images: const ['https://example.com/1.png'],
      thumbnail: 'https://example.com/thumb.png',
    );
  }
}

void main() {
  setUpAll(() {
    dotenv.loadFromString(
      envString: '''
APP_ENV=test
APP_NAME=CatalogX
ENABLE_NETWORK_LOGS=false
API_BASE_URL=https://dummyjson.com
API_CONNECT_TIMEOUT_SECONDS=15
API_RECEIVE_TIMEOUT_SECONDS=15
DEFAULT_PAGE_SIZE=20
DEFAULT_LOCALE=th
DEFAULT_CURRENCY=THB
USD_TO_THB_RATE=33.78
EXCHANGE_RATE_API_URL=https://open.er-api.com/v6/latest/USD
''',
    );
  });

  testWidgets('Renders CatalogX App title and Shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(TestMockRepository()),
        ],
        child: const ProductCatalogApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('CatalogX'), findsOneWidget);
    expect(find.text('ทั้งหมด'), findsOneWidget);
  });
}
