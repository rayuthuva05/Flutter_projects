import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.initial,
    this.formMode = AccountFormMode.login,
    this.user,
    this.orders = const [],
    this.addresses = const [],
    this.errorMessage,
  });

  final AccountStatus status;
  final AccountFormMode formMode;
  final StoreUser? user;
  final List<StoreOrder> orders;
  final List<StoreAddress> addresses;
  final String? errorMessage;

  bool get isAuthenticated => user != null;

  AccountState copyWith({
    AccountStatus? status,
    AccountFormMode? formMode,
    StoreUser? user,
    List<StoreOrder>? orders,
    List<StoreAddress>? addresses,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AccountState(
      status: status ?? this.status,
      formMode: formMode ?? this.formMode,
      user: clearUser ? null : (user ?? this.user),
      orders: orders ?? this.orders,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    formMode,
    user,
    orders,
    addresses,
    errorMessage,
  ];
}

enum AccountStatus {
  initial,
  loading,
  authenticated,
  guest,
  failure,
  submitting,
}

enum AccountFormMode { login, register }
