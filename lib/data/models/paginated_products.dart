import 'product.dart';

class PaginatedProducts {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const PaginatedProducts({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PaginatedProducts.fromJson(Map<String, dynamic> json) {
    final rawList = json['products'] as List<dynamic>? ?? [];
    return PaginatedProducts(
      products: rawList
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );
  }

  bool get hasMore => (skip + products.length) < total;

  int get currentPage {
    final pageSize = limit > 0 ? limit : 20;
    return (skip / pageSize).floor() + 1;
  }

  int get totalPages {
    final pageSize = limit > 0 ? limit : 20;
    return (total / pageSize).ceil();
  }
}
