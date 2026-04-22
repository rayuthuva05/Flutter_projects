import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.summary = const CartSummary(
      items: [],
      totals: PriceSummary(subtotal: 0, shipping: 0, vat: 0, total: 0),
      cartCount: 0,
      hasStockIssues: false,
      message: null,
    ),
    this.errorMessage,
    this.token,
  });

  final CartStatus status;
  final CartSummary summary;
  final String? errorMessage;
  final String? token;

  CartState copyWith({
    CartStatus? status,
    CartSummary? summary,
    String? errorMessage,
    String? token,
  }) {
    return CartState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
      token: token ?? this.token,
    );
  }

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  @override
  List<Object?> get props => [status, summary, errorMessage, token];
}

enum CartStatus { initial, loading, success, failure }
