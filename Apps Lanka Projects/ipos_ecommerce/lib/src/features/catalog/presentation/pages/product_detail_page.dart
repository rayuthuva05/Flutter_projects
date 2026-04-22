import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/widgets/store_back_button.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/product_detail_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/cubit/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductDetailCubit(context.read<StoreRepository>())..load(slug),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            builder: (context, state) {
              if (state.status == ProductDetailStatus.loading ||
                  state.status == ProductDetailStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ProductDetailStatus.failure ||
                  state.product == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      state.errorMessage ?? 'Unable to load product details.',
                    ),
                  ),
                );
              }

              final product = state.product!;
              final image = product.imageUrls.isNotEmpty
                  ? product.imageUrls.first
                  : product.imageUrl;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leadingWidth: 64,
                    leading: const StoreBackButton(onHero: true),
                    pinned: true,
                    expandedHeight: 360,
                    flexibleSpace: FlexibleSpaceBar(
                      background: image != null && image.isNotEmpty
                          ? Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFF0E5D8),
                                    child: const Icon(
                                      Icons.image_outlined,
                                      size: 68,
                                    ),
                                  ),
                            )
                          : Container(
                              color: const Color(0xFFF0E5D8),
                              child: const Icon(Icons.image_outlined, size: 68),
                            ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.brandName ??
                                product.categoryName ??
                                'Store item',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Text(
                                'EUR ${product.effectivePrice.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(width: 10),
                              if (product.hasDiscount)
                                Text(
                                  'EUR ${product.comparePrice!.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if ((product.subTitle ?? '').isNotEmpty)
                            Text(
                              product.subTitle!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          if ((product.subTitle ?? '').isNotEmpty)
                            const SizedBox(height: 14),
                          Text(
                            product.description ??
                                product.note ??
                                'No description available for this product yet.',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.55),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: product.isInStock
                                  ? () => context.read<CartCubit>().addItem(
                                      product.id,
                                    )
                                  : null,
                              child: Text(
                                product.isInStock
                                    ? 'Add to cart'
                                    : 'Out of stock',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
