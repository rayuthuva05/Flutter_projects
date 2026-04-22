import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/network/api_error_formatter.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._repository, this._cartCubit)
    : super(const CheckoutState());

  final StoreRepository _repository;
  final CartCubit _cartCubit;

  Future<void> loadSummary() async {
    emit(
      state.copyWith(
        status: CheckoutStatus.loading,
        errorMessage: null,
        clearPlacedOrder: true,
        clearStripePaymentIntent: true,
      ),
    );

    try {
      final summary = await _repository.fetchCheckoutSummary();
      final currentAddressId = state.selectedAddressId;
      final resolvedAddressId =
          summary.addresses.any((address) => address.id == currentAddressId)
          ? currentAddressId
          : (summary.addresses.isNotEmpty ? summary.addresses.first.id : null);
      final preferredPaymentMethod =
          summary.paymentMethods.any(
            (method) => method.code == state.paymentMethod,
          )
          ? state.paymentMethod
          : (summary.paymentMethods.any((method) => method.code == 'cod')
                ? 'cod'
                : 'stripe');

      emit(
        state.copyWith(
          status: CheckoutStatus.ready,
          summary: summary,
          selectedAddressId: resolvedAddressId,
          paymentMethod: preferredPaymentMethod,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }

  void selectAddress(int id) {
    emit(state.copyWith(selectedAddressId: id));
  }

  void setPaymentMethod(String value) {
    emit(
      state.copyWith(
        paymentMethod: value,
        errorMessage: null,
        clearStripePaymentIntent: true,
      ),
    );
  }

  void setNote(String value) {
    emit(state.copyWith(note: value));
  }

  Future<void> prepareStripePayment() async {
    if (state.selectedAddressId == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Please select a delivery address.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CheckoutStatus.preparingPayment,
        errorMessage: null,
        clearStripePaymentIntent: true,
      ),
    );

    try {
      final paymentIntent = await _repository.createPaymentIntent();
      emit(
        state.copyWith(
          status: CheckoutStatus.ready,
          stripePaymentIntent: paymentIntent,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }

  Future<void> placeOrder() async {
    if (state.selectedAddressId == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Please select a delivery address.',
        ),
      );
      return;
    }

    if (state.paymentMethod == 'stripe') {
      await prepareStripePayment();
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.placing, errorMessage: null));

    try {
      final order = await _repository.placeOrder(
        addressId: state.selectedAddressId!,
        paymentMethod: state.paymentMethod,
        notes: state.note,
      );
      await _cartCubit.load();
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          placedOrder: order,
          clearStripePaymentIntent: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }
}
