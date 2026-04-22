import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/pages/checkout_page.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter_store_app/src/features/cart/presentation/cubit/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: const [
              Text(
                'Cart requires login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text(
                'Sign in from the Account tab to save your bag and continue to checkout.',
              ),
            ],
          );
        }

        if (state.status == CartStatus.loading && state.summary.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _CartHero(itemCount: state.summary.items.length),
            const SizedBox(height: 20),
            if (state.summary.items.isEmpty) const _EmptyCartCard(),
            ...state.summary.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CartItemCard(item: item),
              ),
            ),
            if (state.summary.items.isNotEmpty) ...[
              const SizedBox(height: 8),
              _CartSummaryCard(
                subtotal: state.summary.totals.subtotal,
                shipping: state.summary.totals.shipping,
                vat: state.summary.totals.vat,
                total: state.summary.totals.total,
                itemCount: state.summary.items.length,
                onCheckout: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const CheckoutPage())),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CartHero extends StatelessWidget {
  const _CartHero({required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final itemLabel = itemCount == 1
        ? '1 piece selected'
        : '$itemCount pieces selected';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: tokens.onHero.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              itemLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: tokens.onHero,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your shopping bag',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: tokens.onHero),
          ),
          const SizedBox(height: 10),
          Text(
            itemCount == 0
                ? 'Start building a polished order with pieces you love.'
                : 'Review your selections, fine-tune quantities, and move to checkout when you are ready.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: tokens.onHeroMuted),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartCard extends StatelessWidget {
  const _EmptyCartCard();

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: tokens.softSurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: tokens.heroGradientStart,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your bag is empty',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Add pieces from Home or Shop to start building your order.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final product = item.product;
    final unitPrice = product.effectivePrice;
    final imageUrl = product.imageUrl;
    final hasDiscount = product.hasDiscount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: tokens.heroGradientStart.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 108,
                decoration: BoxDecoration(
                  color: tokens.imagePlaceholder,
                  borderRadius: BorderRadius.circular(22),
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const _CartImageFallback(),
                      )
                    : const _CartImageFallback(),
              ),
              if (product.stock > 0 && product.stock <= 5)
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.heroOverlayStrong.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Only ${product.stock.toInt()} left',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: tokens.onHero,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 220;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if ((product.brandName ?? '').isNotEmpty)
                                _TopTag(label: product.brandName!),
                              if ((product.categoryName ?? '').isNotEmpty)
                                _TopTag(label: product.categoryName!),
                            ],
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () =>
                              context.read<CartCubit>().removeItem(item.id),
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                    Text(
                      product.title,
                      maxLines: compact ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if ((product.subTitle ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.subTitle!,
                        maxLines: compact ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (compact) ...[
                      _PriceBlock(
                        unitPrice: unitPrice,
                        hasDiscount: hasDiscount,
                        comparePrice: product.comparePrice,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _LineTotalBadge(total: item.lineTotal),
                      ),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _PriceBlock(
                              unitPrice: unitPrice,
                              hasDiscount: hasDiscount,
                              comparePrice: product.comparePrice,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _LineTotalBadge(total: item.lineTotal),
                        ],
                      ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _QtyControl(item: item),
                        Text(
                          'Qty updates instantly',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({
    required this.unitPrice,
    required this.hasDiscount,
    required this.comparePrice,
  });

  final double unitPrice;
  final bool hasDiscount;
  final double? comparePrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unitPrice.toStringAsFixed(2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        if (hasDiscount && comparePrice != null)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              comparePrice!.toStringAsFixed(2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _TopTag extends StatelessWidget {
  const _TopTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.softSurfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LineTotalBadge extends StatelessWidget {
  const _LineTotalBadge({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Line total',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: tokens.onHeroMuted),
          ),
          const SizedBox(height: 2),
          Text(
            total.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: tokens.onHero,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: tokens.softSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: item.qty > 1
                ? () => context.read<CartCubit>().updateItem(
                    item.id,
                    item.qty - 1,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            '${item.qty}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: () =>
                context.read<CartCubit>().updateItem(item.id, item.qty + 1),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Material(
      color: onTap == null
          ? Theme.of(context).colorScheme.outlineVariant
          : Theme.of(context).cardTheme.color ?? Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 18,
            color: onTap == null
                ? Theme.of(context).hintColor
                : tokens.heroGradientStart,
          ),
        ),
      ),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({
    required this.subtotal,
    required this.shipping,
    required this.vat,
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  final double subtotal;
  final double shipping;
  final double vat;
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order summary',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: tokens.softSurface,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  itemCount == 1 ? '1 item' : '$itemCount items',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SummaryRow(label: 'Subtotal', value: subtotal),
          _SummaryRow(label: 'Shipping', value: shipping),
          _SummaryRow(label: 'VAT', value: vat),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated total',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tokens.onHeroMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        total.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: tokens.onHero,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: tokens.onHero),
              ],
            ),
          ),
          Text(
            'Taxes and delivery are reflected above before you place the order.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              child: const Text('Continue to checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartImageFallback extends StatelessWidget {
  const _CartImageFallback();

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      color: tokens.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(
        Icons.diamond_outlined,
        color: tokens.heroGradientStart,
        size: 30,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value.toStringAsFixed(2), style: style),
        ],
      ),
    );
  }
}
