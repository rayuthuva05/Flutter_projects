import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._repository) : super(const ProductDetailState());

  final StoreRepository _repository;

  Future<void> load(String slug) async {
    emit(state.copyWith(status: ProductDetailStatus.loading, errorMessage: null));

    try {
      final product = await _repository.fetchProduct(slug);
      emit(state.copyWith(status: ProductDetailStatus.success, product: product));
    } catch (error) {
      emit(state.copyWith(status: ProductDetailStatus.failure, errorMessage: error.toString()));
    }
  }
}
