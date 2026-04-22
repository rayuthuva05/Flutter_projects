import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.brands = const [],
    this.search = '',
    this.selectedCategoryId,
    this.selectedBrandId,
    this.minPrice,
    this.maxPrice,
    this.sort = 'latest',
    this.errorMessage,
  });

  final CatalogStatus status;
  final List<StoreProduct> products;
  final List<StoreCategory> categories;
  final List<StoreBrand> brands;
  final String search;
  final int? selectedCategoryId;
  final int? selectedBrandId;
  final double? minPrice;
  final double? maxPrice;
  final String sort;
  final String? errorMessage;

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedBrandId != null ||
      minPrice != null ||
      maxPrice != null ||
      sort != 'latest';

  int get activeFilterCount {
    var count = 0;
    if (selectedCategoryId != null) count++;
    if (selectedBrandId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (sort != 'latest') count++;
    return count;
  }

  CatalogState copyWith({
    CatalogStatus? status,
    List<StoreProduct>? products,
    List<StoreCategory>? categories,
    List<StoreBrand>? brands,
    String? search,
    int? selectedCategoryId,
    int? selectedBrandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    String? errorMessage,
    bool clearCategory = false,
    bool clearBrand = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      search: search ?? this.search,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedBrandId: clearBrand
          ? null
          : (selectedBrandId ?? this.selectedBrandId),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sort: sort ?? this.sort,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    categories,
    brands,
    search,
    selectedCategoryId,
    selectedBrandId,
    minPrice,
    maxPrice,
    sort,
    errorMessage,
  ];
}

enum CatalogStatus { initial, loading, success, failure }
