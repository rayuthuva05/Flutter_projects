import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';

import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(const CartState());

  final StoreRepository _repository;

  Future<void> maybeBootstrap(bool enabled) async {
    if (!enabled) {
      emit(state.copyWith(status: CartStatus.success, errorMessage: null));
      return;
    }

    await load();
  }

  Future<void> load() async {
    final token = await _repository.readToken();
    emit(state.copyWith(token: token));

    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: CartStatus.success));
      return;
    }

    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));

    try {
      final summary = await _repository.fetchCart();
      emit(state.copyWith(status: CartStatus.success, summary: summary));
    } catch (error) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> addItem(int variantId, {int qty = 1}) async {
    if (!state.isAuthenticated) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Sign in to add items to your bag.',
        ),
      );
      return;
    }

    try {
      final summary = await _repository.addToCart(
        variantId: variantId,
        qty: qty,
      );
      emit(state.copyWith(status: CartStatus.success, summary: summary));
    } catch (error) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> updateItem(String cartId, int qty) async {
    try {
      final summary = await _repository.updateCartItem(
        cartId: cartId,
        qty: qty,
      );
      emit(state.copyWith(status: CartStatus.success, summary: summary));
    } catch (error) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> removeItem(String cartId) async {
    try {
      final summary = await _repository.removeCartItem(cartId);
      emit(state.copyWith(status: CartStatus.success, summary: summary));
    } catch (error) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> saveToken(String token) async {
    await _repository.saveToken(token);
    await load();
  }

  Future<void> clearToken() async {
    await _repository.clearToken();
    emit(
      state.copyWith(
        token: '',
        summary: const CartSummary(
          items: [],
          totals: PriceSummary(subtotal: 0, shipping: 0, vat: 0, total: 0),
          cartCount: 0,
          hasStockIssues: false,
          message: null,
        ),
        status: CartStatus.success,
        errorMessage: null,
      ),
    );
  }
}
