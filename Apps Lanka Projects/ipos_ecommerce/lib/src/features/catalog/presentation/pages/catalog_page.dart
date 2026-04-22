import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/core/widgets/store_product_card.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/pages/product_detail_page.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.showProductImages = true});

  final bool showProductImages;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatalogCubit, CatalogState>(
      listener: (context, state) {
        if (_searchController.text != state.search) {
          _searchController.value = TextEditingValue(
            text: state.search,
            selection: TextSelection.collapsed(offset: state.search.length),
          );
        }
      },
      builder: (context, state) {
        final selectedCategory = _findCategory(
          state.categories,
          state.selectedCategoryId,
        );
        final selectedBrand = _findBrand(state.brands, state.selectedBrandId);

        return RefreshIndicator(
          onRefresh: () => context.read<CatalogCubit>().load(
            search: state.search,
            categoryId: state.selectedCategoryId,
            brandId: state.selectedBrandId,
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
            sort: state.sort,
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: [
              _ShopHero(activeFilterCount: state.activeFilterCount),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) =>
                    context.read<CatalogCubit>().load(search: value.trim()),
                decoration: InputDecoration(
                  hintText: 'Search pieces, SKU, or collection...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      context.read<CatalogCubit>().load(search: '');
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showFilterSheet(context, state),
                      icon: const Icon(Icons.tune_rounded),
                      label: Text(
                        state.activeFilterCount == 0
                            ? 'Filters'
                            : 'Filters (${state.activeFilterCount})',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showSortSheet(context, state.sort),
                      icon: const Icon(Icons.swap_vert_rounded),
                      label: Text(_sortLabel(state.sort)),
                    ),
                  ),
                ],
              ),
              if (state.hasActiveFilters) ...[
                const SizedBox(height: 14),
                _ActiveFiltersBar(
                  category: selectedCategory,
                  brand: selectedBrand,
                  minPrice: state.minPrice,
                  maxPrice: state.maxPrice,
                  sort: state.sort,
                  onRemoveCategory: () => context.read<CatalogCubit>().load(
                    categoryId: null,
                    clearCategory: true,
                  ),
                  onRemoveBrand: () => context.read<CatalogCubit>().load(
                    brandId: null,
                    clearBrand: true,
                  ),
                  onRemovePrice: () => context.read<CatalogCubit>().load(
                    clearMinPrice: true,
                    clearMaxPrice: true,
                  ),
                  onRemoveSort: () =>
                      context.read<CatalogCubit>().setSort('latest'),
                  onClearAll: () => context.read<CatalogCubit>().clearFilters(),
                ),
              ],
              if (state.categories.isNotEmpty) ...[
                const SizedBox(height: 18),
                _FilterStrip(
                  title: 'Quick categories',
                  child: SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final selected =
                            state.selectedCategoryId == category.id;

                        return ChoiceChip(
                          label: Text(category.name),
                          selected: selected,
                          onSelected: (_) => context
                              .read<CatalogCubit>()
                              .toggleCategory(category.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
              if (state.brands.isNotEmpty) ...[
                const SizedBox(height: 16),
                _FilterStrip(
                  title: 'Popular brands',
                  child: SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.brands.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final brand = state.brands[index];
                        final selected = state.selectedBrandId == brand.id;

                        return FilterChip(
                          selected: selected,
                          avatar:
                              brand.imageUrl != null &&
                                  brand.imageUrl!.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    brand.imageUrl!,
                                  ),
                                )
                              : const CircleAvatar(
                                  child: Icon(
                                    Icons.storefront_outlined,
                                    size: 16,
                                  ),
                                ),
                          label: Text(brand.name),
                          onSelected: (_) => context
                              .read<CatalogCubit>()
                              .toggleBrand(brand.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (state.status == CatalogStatus.loading)
                const LinearProgressIndicator(),
              if (state.status == CatalogStatus.failure)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(state.errorMessage ?? 'Unable to load products.'),
                ),
              if (state.products.isEmpty &&
                  state.status == CatalogStatus.success)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color ?? Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: context.storeTheme.indicatorInactive,
                    ),
                  ),
                  child: const Text(
                    'No matching pieces were found. Try another combination of filters.',
                  ),
                ),
              if (state.products.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  '${state.products.length} pieces',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.56,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return StoreProductCard(
                      product: product,
                      currencySymbol: 'EUR ',
                      showProductImage: widget.showProductImages,
                      onAddToCart: () =>
                          context.read<CartCubit>().addItem(product.id),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(slug: product.slug),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSortSheet(BuildContext context, String currentSort) async {
    final cubit = context.read<CatalogCubit>();
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        const options = <MapEntry<String, String>>[
          MapEntry('latest', 'Latest'),
          MapEntry('popular', 'Popular'),
          MapEntry('price_asc', 'Price: Low to high'),
          MapEntry('price_desc', 'Price: High to low'),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 14),
                ...options.map(
                  (option) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.value),
                    trailing: currentSort == option.key
                        ? const Icon(Icons.check_circle)
                        : null,
                    onTap: () => Navigator.of(context).pop(option.key),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      await cubit.setSort(selected);
    }
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    CatalogState state,
  ) async {
    final cubit = context.read<CatalogCubit>();
    int? selectedCategoryId = state.selectedCategoryId;
    int? selectedBrandId = state.selectedBrandId;
    final minController = TextEditingController(
      text: state.minPrice?.toStringAsFixed(0) ?? '',
    );
    final maxController = TextEditingController(
      text: state.maxPrice?.toStringAsFixed(0) ?? '',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Refine products',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose a category, brand, and price window.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 18),
                      if (state.categories.isNotEmpty) ...[
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.categories.map((category) {
                            final selected = selectedCategoryId == category.id;
                            return ChoiceChip(
                              label: Text(category.name),
                              selected: selected,
                              onSelected: (_) => setModalState(() {
                                selectedCategoryId = selected
                                    ? null
                                    : category.id;
                              }),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                      ],
                      if (state.brands.isNotEmpty) ...[
                        Text(
                          'Brand',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.brands.map((brand) {
                            final selected = selectedBrandId == brand.id;
                            return ChoiceChip(
                              label: Text(brand.name),
                              selected: selected,
                              onSelected: (_) => setModalState(() {
                                selectedBrandId = selected ? null : brand.id;
                              }),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                      ],
                      Text(
                        'Price range',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: minController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Min',
                                prefixText: 'EUR ',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: maxController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Max',
                                prefixText: 'EUR ',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await cubit.clearFilters();
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await cubit.applyAdvancedFilters(
                                  categoryId: selectedCategoryId,
                                  brandId: selectedBrandId,
                                  minPrice: _parsePrice(minController.text),
                                  maxPrice: _parsePrice(maxController.text),
                                );
                              },
                              child: const Text('Apply filters'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    minController.dispose();
    maxController.dispose();
  }

  double? _parsePrice(String raw) {
    final value = double.tryParse(raw.trim());
    return value == null || value <= 0 ? null : value;
  }

  String _sortLabel(String sort) {
    switch (sort) {
      case 'popular':
        return 'Popular';
      case 'price_asc':
        return 'Low to high';
      case 'price_desc':
        return 'High to low';
      default:
        return 'Latest';
    }
  }

  StoreCategory? _findCategory(List<StoreCategory> items, int? id) {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  StoreBrand? _findBrand(List<StoreBrand> items, int? id) {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}

class _ShopHero extends StatelessWidget {
  const _ShopHero({required this.activeFilterCount});

  final int activeFilterCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: tokens.onHero.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              activeFilterCount == 0
                  ? 'Shop'
                  : '$activeFilterCount filters active',
              style: TextStyle(
                color: tokens.onHero,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Find your next favorite piece',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: tokens.onHero),
          ),
          const SizedBox(height: 10),
          Text(
            'Use quick chips for fast browsing or open the filter sheet for brands, price, and sorting.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: tokens.onHeroMuted),
          ),
        ],
      ),
    );
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  const _ActiveFiltersBar({
    required this.category,
    required this.brand,
    required this.minPrice,
    required this.maxPrice,
    required this.sort,
    required this.onRemoveCategory,
    required this.onRemoveBrand,
    required this.onRemovePrice,
    required this.onRemoveSort,
    required this.onClearAll,
  });

  final StoreCategory? category;
  final StoreBrand? brand;
  final double? minPrice;
  final double? maxPrice;
  final String sort;
  final VoidCallback onRemoveCategory;
  final VoidCallback onRemoveBrand;
  final VoidCallback onRemovePrice;
  final VoidCallback onRemoveSort;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (category != null)
              _ActiveChip(label: category!.name, onDeleted: onRemoveCategory),
            if (brand != null)
              _ActiveChip(label: brand!.name, onDeleted: onRemoveBrand),
            if (minPrice != null || maxPrice != null)
              _ActiveChip(
                label:
                    'EUR ${minPrice?.toStringAsFixed(0) ?? '0'} - ${maxPrice?.toStringAsFixed(0) ?? 'Any'}',
                onDeleted: onRemovePrice,
              ),
            if (sort != 'latest')
              _ActiveChip(
                label: 'Sort: ${_sortText(sort)}',
                onDeleted: onRemoveSort,
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onClearAll,
          child: const Text('Clear all filters'),
        ),
      ],
    );
  }

  String _sortText(String value) {
    switch (value) {
      case 'popular':
        return 'Popular';
      case 'price_asc':
        return 'Low to high';
      case 'price_desc':
        return 'High to low';
      default:
        return 'Latest';
    }
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(selected: true, label: Text(label), onDeleted: onDeleted);
  }
}

class _FilterStrip extends StatelessWidget {
  const _FilterStrip({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
