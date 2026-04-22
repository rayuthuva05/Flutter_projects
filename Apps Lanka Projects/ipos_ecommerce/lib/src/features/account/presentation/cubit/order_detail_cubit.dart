import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/network/api_error_formatter.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this._repository) : super(const OrderDetailState());

  final StoreRepository _repository;

  Future<void> load(String orderId) async {
    emit(state.copyWith(status: OrderDetailStatus.loading, errorMessage: null));

    try {
      final order = await _repository.fetchOrder(orderId);
      emit(state.copyWith(status: OrderDetailStatus.success, order: order));
    } catch (error) {
      emit(
        state.copyWith(
          status: OrderDetailStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }
}
