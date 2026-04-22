import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/network/api_client_factory.dart';
import 'package:flutter_store_app/src/core/storage/session_storage.dart';
import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/account_cubit.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_store_app/src/features/home/presentation/pages/store_shell_page.dart';

class StoreApp extends StatelessWidget {
  const StoreApp({super.key, this.bootstrapFeatures = true});

  final bool bootstrapFeatures;

  @override
  Widget build(BuildContext context) {
    final sessionStorage = SessionStorage();
    final repository = StoreRepository(
      ApiClientFactory(sessionStorage).createStoreApiClient(),
      sessionStorage,
    );

    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                CartCubit(repository)..maybeBootstrap(bootstrapFeatures),
          ),
          BlocProvider(
            create: (_) =>
                HomeCubit(repository)..maybeBootstrap(bootstrapFeatures),
          ),
          BlocProvider(
            create: (_) =>
                CatalogCubit(repository)..maybeBootstrap(bootstrapFeatures),
          ),
          BlocProvider(
            create: (context) =>
                AccountCubit(repository, context.read<CartCubit>())
                  ..maybeBootstrap(bootstrapFeatures),
          ),
          BlocProvider(
            create: (context) =>
                CheckoutCubit(repository, context.read<CartCubit>()),
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            final storeConfig = homeState.data;

            return MaterialApp(
              title: 'Store App',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(
                themeKey: storeConfig?.themeKey ?? 'foodwin',
                primaryColorHex: storeConfig?.primaryColorHex,
                accentColorHex: storeConfig?.accentColorHex,
              ),
              home: const StoreShellPage(),
            );
          },
        ),
      ),
    );
  }
}
