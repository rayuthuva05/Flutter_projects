import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/network/api_error_formatter.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._repository, this._cartCubit) : super(const AccountState());

  final StoreRepository _repository;
  final CartCubit _cartCubit;

  void setFormMode(AccountFormMode mode) {
    emit(state.copyWith(formMode: mode, errorMessage: null));
  }

  Future<void> maybeBootstrap(bool enabled) async {
    if (!enabled) {
      emit(
        state.copyWith(
          status: AccountStatus.guest,
          clearUser: true,
          orders: const [],
          addresses: const [],
        ),
      );
      return;
    }

    await bootstrap();
  }

  Future<void> bootstrap() async {
    emit(state.copyWith(status: AccountStatus.loading, errorMessage: null));

    final token = await _repository.readToken();
    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(
          status: AccountStatus.guest,
          clearUser: true,
          orders: const [],
          addresses: const [],
        ),
      );
      return;
    }

    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: AccountStatus.loading, errorMessage: null));

    try {
      final user = await _repository.fetchCurrentUser();
      final orders = await _repository.fetchOrders();
      final addresses = await _repository.fetchAddresses();

      emit(
        state.copyWith(
          status: AccountStatus.authenticated,
          user: user,
          orders: orders,
          addresses: addresses,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    try {
      await _repository.login(email: email, password: password);
      await _cartCubit.load();
      await refresh();
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    try {
      await _repository.register(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      await _cartCubit.load();
      await refresh();
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    await _repository.logout();
    await _cartCubit.clearToken();

    emit(
      state.copyWith(
        status: AccountStatus.guest,
        clearUser: true,
        orders: const [],
        addresses: const [],
        errorMessage: null,
      ),
    );
  }

  Future<StoreAddress?> createAddress({
    required String name,
    required String mobile,
    required String address,
    String? addressLine1,
    String? zip,
    double? latitude,
    double? longitude,
    String? note,
  }) async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    try {
      final createdAddress = await _repository.createAddress(
        name: name,
        mobile: mobile,
        address: address,
        addressLine1: addressLine1,
        zip: zip,
        latitude: latitude,
        longitude: longitude,
        note: note,
      );
      await refresh();
      return createdAddress;
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
      return null;
    }
  }

  Future<StoreAddress?> updateAddress({
    required int addressId,
    required String name,
    required String mobile,
    required String address,
    String? addressLine1,
    String? zip,
    double? latitude,
    double? longitude,
    String? note,
  }) async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    try {
      final updatedAddress = await _repository.updateAddress(
        addressId: addressId,
        name: name,
        mobile: mobile,
        address: address,
        addressLine1: addressLine1,
        zip: zip,
        latitude: latitude,
        longitude: longitude,
        note: note,
      );
      await refresh();
      return updatedAddress;
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
      return null;
    }
  }

  Future<void> deleteAddress(int addressId) async {
    emit(state.copyWith(status: AccountStatus.submitting, errorMessage: null));

    try {
      await _repository.deleteAddress(addressId);
      await refresh();
    } catch (error) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: ApiErrorFormatter.message(error),
        ),
      );
    }
  }
}
