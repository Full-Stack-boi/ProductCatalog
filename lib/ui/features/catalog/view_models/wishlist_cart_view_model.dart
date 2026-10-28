import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistProvider = NotifierProvider<WishlistViewModel, Set<int>>(
  WishlistViewModel.new,
);

class WishlistViewModel extends Notifier<Set<int>> {
  @override
  Set<int> build() => <int>{};

  void toggle(int productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(int productId) => state.contains(productId);
}

final cartProvider = NotifierProvider<CartViewModel, Map<int, int>>(
  CartViewModel.new,
);

class CartViewModel extends Notifier<Map<int, int>> {
  @override
  Map<int, int> build() => <int, int>{};

  int get totalItemCount => state.values.fold(0, (sum, count) => sum + count);

  void addItem(int productId, [int quantity = 1]) {
    final current = state[productId] ?? 0;
    state = {...state, productId: current + quantity};
  }

  void removeItem(int productId) {
    if (!state.containsKey(productId)) return;
    final current = state[productId]!;
    if (current <= 1) {
      final updated = {...state}..remove(productId);
      state = updated;
    } else {
      state = {...state, productId: current - 1};
    }
  }

  void deleteItem(int productId) {
    if (!state.containsKey(productId)) return;
    final updated = {...state}..remove(productId);
    state = updated;
  }

  void clearCart() {
    state = <int, int>{};
  }
}
