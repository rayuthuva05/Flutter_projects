import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  final ProductDetailStatus status;
  final StoreProduct? product;
  final String? errorMessage;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    StoreProduct? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}

enum ProductDetailStatus { initial, loading, success, failure }
