import 'package:equatable/equatable.dart';

import 'package:flutter_store_app/src/shared/models/store_models.dart';

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.errorMessage,
  });

  final HomeStatus status;
  final StoreHomeData? data;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    StoreHomeData? data,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}

enum HomeStatus { initial, loading, success, failure }
