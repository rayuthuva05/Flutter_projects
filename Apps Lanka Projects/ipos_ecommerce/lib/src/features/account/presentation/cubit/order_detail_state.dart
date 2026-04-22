import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class OrderDetailState extends Equatable {
  const OrderDetailState({
    this.status = OrderDetailStatus.initial,
    this.order,
    this.errorMessage,
  });

  final OrderDetailStatus status;
  final StoreOrder? order;
  final String? errorMessage;

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    StoreOrder? order,
    String? errorMessage,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, order, errorMessage];
}

enum OrderDetailStatus { initial, loading, success, failure }
