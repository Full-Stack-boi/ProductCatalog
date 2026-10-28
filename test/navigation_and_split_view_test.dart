import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:product_catalog/app.dart';
import 'package:product_catalog/data/models/category_item.dart';
import 'package:product_catalog/data/models/paginated_products.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/data/models/product_sort_option.dart';
import 'package:product_catalog/data/repositories/product_repository.dart';
import 'package:product_catalog/l10n/app_localizations.dart';
import 'package:product_catalog/ui/core/currency_provider.dart';
import 'package:product_catalog/ui/core/locale_provider.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/core/widgets/filter_bottom_sheet.dart';
import 'package:product_catalog/ui/features/cart/views/cart_view.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';
import 'package:product_catalog/ui/features/catalog/views/catalog_view.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/product_card.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/search_and_sort_bar.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';
import 'package:product_catalog/ui/features/categories/views/categories_view.dart';
import 'package:product_catalog/ui/features/product_detail/views/product_detail_view.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_bottom_bar.dart';
import 'package:product_catalog/ui/features/product_detail/views/widgets/product_price_stock_section.dart';
import 'package:product_catalog/ui/features/profile/views/profile_view.dart';

Widget buildTestApp({
  required Widget child,
  Locale locale = const Locale('th'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

class NavTestRepository implements ProductRepository {
  final testProduct = Product(
    id: 1,
    title: 'Apple Airpower Wireless Charger',
    description: 'Wireless charging pad',
    category: 'mobile-accessories',
    price: 79.99,
    discountPercentage: 4.0,
    rating: 3.7,
    stock: 20,
    brand: 'Apple',
    shippingInformation: 'Ships in 3-5 business days',
    tags: const ['tech', 'charger'],
    reviews: const [],
    images: const ['https://example.com/1.png'],
    thumbnail: 'https://example.com/thumb.png',
  );

  @override
  Future<PaginatedProducts> getProducts({
    int limit = 20,
    int skip = 0,
    String? categorySlug,
    String? searchQuery,
    ProductSortOption sortOption = ProductSortOption.popular,
  }) async {
    return PaginatedProducts(
      products: [testProduct],
      total: 1,
      skip: 0,
      limit: 20,
    );
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return const [
      CategoryItem(
        slug: 'mobile-accessories',
        name: 'Mobile Accessories',
        url: '',
      ),
    ];
  }

  @override
  Future<Product> getProductById(int id) async {
    return testProduct;
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

  testWidgets('Navigation switches tabs and interacts correctly', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
        child: const ProductCatalogApp(),
      ),
    );

    await tester.pumpAndSettle();

    final railFinder = find.byType(NavigationRail);
    expect(railFinder, findsOneWidget);
    final rail = tester.widget<NavigationRail>(railFinder);
    expect(rail.groupAlignment, 0.0);
    expect(rail.leading, isNull);

    expect(find.text('CatalogX'), findsOneWidget);

    await tester.tap(find.text('หมวดหมู่'));
    await tester.pumpAndSettle();
    expect(find.text('หมวดหมู่สินค้า'), findsOneWidget);

    await tester.tap(find.text('รายการโปรด'));
    await tester.pumpAndSettle();
    expect(find.text('ยังไม่มีสินค้าในรายการโปรด'), findsOneWidget);

    await tester.tap(find.text('ตะกร้า'));
    await tester.pumpAndSettle();
    expect(find.text('ไม่มีสินค้าในตะกร้า'), findsOneWidget);
  });

  testWidgets(
    'ProductPriceStockSection does not overflow with discounts in tight container',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final product = Product(
        id: 99,
        title: 'Long Discount Product Title Here',
        description: '',
        category: 'gadgets',
        price: 79.99,
        discountPercentage: 4.5,
        rating: 4.0,
        stock: 5,
        tags: const [],
        reviews: const [],
        images: const [],
        thumbnail: '',
      );

      await tester.pumpWidget(
        buildTestApp(
          child: Scaffold(
            body: ProviderScope(
              child: SizedBox(
                width: 320,
                child: ProductPriceStockSection(
                  product: product,
                  onQuantityChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      final exc = tester.takeException();
      if (exc is FlutterError) {
        for (final d in exc.diagnostics) {
          debugPrint('PROP: ${d.name} -> ${d.toDescription()}');
        }
      }
      expect(exc, isNull);
      expect(find.text('฿2,702.06'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductDetailView quantity synchronizes with cartProvider reactively',
    (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
      );
      addTearDown(container.dispose);

      container.read(cartProvider.notifier).addItem(1, 2);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: buildTestApp(child: const ProductDetailView(productId: 1)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('2'), findsWidgets);
      expect(find.text('ในตะกร้า (2)'), findsOneWidget);
      expect(find.text('ดูตะกร้า (2)'), findsOneWidget);

      final addIcons = find.byIcon(Icons.add);
      expect(addIcons, findsOneWidget);
      await tester.tap(addIcons);
      await tester.pumpAndSettle();

      expect(container.read(cartProvider)[1], 3);
      expect(find.text('3'), findsWidgets);
      expect(find.text('ในตะกร้า (3)'), findsOneWidget);
      expect(find.text('ดูตะกร้า (3)'), findsOneWidget);

      final removeIcons = find.byIcon(Icons.remove);
      expect(removeIcons, findsOneWidget);
      await tester.tap(removeIcons);
      await tester.pumpAndSettle();

      expect(container.read(cartProvider)[1], 2);
      expect(find.text('2'), findsWidgets);
      expect(find.text('ในตะกร้า (2)'), findsOneWidget);

      container.read(cartProvider.notifier).addItem(1, 1);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsWidgets);
      expect(find.text('ในตะกร้า (3)'), findsOneWidget);
    },
  );

  testWidgets(
    'ProfileView renders without ListTile background color or ink splashes error',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(child: buildTestApp(child: const ProfileView())),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('ประวัติคำสั่งซื้อ'), findsOneWidget);

      await tester.tap(find.text('ประวัติคำสั่งซื้อ'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('ProfileView currency dialog renders daily exchange rate badge', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(currencyProvider.notifier).updateRate(33.78, '2026-10-28');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(child: const ProfileView()),
      ),
    );
    await tester.pumpAndSettle();

    final currencyTile = find.byIcon(Icons.payments_outlined);
    expect(currencyTile, findsOneWidget);
    await tester.tap(currencyTile);
    await tester.pumpAndSettle();

    expect(find.text('อัตราแลกเปลี่ยนประจำวัน'), findsOneWidget);
    expect(find.text('ข้อมูล ณ วันที่ 2026-10-28'), findsOneWidget);
  });

  testWidgets(
    'ProductDetailView renders share icon and no cart icon in AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(NavTestRepository()),
          ],
          child: buildTestApp(child: const ProductDetailView(productId: 1)),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('รายละเอียดสินค้า'), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
    },
  );

  testWidgets(
    'ProductCard toggles to stepper on add, increments, decrements, and reverts to add button',
    (WidgetTester tester) async {
      final testProduct = Product(
        id: 50,
        title: 'Essence Mascara Lash Princess',
        description: 'Mascara',
        category: 'beauty',
        price: 9.99,
        discountPercentage: 10.0,
        rating: 2.6,
        stock: 99,
        tags: const ['beauty'],
        reviews: const [],
        images: const ['https://example.com/mascara.png'],
        thumbnail: 'https://example.com/thumb.png',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: buildTestApp(
            child: Scaffold(
              body: SizedBox(
                width: 140,
                height: 350,
                child: ProductCard(product: testProduct, onTap: () {}),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.remove_rounded), findsNothing);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.text('1'), findsNothing);
    },
  );

  testWidgets(
    'CategoriesView renders without overflow on 360x800 mobile screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(NavTestRepository()),
          ],
          child: buildTestApp(child: const CategoriesView()),
        ),
      );

      await tester.pumpAndSettle();
      final exc = tester.takeException();
      if (exc is FlutterError) {
        for (final d in exc.diagnostics) {
          debugPrint('${d.name}: ${d.toString()}');
        }
      }
      expect(exc, isNull);
      expect(find.text('หมวดหมู่สินค้า'), findsOneWidget);
      expect(find.text('ทั้งหมด'), findsOneWidget);
    },
  );

  testWidgets(
    'CatalogView renders without overflow on 320x907 Mobile S screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 907);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productRepositoryProvider.overrideWithValue(NavTestRepository()),
          ],
          child: buildTestApp(child: const CatalogView()),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('CatalogX'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsWidgets);
    },
  );

  testWidgets(
    'ProfileView renders without overflow on 320x907 Mobile S screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 907);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(child: buildTestApp(child: const ProfileView())),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('สินค้าที่บันทึก'), findsOneWidget);
      expect(find.text('ในตะกร้า'), findsOneWidget);
    },
  );

  testWidgets(
    'CartView displays rich product details, max stock indicator, and handles delete',
    (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
      );
      addTearDown(container.dispose);

      await container.read(catalogViewModelProvider.notifier).loadInitial();
      container.read(cartProvider.notifier).addItem(1, 20);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: buildTestApp(child: const CartView()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('20'), findsOneWidget);
      expect(find.text('• สูงสุดในสต็อก (20 ชิ้น)'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
      expect(find.textContaining('รวม ฿'), findsOneWidget);

      final addIcon = find.byIcon(Icons.add_rounded);
      expect(addIcon, findsOneWidget);
      await tester.tap(addIcon);
      await tester.pumpAndSettle();

      expect(container.read(cartProvider)[1], 20);
      expect(find.text('20'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      expect(container.read(cartProvider).containsKey(1), isFalse);
      expect(find.text('ไม่มีสินค้าในตะกร้า'), findsOneWidget);
    },
  );

  testWidgets('CartView renders without overflow on 320x907 Mobile S screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 907);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(NavTestRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(catalogViewModelProvider.notifier).loadInitial();
    container.read(cartProvider.notifier).addItem(1, 2);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: buildTestApp(child: const CartView()),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('ตะกร้าสินค้า (2)'), findsOneWidget);
    expect(find.text('Ships in 3-5 business days'), findsOneWidget);
    expect(find.text('รวม ฿5,404.12'), findsOneWidget);
  });

  testWidgets('ProductCard disables add button when stock limit is reached', (
    WidgetTester tester,
  ) async {
    final limitedProduct = Product(
      id: 77,
      title: 'Limited Stock Item',
      description: '',
      category: 'gadgets',
      price: 15.0,
      discountPercentage: 0,
      rating: 4.5,
      stock: 2,
      tags: const [],
      reviews: const [],
      images: const [],
      thumbnail: '',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: buildTestApp(
          child: Scaffold(
            body: SizedBox(
              width: 150,
              height: 350,
              child: ProductCard(product: limitedProduct, onTap: () {}),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('• สูงสุดในสต็อก (2)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('Dynamic locale switching updates UI between Thai and English', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(NavTestRepository()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ProductCatalogApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('หมวดหมู่'), findsOneWidget);
    expect(find.text('ตะกร้า'), findsOneWidget);

    container.read(localeProvider.notifier).setLocale(const Locale('en'));
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);

    container.read(localeProvider.notifier).setLocale(const Locale('th'));
    await tester.pumpAndSettle();

    expect(find.text('หมวดหมู่'), findsOneWidget);
    expect(find.text('ตะกร้า'), findsOneWidget);
  });

  testWidgets(
    'System back button on secondary tab returns to catalog without crash',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ProductCatalogApp(),
        ),
      );
      await tester.pumpAndSettle();

      container.read(navigationTabProvider.notifier).toCart();
      await tester.pumpAndSettle();

      expect(find.text('ไม่มีสินค้าในตะกร้า'), findsOneWidget);

      final dynamic widgetsBinding = tester.binding;
      await widgetsBinding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('CatalogX'), findsOneWidget);
      expect(container.read(navigationTabProvider), NavigationTab.catalog);
    },
  );

  testWidgets(
    'CurrencyProvider converts and formats prices correctly between USD and THB',
    (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialCurrency = container.read(currencyProvider);
      expect(initialCurrency.currency, AppCurrency.thb);
      expect(initialCurrency.format(10.0), '฿337.80');

      container.read(currencyProvider.notifier).setCurrency(AppCurrency.usd);
      final usdCurrency = container.read(currencyProvider);
      expect(usdCurrency.currency, AppCurrency.usd);
      expect(usdCurrency.format(10.0), '\$10.00');

      container.read(currencyProvider.notifier).updateRate(36.0);
      container.read(currencyProvider.notifier).setCurrency(AppCurrency.thb);
      final updatedCurrency = container.read(currencyProvider);
      expect(updatedCurrency.format(10.0), '฿360.00');
    },
  );

  testWidgets(
    'ExchangeRateService and CurrencyProvider daily rate update and price calculations',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'cached_usd_thb_rate': 33.78,
        'cached_usd_thb_date': '2026-10-28',
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(currencyProvider);
      expect(initial.usdToThbRate, 33.78);

      container.read(currencyProvider.notifier).updateRate(33.74, '2026-10-28');
      final updated = container.read(currencyProvider);
      expect(updated.usdToThbRate, 33.74);
      expect(updated.isLive, isTrue);
      expect(updated.isDailyRate, isTrue);
      expect(updated.rateDate, '2026-10-28');
      expect(updated.format(1.0), '฿33.74');
      expect(updated.format(10.0), '฿337.40');
      expect(updated.convert(100.0), 3374.0);
    },
  );

  testWidgets(
    'Switching language automatically updates currency display across product card and cart',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ProductCatalogApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('฿2,702.06'), findsWidgets);

      container.read(localeProvider.notifier).setLocale(const Locale('en'));
      await tester.pumpAndSettle();

      expect(find.text('\$79.99'), findsWidgets);

      container.read(localeProvider.notifier).setLocale(const Locale('th'));
      await tester.pumpAndSettle();

      expect(find.text('฿2,702.06'), findsWidgets);
    },
  );

  testWidgets('Top Bar Language Switcher toggles language between TH and EN', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(NavTestRepository()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ProductCatalogApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TH'), findsOneWidget);
    expect(find.text('หมวดหมู่'), findsOneWidget);

    await tester.tap(find.text('TH'));
    await tester.pumpAndSettle();

    expect(find.text('EN'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(find.text('TH'), findsOneWidget);
    expect(find.text('หมวดหมู่'), findsOneWidget);
  });

  testWidgets(
    'FilterBottomSheet allows multi-category selection and applies filters',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final container = ProviderContainer(
        overrides: [
          productRepositoryProvider.overrideWithValue(NavTestRepository()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ProductCatalogApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.filter_alt_rounded));
      await tester.pumpAndSettle();

      expect(find.text('ตัวกรองสินค้า'), findsOneWidget);
      expect(find.text('หมวดหมู่สินค้า'), findsOneWidget);

      final bottomSheetChip = find.descendant(
        of: find.byType(FilterBottomSheet),
        matching: find.text('Mobile Accessories'),
      );
      expect(bottomSheetChip, findsOneWidget);
      await tester.tap(bottomSheetChip);
      await tester.pumpAndSettle();

      await tester.tap(find.text('ใช้ตัวกรอง'));
      await tester.pumpAndSettle();

      expect(find.text('ตัวกรองสินค้า'), findsNothing);
      final vmState = container.read(catalogViewModelProvider);
      expect(vmState.hasActiveFilters, isTrue);
      expect(vmState.selectedCategories.contains('mobile-accessories'), isTrue);
    },
  );

  testWidgets(
    'ProductBottomBar renders without text clipping in narrow 290px container and tablet',
    (tester) async {
      final repo = NavTestRepository();
      tester.view.physicalSize = const Size(290, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: buildTestApp(
            locale: const Locale('en'),
            child: Scaffold(
              body: ProductBottomBar(product: repo.testProduct, quantity: 1),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProductBottomBar), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.text('Buy Now'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'CatalogSearchBar renders with full 48px height and no vertical dead zone',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: buildTestApp(child: const Scaffold(body: CatalogSearchBar())),
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.getRect(find.byType(TextField));
      expect(textField.height, 48.0);

      final decorator = tester.renderObject<RenderBox>(
        find.byType(InputDecorator),
      );
      expect(decorator.size.height, 48.0);
    },
  );
}
