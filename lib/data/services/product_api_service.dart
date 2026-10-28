import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

final productApiServiceProvider = Provider<ProductApiService>((ref) {
  return ProductApiService(ref.watch(dioProvider));
});

class ProductApiService {
  final Dio _dio;

  ProductApiService(this._dio);

  Future<Map<String, dynamic>> fetchProducts({
    int limit = ApiConstants.defaultPageSize,
    int skip = 0,
    String? sortBy,
    String? order,
  }) async {
    final queryParameters = <String, dynamic>{'limit': limit, 'skip': skip};
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParameters['sortBy'] = sortBy;
      if (order != null && order.isNotEmpty) {
        queryParameters['order'] = order;
      }
    }

    final response = await _dio.get(
      ApiConstants.productsEndpoint,
      queryParameters: queryParameters,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> searchProducts({
    required String query,
    int limit = ApiConstants.defaultPageSize,
    int skip = 0,
    String? sortBy,
    String? order,
  }) async {
    final queryParameters = <String, dynamic>{
      'q': query,
      'limit': limit,
      'skip': skip,
    };
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParameters['sortBy'] = sortBy;
      if (order != null && order.isNotEmpty) {
        queryParameters['order'] = order;
      }
    }

    final response = await _dio.get(
      ApiConstants.searchEndpoint,
      queryParameters: queryParameters,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchProductsByCategory({
    required String categorySlug,
    int limit = ApiConstants.defaultPageSize,
    int skip = 0,
    String? sortBy,
    String? order,
  }) async {
    final queryParameters = <String, dynamic>{'limit': limit, 'skip': skip};
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParameters['sortBy'] = sortBy;
      if (order != null && order.isNotEmpty) {
        queryParameters['order'] = order;
      }
    }

    final response = await _dio.get(
      '${ApiConstants.categoryEndpoint}/$categorySlug',
      queryParameters: queryParameters,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> fetchCategories() async {
    final response = await _dio.get(ApiConstants.categoriesEndpoint);
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> fetchProductById(int id) async {
    final response = await _dio.get('${ApiConstants.productsEndpoint}/$id');
    return response.data as Map<String, dynamic>;
  }
}
