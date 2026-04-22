import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/features/account/presentation/pages/account_page.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_store_app/src/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/pages/catalog_page.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_store_app/src/features/home/presentation/pages/home_page.dart';

class StoreShellPage extends StatefulWidget {
  const StoreShellPage({super.key});

  @override
  State<StoreShellPage> createState() => _StoreShellPageState();
}

class _StoreShellPageState extends State<StoreShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        final showProductImages = homeState.data?.showProductImages ?? true;
        final pages = <Widget>[
          HomePage(onCategoryTap: _openCategory, onBrandTap: _openBrand),
          CatalogPage(showProductImages: showProductImages),
          const CartPage(),
          const AccountPage(),
        ];

        return BlocListener<CartCubit, CartState>(
          listenWhen: (previous, current) =>
              previous.summary.message != current.summary.message ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            final messenger = ScaffoldMessenger.of(context);
            final message = state.summary.message ?? state.errorMessage;
            if (message != null && message.isNotEmpty) {
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
          child: Scaffold(
            body: SafeArea(
              bottom: false,
              child: IndexedStack(index: _currentIndex, children: pages),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) =>
                    setState(() => _currentIndex = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.storefront_outlined),
                    label: 'Shop',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.shopping_bag_outlined),
                    label: 'Cart',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCategory(StoreCategory category) async {
    setState(() => _currentIndex = 1);
    await context.read<CatalogCubit>().load(
      search: '',
      categoryId: category.id,
      clearBrand: true,
    );
  }

  Future<void> _openBrand(StoreBrand brand) async {
    setState(() => _currentIndex = 1);
    await context.read<CatalogCubit>().load(
      search: '',
      brandId: brand.id,
      clearCategory: true,
    );
  }
}
