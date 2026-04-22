import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository) : super(const CatalogState());

  final StoreRepository _repository;

  Future<void> maybeBootstrap(bool enabled) async {
    if (!enabled) {
      return;
    }

    await load();
  }

  Future<void> load({
    String? search,
    int? categoryId,
    int? brandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    bool clearCategory = false,
    bool clearBrand = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) async {
    final resolvedSearch = search ?? state.search;
    final resolvedCategoryId = clearCategory
        ? null
        : (categoryId ?? state.selectedCategoryId);
    final resolvedBrandId = clearBrand
        ? null
        : (brandId ?? state.selectedBrandId);
    final resolvedMinPrice = clearMinPrice ? null : (minPrice ?? state.minPrice);
    final resolvedMaxPrice = clearMaxPrice ? null : (maxPrice ?? state.maxPrice);
    final resolvedSort = sort ?? state.sort;

    emit(
      state.copyWith(
        status: CatalogStatus.loading,
        search: resolvedSearch,
        selectedCategoryId: resolvedCategoryId,
        selectedBrandId: resolvedBrandId,
        minPrice: resolvedMinPrice,
        maxPrice: resolvedMaxPrice,
        sort: resolvedSort,
        errorMessage: null,
        clearCategory: clearCategory,
        clearBrand: clearBrand,
        clearMinPrice: clearMinPrice,
        clearMaxPrice: clearMaxPrice,
      ),
    );

    try {
      final products = await _repository.fetchProducts(
        search: resolvedSearch,
        categoryId: resolvedCategoryId,
        brandId: resolvedBrandId,
        minPrice: resolvedMinPrice,
        maxPrice: resolvedMaxPrice,
        sort: resolvedSort,
      );
      final categories = await _repository.fetchCategories();
      final brands = await _repository.fetchBrands();

      emit(
        state.copyWith(
          status: CatalogStatus.success,
          products: products.items,
          categories: categories,
          brands: brands,
          selectedCategoryId: resolvedCategoryId,
          selectedBrandId: resolvedBrandId,
          minPrice: resolvedMinPrice,
          maxPrice: resolvedMaxPrice,
          sort: resolvedSort,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CatalogStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> toggleCategory(int? categoryId) async {
    final shouldClear = state.selectedCategoryId == categoryId;
    await load(
      categoryId: shouldClear ? null : categoryId,
      clearCategory: shouldClear,
    );
  }

  Future<void> toggleBrand(int? brandId) async {
    final shouldClear = state.selectedBrandId == brandId;
    await load(brandId: shouldClear ? null : brandId, clearBrand: shouldClear);
  }

  Future<void> clearFilters() async {
    await load(
      clearCategory: true,
      clearBrand: true,
      clearMinPrice: true,
      clearMaxPrice: true,
      search: state.search,
      sort: 'latest',
    );
  }

  Future<void> applyAdvancedFilters({
    int? categoryId,
    int? brandId,
    double? minPrice,
    double? maxPrice,
  }) async {
    await load(
      categoryId: categoryId,
      brandId: brandId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      clearCategory: categoryId == null,
      clearBrand: brandId == null,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
    );
  }

  Future<void> setSort(String sort) async {
    await load(sort: sort);
  }
}
