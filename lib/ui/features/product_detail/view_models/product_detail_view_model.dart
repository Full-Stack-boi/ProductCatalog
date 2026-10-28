import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/data/repositories/product_repository.dart';

final productDetailProvider = FutureProvider.autoDispose.family<Product, int>((
  ref,
  id,
) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});
