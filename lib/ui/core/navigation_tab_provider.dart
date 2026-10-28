import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationTab { catalog, categories, wishlist, profile, cart }

final navigationTabProvider =
    NotifierProvider<NavigationTabNotifier, NavigationTab>(
      NavigationTabNotifier.new,
    );

class NavigationTabNotifier extends Notifier<NavigationTab> {
  @override
  NavigationTab build() => NavigationTab.catalog;

  void setTab(NavigationTab tab) {
    state = tab;
  }

  void setTabIndex(int index) {
    switch (index) {
      case 0:
        state = NavigationTab.catalog;
        break;
      case 1:
        state = NavigationTab.categories;
        break;
      case 2:
        state = NavigationTab.wishlist;
        break;
      case 3:
        state = NavigationTab.profile;
        break;
      case 4:
        state = NavigationTab.cart;
        break;
    }
  }

  void toCatalog() => state = NavigationTab.catalog;
  void toCategories() => state = NavigationTab.categories;
  void toWishlist() => state = NavigationTab.wishlist;
  void toProfile() => state = NavigationTab.profile;
  void toCart() => state = NavigationTab.cart;
}
