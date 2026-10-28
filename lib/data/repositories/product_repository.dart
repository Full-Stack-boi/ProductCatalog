import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/app_exception.dart';
import '../models/category_item.dart';
import '../models/paginated_products.dart';
import '../models/product.dart';
import '../models/product_sort_option.dart';
import '../services/product_api_service.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productApiServiceProvider));
});

abstract class ProductRepository {
  Future<PaginatedProducts> getProducts({
    int limit = ApiConstants.defaultPageSize,
    int skip = 0,
    String? categorySlug,
    String? searchQuery,
    ProductSortOption sortOption = ProductSortOption.popular,
  });

  Future<List<CategoryItem>> getCategories();

  Future<Product> getProductById(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;

  ProductRepositoryImpl(this._apiService);

  @override
  Future<PaginatedProducts> getProducts({
    int limit = ApiConstants.defaultPageSize,
    int skip = 0,
    String? categorySlug,
    String? searchQuery,
    ProductSortOption sortOption = ProductSortOption.popular,
  }) async {
    try {
      final Map<String, dynamic> raw;

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        raw = await _apiService.searchProducts(
          query: searchQuery.trim(),
          limit: limit,
          skip: skip,
          sortBy: sortOption.apiSortBy,
          order: sortOption.apiOrder,
        );
      } else if (categorySlug != null && categorySlug.trim().isNotEmpty) {
        raw = await _apiService.fetchProductsByCategory(
          categorySlug: categorySlug.trim(),
          limit: limit,
          skip: skip,
          sortBy: sortOption.apiSortBy,
          order: sortOption.apiOrder,
        );
      } else {
        raw = await _apiService.fetchProducts(
          limit: limit,
          skip: skip,
          sortBy: sortOption.apiSortBy,
          order: sortOption.apiOrder,
        );
      }

      return PaginatedProducts.fromJson(raw);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
        message: 'เกิดข้อผิดพลาดในการโหลดข้อมูลสินค้า',
        originalError: e,
      );
    }
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    try {
      final raw = await _apiService.fetchCategories();
      return raw.map((item) {
        if (item is Map<String, dynamic>) {
          return CategoryItem.fromJson(item);
        } else if (item is String) {
          return CategoryItem(slug: item, name: item, url: '');
        }
        return CategoryItem(
          slug: item.toString(),
          name: item.toString(),
          url: '',
        );
      }).toList();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
        message: 'เกิดข้อผิดพลาดในการโหลดหมวดหมู่สินค้า',
        originalError: e,
      );
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final raw = await _apiService.fetchProductById(id);
      return Product.fromJson(raw);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
        message: 'เกิดข้อผิดพลาดในการโหลดรายละเอียดสินค้า',
        originalError: e,
      );
    }
  }
}
