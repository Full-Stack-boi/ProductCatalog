import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_catalog/core/theme/app_theme.dart';
import 'package:product_catalog/data/models/product_sort_option.dart';
import 'package:product_catalog/ui/core/l10n_extensions.dart';
import 'package:product_catalog/ui/core/widgets/filter_bottom_sheet.dart';
import 'package:product_catalog/ui/features/catalog/view_models/catalog_view_model.dart';

class CatalogSearchBar extends ConsumerStatefulWidget {
  const CatalogSearchBar({super.key});

  @override
  ConsumerState<CatalogSearchBar> createState() => _CatalogSearchBarState();
}

class _CatalogSearchBarState extends ConsumerState<CatalogSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = ref.watch(
      catalogViewModelProvider.select((s) => s.hasActiveFilters),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (val) {
                  ref
                      .read(catalogViewModelProvider.notifier)
                      .onSearchChanged(val);
                  setState(() {});
                },
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: false,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 48,
                  ),
                  suffixIconConstraints: const BoxConstraints(minHeight: 48),
                  hintText: context.l10n.searchHint,
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF64748B),
                    size: 22,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Color(0xFF64748B),
                          ),
                          onPressed: () {
                            _controller.clear();
                            ref
                                .read(catalogViewModelProvider.notifier)
                                .clearSearch();
                            setState(() {});
                          },
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.mic_none_rounded,
                          color: Color(0xFF64748B),
                          size: 22,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.searchVoiceStarting),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              FilterBottomSheet.show(context);
            },
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF0F172A),
                    size: 22,
                  ),
                ),
                if (hasActiveFilters)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CatalogCountAndSortBar extends ConsumerWidget {
  const CatalogCountAndSortBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(
      catalogViewModelProvider.select((s) => s.sortOption),
    );
    final effectiveTotal = ref.watch(
      catalogViewModelProvider.select((s) => s.effectiveTotal),
    );
    final loadedCount = ref.watch(
      catalogViewModelProvider.select((s) => s.loadedCount),
    );
    final isSearching = ref.watch(
      catalogViewModelProvider.select((s) => s.searchQuery.isNotEmpty),
    );
    final hasActiveFilters = ref.watch(
      catalogViewModelProvider.select((s) => s.hasActiveFilters),
    );
    final isLoading = ref.watch(
      catalogViewModelProvider.select((s) => s.isLoadingInitial),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    isLoading
                        ? context.l10n.loading
                        : context.l10n.showingCountOfTotal(
                            loadedCount,
                            effectiveTotal,
                          ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSearching) ...[
                  const SizedBox(width: 6),
                  Text(
                    '(${context.l10n.filterTooltip})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (hasActiveFilters && !isLoading) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      ref
                          .read(catalogViewModelProvider.notifier)
                          .resetFilters();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.filterResetSnackbar),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.l10n.clearFiltersChip,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.close_rounded,
                            size: 13,
                            color: Color(0xFFDC2626),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<ProductSortOption>(
            initialValue: currentSort,
            onSelected: (option) {
              ref.read(catalogViewModelProvider.notifier).setSortOption(option);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) {
              return ProductSortOption.values.map((option) {
                final isSelected = option == currentSort;
                return PopupMenuItem<ProductSortOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 18,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        option.localizedLabel(context.l10n),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentSort.localizedLabel(context.l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: Color(0xFF0F172A),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
