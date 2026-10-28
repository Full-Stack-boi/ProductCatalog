import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog/data/models/category_item.dart';
import 'package:product_catalog/data/models/paginated_products.dart';
import 'package:product_catalog/data/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('Calculates original price and savings correctly with discount', () {
      final product = Product(
        id: 1,
        title: 'Smartphone X',
        description: 'Test phone',
        category: 'smartphones',
        price: 900.0,
        discountPercentage: 10.0,
        rating: 4.8,
        stock: 5,
        tags: const ['tech', 'phone'],
        reviews: const [],
        images: const ['https://example.com/1.jpg'],
        thumbnail: 'https://example.com/thumb.jpg',
      );

      expect(product.originalPrice, 1000.0);
      expect(product.savedAmount, 100.0);
      expect(product.hasDiscount, isTrue);
      expect(product.isLowStock, isTrue);
      expect(product.isOutOfStock, isFalse);
      expect(product.displayBrand, 'smartphones');
    });

    test(
      'Product with negligible discount (< 1% round) has hasDiscount false',
      () {
        final cucumber = Product(
          id: 2,
          title: 'Cucumber',
          description: 'Cucumber',
          category: 'groceries',
          price: 1.49,
          discountPercentage: 0.16,
          rating: 4.1,
          stock: 99,
          tags: const ['groceries'],
          reviews: const [],
          images: const ['https://example.com/cuc.jpg'],
          thumbnail: 'https://example.com/cuc.jpg',
        );

        expect(cucumber.hasDiscount, isFalse);
        expect(cucumber.originalPrice, 1.49);
        expect(cucumber.savedAmount, 0.0);
      },
    );

    test('Parses CategoryItem correctly from json map', () {
      final item = CategoryItem.fromJson({
        'slug': 'laptops',
        'name': 'Laptops',
        'url': 'https://dummyjson.com/products/category/laptops',
      });

      expect(item.slug, 'laptops');
      expect(item.name, 'Laptops');
    });

    test('PaginatedProducts computes pagination indicators correctly', () {
      final paginated = PaginatedProducts(
        products: List.generate(
          20,
          (index) => Product(
            id: index + 1,
            title: 'Item $index',
            description: '',
            category: 'tech',
            price: 10,
            discountPercentage: 0,
            rating: 5,
            stock: 20,
            tags: const [],
            reviews: const [],
            images: const [],
            thumbnail: '',
          ),
        ),
        total: 100,
        skip: 20,
        limit: 20,
      );

      expect(paginated.hasMore, isTrue);
      expect(paginated.currentPage, 2);
      expect(paginated.totalPages, 5);
    });
  });
}
