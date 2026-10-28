import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/core/utils/responsive_layout.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/locale_provider.dart';
import 'package:product_catalog/ui/core/navigation_tab_provider.dart';
import 'package:product_catalog/ui/core/skeleton_product_grid.dart';
import 'package:product_catalog/ui/core/state_views.dart';
import 'package:product_catalog/ui/core/widgets/filter_bottom_sheet.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_ui_state.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';
import 'package:product_catalog/ui/features/catalog/view_models/wishlist_cart_view_model.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/category_filter_bar.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/pagination_footer.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/product_card.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/search_and_sort_bar.dart';
import 'package:product_catalog/ui/features/catalog/views/widgets/state_preview_banner.dart';
import 'package:product_catalog/ui/features/product_detail/views/product_detail_view.dart';

class CatalogView extends ConsumerStatefulWidget {
  const CatalogView({super.key});

  @override
  ConsumerState<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends ConsumerState<CatalogView> {
  late final ScrollController _scrollController;
  int? _selectedProductIdForSplitView;
  bool _showArchitecturePreview = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0 && currentScroll >= (maxScroll * 0.85)) {
      ref.read(catalogViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catalogViewModelProvider);
    final cartCount = ref.watch(
      cartProvider.select((c) => c.values.fold(0, (sum, val) => sum + val)),
    );
    final currentLocale = ref.watch(localeProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final canSplitView = screenWidth >= 900;
    final showSplitView =
        canSplitView && _selectedProductIdForSplitView != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                context.l10n.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.search_rounded),
            tooltip: context.l10n.searchHint,
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  40,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          if (kDebugMode)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                _showArchitecturePreview
                    ? Icons.warning_amber_rounded
                    : Icons.warning_amber_rounded,
                color: _showArchitecturePreview
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
              tooltip: 'UI State Simulation',
              onPressed: () {
                setState(() {
                  _showArchitecturePreview = !_showArchitecturePreview;
                });
              },
            ),
          Tooltip(
            message: context.l10n.switchLanguageTooltip,
            child: InkWell(
              onTap: () {
                ref.read(localeProvider.notifier).cycleLocale();
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      currentLocale.languageCode.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Badge(
            isLabelVisible: cartCount > 0,
            label: Text(cartCount.toString()),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.shopping_cart_outlined),
              tooltip: context.l10n.cartTitle(cartCount),
              onPressed: () {
                ref.read(navigationTabProvider.notifier).toCart();
              },
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () {
              ref.read(navigationTabProvider.notifier).toProfile();
            },
            borderRadius: BorderRadius.circular(16),
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFF1F5F9),
              child: Icon(
                Icons.person_rounded,
                size: 18,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: showSplitView
          ? null
          : FloatingActionButton(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 4,
              onPressed: () => FilterBottomSheet.show(context),
              child: Badge(
                isLabelVisible: state.hasActiveFilters,
                smallSize: 8,
                backgroundColor: AppTheme.discountRed,
                child: const Icon(Icons.filter_alt_rounded, size: 24),
              ),
            ),
      body: Row(
        children: [
          Expanded(
            flex: showSplitView ? 7 : 12,
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(catalogViewModelProvider.notifier).refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Center(
                        child: Text(
                          '↓ ${context.l10n.pullToRefresh}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (kDebugMode && _showArchitecturePreview)
                    const SliverToBoxAdapter(child: StatePreviewBanner()),
                  const SliverToBoxAdapter(child: CatalogSearchBar()),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  const SliverToBoxAdapter(child: CategoryFilterBar()),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  const SliverToBoxAdapter(child: CatalogCountAndSortBar()),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _buildContentSliver(
                    context,
                    state,
                    showSplitView,
                    screenWidth,
                  ),
                  if ((!kDebugMode ||
                          state.previewMode == StatePreviewMode.none) &&
                      !state.isLoadingInitial &&
                      state.errorMessage == null &&
                      state.products.isNotEmpty)
                    const SliverToBoxAdapter(child: PaginationFooter()),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
          if (showSplitView) ...[
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppTheme.border,
            ),
            Expanded(
              flex: 5,
              child: ProductDetailView(
                productId: _selectedProductIdForSplitView!,
                onClose: () {
                  setState(() {
                    _selectedProductIdForSplitView = null;
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContentSliver(
    BuildContext context,
    CatalogUiState state,
    bool showSplitView,
    double screenWidth,
  ) {
    if (kDebugMode && state.previewMode == StatePreviewMode.loading) {
      return const SliverToBoxAdapter(child: SkeletonProductGrid(itemCount: 6));
    }

    if (kDebugMode && state.previewMode == StatePreviewMode.error) {
      return SliverToBoxAdapter(
        child: DioErrorView(
          message:
              'DioException [connection error]: ไม่สามารถเชื่อมต่อเครือข่ายได้ (จำลองการทดสอบ)',
          onRetry: () {
            ref
                .read(catalogViewModelProvider.notifier)
                .setPreviewMode(StatePreviewMode.none);
          },
        ),
      );
    }

    if (kDebugMode && state.previewMode == StatePreviewMode.empty) {
      return SliverToBoxAdapter(
        child: EmptyStateView(
          message: 'ไม่พบสินค้าที่ตรงกับเงื่อนไข (จำลองการทดสอบ)',
          onReset: () {
            ref
                .read(catalogViewModelProvider.notifier)
                .setPreviewMode(StatePreviewMode.none);
          },
        ),
      );
    }

    if (state.isLoadingInitial) {
      return const SliverToBoxAdapter(child: SkeletonProductGrid(itemCount: 6));
    }

    if (state.errorMessage != null) {
      return SliverToBoxAdapter(
        child: DioErrorView(
          message: state.errorMessage!,
          onRetry: () => ref.read(catalogViewModelProvider.notifier).retry(),
        ),
      );
    }

    if (state.products.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateView(
          message: state.searchQuery.isNotEmpty
              ? context.l10n.noProductsMatchingQuery(state.searchQuery)
              : context.l10n.noProductsMatchingFilters,
          onReset: () {
            ref.read(catalogViewModelProvider.notifier).resetFilters();
            ref.read(catalogViewModelProvider.notifier).selectCategory(null);
            ref.read(catalogViewModelProvider.notifier).clearSearch();
          },
        ),
      );
    }

    final columnCount = showSplitView
        ? (screenWidth > 1150 ? 3 : 2)
        : ResponsiveLayout.getGridColumnCount(screenWidth);
    final aspectRatio = ResponsiveLayout.getCardAspectRatio(screenWidth);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = state.products[index];
          return ProductCard(
            product: product,
            onTap: () {
              final canSplit = MediaQuery.sizeOf(context).width >= 900;
              if (canSplit) {
                setState(() {
                  _selectedProductIdForSplitView = product.id;
                });
              } else {
                context.push('/products/${product.id}');
              }
            },
          );
        }, childCount: state.products.length),
      ),
    );
  }
}
