import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.summary,
    this.selectedAddressId,
    this.paymentMethod = 'cod',
    this.note = '',
    this.stripePaymentIntent,
    this.placedOrder,
    this.errorMessage,
  });

  final CheckoutStatus status;
  final CheckoutSummary? summary;
  final int? selectedAddressId;
  final String paymentMethod;
  final String note;
  final StripePaymentIntentData? stripePaymentIntent;
  final StoreOrder? placedOrder;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    CheckoutSummary? summary,
    int? selectedAddressId,
    String? paymentMethod,
    String? note,
    StripePaymentIntentData? stripePaymentIntent,
    StoreOrder? placedOrder,
    String? errorMessage,
    bool clearPlacedOrder = false,
    bool clearStripePaymentIntent = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      stripePaymentIntent: clearStripePaymentIntent
          ? null
          : (stripePaymentIntent ?? this.stripePaymentIntent),
      placedOrder: clearPlacedOrder ? null : (placedOrder ?? this.placedOrder),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    selectedAddressId,
    paymentMethod,
    note,
    stripePaymentIntent,
    placedOrder,
    errorMessage,
  ];
}

enum CheckoutStatus {
  initial,
  loading,
  ready,
  preparingPayment,
  placing,
  success,
  failure,
}
