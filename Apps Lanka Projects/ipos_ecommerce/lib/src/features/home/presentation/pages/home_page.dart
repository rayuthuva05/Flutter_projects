import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/core/widgets/store_product_card.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/catalog/presentation/pages/product_detail_page.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_store_app/src/features/home/presentation/cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onCategoryTap, this.onBrandTap});

  final ValueChanged<StoreCategory>? onCategoryTap;
  final ValueChanged<StoreBrand>? onBrandTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.data == null &&
            (state.status == HomeStatus.initial ||
                state.status == HomeStatus.loading)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure && state.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.errorMessage ?? 'Unable to load the store home.',
              ),
            ),
          );
        }

        final data = state.data!;
        final currency = data.currencySymbol;
        final showProductImages = data.showProductImages;

        return RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().load(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: [
              if (state.status == HomeStatus.loading) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 14),
              ],
              if (data.sliders.isNotEmpty)
                _HomeSliderCarousel(
                  storeName: data.storeName,
                  sliders: data.sliders,
                )
              else
                _FallbackHero(storeName: data.storeName),
              const SizedBox(height: 28),
              const _SectionHeader(
                title: 'Shop by category',
                subtitle:
                    'Explore popular collections and discover standout pieces.',
              ),
              const SizedBox(height: 12),
              _CategoryRail(
                categories: data.featuredCategories,
                onCategoryTap: onCategoryTap,
              ),
              if (data.featuredBrands.isNotEmpty) ...[
                const SizedBox(height: 28),
                const _SectionHeader(
                  title: 'Browse by brand',
                  subtitle:
                      'Explore collections from your featured store brands.',
                ),
                const SizedBox(height: 12),
                _BrandRail(brands: data.featuredBrands, onBrandTap: onBrandTap),
              ],
              const SizedBox(height: 28),
              const _SectionHeader(
                title: 'Featured picks',
                subtitle:
                    'Chosen favorites with timeless styling and everyday shine.',
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.56,
                ),
                itemCount: data.featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = data.featuredProducts[index];
                  return StoreProductCard(
                    product: product,
                    currencySymbol: currency,
                    showProductImage: showProductImages,
                    onAddToCart: () =>
                        context.read<CartCubit>().addItem(product.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(slug: product.slug),
                      ),
                    ),
                  );
                },
              ),
              if (data.newArrivals.isNotEmpty) ...[
                const SizedBox(height: 30),
                const _SectionHeader(
                  title: 'New arrivals',
                  subtitle: 'Fresh additions ready to join your collection.',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 378,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.newArrivals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final product = data.newArrivals[index];
                      return SizedBox(
                        width: 220,
                        child: StoreProductCard(
                          product: product,
                          currencySymbol: currency,
                          showProductImage: showProductImages,
                          onAddToCart: () =>
                              context.read<CartCubit>().addItem(product.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(slug: product.slug),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FallbackHero extends StatelessWidget {
  const _FallbackHero({required this.storeName});

  final String storeName;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signature collection',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: tokens.onHeroMuted),
          ),
          const SizedBox(height: 10),
          Text(
            storeName,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: tokens.onHero),
          ),
          const SizedBox(height: 12),
          Text(
            'Discover signature pieces, timeless gifts, and new arrivals curated for everyday elegance.',
            style: TextStyle(color: tokens.onHero, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _HomeSliderCarousel extends StatefulWidget {
  const _HomeSliderCarousel({required this.storeName, required this.sliders});

  final String storeName;
  final List<StoreSlider> sliders;

  @override
  State<_HomeSliderCarousel> createState() => _HomeSliderCarouselState();
}

class _HomeSliderCarouselState extends State<_HomeSliderCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.94);
    if (widget.sliders.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted || !_pageController.hasClients) {
          return;
        }

        final nextPage = (_currentPage + 1) % widget.sliders.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.sliders.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slider = widget.sliders[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _SliderCard(storeName: widget.storeName, slider: slider),
              );
            },
          ),
        ),
        if (widget.sliders.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.sliders.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? tokens.indicatorActive
                      : tokens.indicatorInactive,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SliderCard extends StatelessWidget {
  const _SliderCard({required this.storeName, required this.slider});

  final String storeName;
  final StoreSlider slider;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final imageUrl = slider.preferredImageUrl;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: tokens.heroGradientStart,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tokens.heroOverlayStrong, tokens.heroOverlaySoft],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.onHero.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    storeName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: tokens.onHero),
                  ),
                ),
                const Spacer(),
                Text(
                  (slider.title ?? '').isNotEmpty
                      ? slider.title!
                      : 'New season highlights',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: tokens.onHero,
                    height: 1,
                  ),
                ),
                if ((slider.subtitle ?? '').isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    slider.subtitle!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: tokens.onHeroMuted),
                  ),
                ],
                if ((slider.link ?? '').isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.onHero,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Explore collection',
                      style: TextStyle(
                        color: tokens.heroGradientStart,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.categories, this.onCategoryTap});

  final List<StoreCategory> categories;
  final ValueChanged<StoreCategory>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(
            category: category,
            onTap: onCategoryTap == null
                ? null
                : () => onCategoryTap!(category),
          );
        },
      ),
    );
  }
}

class _BrandRail extends StatelessWidget {
  const _BrandRail({required this.brands, this.onBrandTap});

  final List<StoreBrand> brands;
  final ValueChanged<StoreBrand>? onBrandTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return _BrandCard(
            brand: brand,
            onTap: onBrandTap == null ? null : () => onBrandTap!(brand),
          );
        },
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.brand, this.onTap});

  final StoreBrand brand;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    return Material(
      color: Theme.of(context).cardTheme.color ?? Colors.white,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tokens.softSurface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: brand.imageUrl != null && brand.imageUrl!.isNotEmpty
                      ? Image.network(
                          brand.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.storefront_outlined),
                        )
                      : Icon(
                          Icons.diamond_outlined,
                          color: tokens.heroGradientStart,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  brand.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, this.onTap});

  final StoreCategory category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageSmUrl ?? category.imageUrl;
    final tone = _parseCategoryColor(
      category.color,
      fallback: context.storeTheme.categoryFallback,
    );
    final tokens = context.storeTheme;

    return Material(
      color: tone,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 146,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tokens.heroOverlaySoft.withValues(alpha: 0.55),
                      tokens.heroOverlayStrong.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (category.children.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.onHero.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${category.children.length} collections',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: tokens.onHero),
                        ),
                      ),
                    const Spacer(),
                    Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: tokens.onHero),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.productsCount} pieces',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: tokens.onHeroMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _parseCategoryColor(String? colorValue, {required Color fallback}) {
  if (colorValue == null || colorValue.isEmpty) {
    return fallback;
  }

  final normalized = colorValue.replaceAll('#', '');
  if (normalized.length != 6) {
    return fallback;
  }

  final value = int.tryParse('FF$normalized', radix: 16);
  if (value == null) {
    return fallback;
  }

  return Color(value);
}
