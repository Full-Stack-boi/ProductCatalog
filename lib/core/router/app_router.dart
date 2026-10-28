import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../ui/core/adaptive_shell.dart';
import '../../ui/features/catalog/views/catalog_view.dart';
import '../../ui/features/product_detail/views/product_detail_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveShell(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const CatalogView()),
        ],
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final idString = state.pathParameters['id'];
          final productId = int.tryParse(idString ?? '') ?? 1;
          return ProductDetailView(productId: productId);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('ไม่พบหน้านี้: ${state.uri}'))),
  );
});
