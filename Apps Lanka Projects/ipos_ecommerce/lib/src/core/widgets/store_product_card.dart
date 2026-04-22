import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';

class StoreProductCard extends StatelessWidget {
  const StoreProductCard({
    super.key,
    required this.product,
    required this.currencySymbol,
    this.showProductImage = true,
    this.onAddToCart,
    this.onTap,
  });

  final StoreProduct product;
  final String currencySymbol;
  final bool showProductImage;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.storeTheme;
    final canAddToCart = product.isInStock && onAddToCart != null;
    final primaryImageUrl = product.imageUrl?.isNotEmpty == true
        ? product.imageUrl
        : (product.imageUrls.isNotEmpty ? product.imageUrls.first : null);
    final hasImageAsset = primaryImageUrl?.isNotEmpty == true;
    final displaysImage = showProductImage && hasImageAsset;
    final reservesImageArea = showProductImage;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactHeight = constraints.maxHeight < 320;
          final veryCompactHeight = constraints.maxHeight < 292;
          final compactTitleLines = reservesImageArea
              ? (veryCompactHeight ? 1 : 2)
              : (compactHeight ? 3 : 4);
          final compactBrandLines = reservesImageArea ? 1 : 2;

          return InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(compactHeight ? 12 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reservesImageArea) ...[
                    Expanded(
                      flex: displaysImage ? (compactHeight ? 7 : 8) : 4,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: double.infinity,
                              color: tokens.imagePlaceholder,
                              child: displaysImage
                                  ? Image.network(
                                      primaryImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const _NoImageState(),
                                    )
                                  : const _NoImageState(),
                            ),
                          ),
                          if (product.countdownEndsAt != null &&
                              product.countdownEndsAt!.isNotEmpty)
                            Positioned(
                              left: 10,
                              top: 10,
                              child: _OfferCountdownBadge(
                                endsAt: product.countdownEndsAt!,
                              ),
                            ),
                          if (product.stock > 0 && product.stock <= 5)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: tokens.onHero.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Only ${product.stock.toInt()} left',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: tokens.danger,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: compactHeight ? 10 : 14),
                  ],
                  Expanded(
                    flex: reservesImageArea ? (displaysImage ? 5 : 9) : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: compactTitleLines,
                          overflow: TextOverflow.ellipsis,
                          style:
                              (reservesImageArea
                                      ? theme.textTheme.titleMedium
                                      : theme.textTheme.titleLarge)
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                        ),
                        SizedBox(height: compactHeight ? 2 : 4),
                        Text(
                          product.brandName ??
                              product.categoryName ??
                              'Store item',
                          maxLines: compactBrandLines,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (!reservesImageArea &&
                            !compactHeight &&
                            product.subTitle?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Text(
                            product.subTitle!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.35,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$currencySymbol${product.effectivePrice.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  if (product.hasDiscount &&
                                      !veryCompactHeight) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      '$currencySymbol${product.comparePrice!.toStringAsFixed(2)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: theme.hintColor,
                                          ),
                                    ),
                                  ],
                                  if (product.isInStock && !compactHeight) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      'Ready to add',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: tokens.heroGradientStart,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: product.isInStock
                                  ? 'Add to bag'
                                  : 'Out of stock',
                              child: InkWell(
                                onTap: canAddToCart ? onAddToCart : null,
                                borderRadius: BorderRadius.circular(16),
                                child: Ink(
                                  width: compactHeight ? 40 : 44,
                                  height: compactHeight ? 40 : 44,
                                  decoration: BoxDecoration(
                                    color: product.isInStock
                                        ? tokens.heroGradientStart
                                        : tokens.softSurface,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    product.isInStock
                                        ? Icons.add_shopping_cart_rounded
                                        : Icons.remove_shopping_cart_outlined,
                                    color: product.isInStock
                                        ? tokens.onHero
                                        : theme.hintColor,
                                    size: compactHeight ? 18 : 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!product.isInStock && !veryCompactHeight) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Out of stock',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: tokens.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoImageState extends StatelessWidget {
  const _NoImageState();

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 34,
              color: tokens.heroGradientEnd,
            ),
            const SizedBox(height: 8),
            Text(
              'Preview unavailable',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: tokens.heroGradientEnd,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferCountdownBadge extends StatefulWidget {
  const _OfferCountdownBadge({required this.endsAt});

  final String endsAt;

  @override
  State<_OfferCountdownBadge> createState() => _OfferCountdownBadgeState();
}

class _OfferCountdownBadgeState extends State<_OfferCountdownBadge> {
  Timer? _timer;
  late DateTime? _endAt;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _endAt = DateTime.tryParse(widget.endsAt)?.toLocal();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_endAt == null) {
      return;
    }

    final diff = _endAt!.difference(DateTime.now());
    if (!mounted) {
      return;
    }

    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;

    if (_endAt == null || _remaining == Duration.zero) {
      return const SizedBox.shrink();
    }

    final totalHours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);
    final text = totalHours >= 24
        ? '${_remaining.inDays}d ${totalHours.remainder(24)}h left'
        : '${totalHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.heroGradientStart,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: tokens.onHero,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
