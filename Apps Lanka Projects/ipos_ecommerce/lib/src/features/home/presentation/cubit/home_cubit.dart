import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final StoreRepository _repository;

  Future<void> maybeBootstrap(bool enabled) async {
    if (!enabled) {
      return;
    }

    await load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, errorMessage: null));

    try {
      final data = await _repository.fetchHome();
      emit(state.copyWith(status: HomeStatus.success, data: data));
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
