import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/core/widgets/store_back_button.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/order_detail_cubit.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/order_detail_state.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderDetailCubit(context.read<StoreRepository>())..load(orderId),
      child: const _OrderDetailView(),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      builder: (context, state) {
        if (state.status == OrderDetailStatus.loading ||
            state.status == OrderDetailStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == OrderDetailStatus.failure || state.order == null) {
          return Scaffold(
            appBar: AppBar(
              leading: const StoreBackButton(),
              title: const Text('Order details'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage ?? 'Unable to load this order right now.',
                ),
              ),
            ),
          );
        }

        final order = state.order!;
        final statusColor = _parseHexColor(
          order.statusColor,
          fallback: context.storeTheme.heroGradientStart,
        );
        final tokens = context.storeTheme;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leadingWidth: 64,
                leading: const StoreBackButton(onHero: true),
                pinned: true,
                expandedHeight: 210,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          tokens.heroGradientStart,
                          tokens.heroGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: tokens.onHero.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Order details',
                                style: TextStyle(
                                  color: tokens.onHero,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              order.reference,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(color: tokens.onHero),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _StatusBadge(
                                  label: order.statusName ?? 'Pending',
                                  color: statusColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _formatDate(order.orderAt ?? order.createdAt),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: tokens.onHeroMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrderSummaryCard(order: order),
                      const SizedBox(height: 18),
                      _SectionTitle(
                        title: 'Items',
                        subtitle:
                            '${order.items.length} piece${order.items.length == 1 ? '' : 's'} in this order',
                      ),
                      const SizedBox(height: 12),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _OrderItemCard(item: item),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (order.address != null) ...[
                        _SectionTitle(
                          title: 'Delivery',
                          subtitle: 'Shipping destination and contact details',
                        ),
                        const SizedBox(height: 12),
                        _AddressCard(address: order.address!),
                        const SizedBox(height: 18),
                      ],
                      _SectionTitle(
                        title: 'Payment summary',
                        subtitle: order.paymentTypeName ?? 'Payment details',
                      ),
                      const SizedBox(height: 12),
                      _TotalsCard(order: order),
                      if ((order.note ?? '').isNotEmpty) ...[
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Order note',
                          subtitle: 'Saved message for this order',
                        ),
                        const SizedBox(height: 12),
                        _NoteCard(note: order.note!),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final cards = <({String label, String value, Color tone})>[
      (label: 'Total', value: _money(order.total), tone: tokens.softSurface),
      (
        label: 'Paid',
        value: _money(order.paid),
        tone: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                Expanded(
                  child: _MetricTile(
                    label: cards[i].label,
                    value: cards[i].value,
                    tone: cards[i].tone,
                  ),
                ),
                if (i < cards.length - 1) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final StoreOrderItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final imageUrl = item.product.imageUrl;
    final productMeta =
        item.product.brandName ?? item.product.categoryName ?? 'Store item';
    final secondaryMeta = item.product.subTitle ?? item.product.note;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: tokens.heroGradientStart.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: compact ? 82 : 92,
                      height: compact ? 92 : 102,
                      color: tokens.imagePlaceholder,
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.photo_outlined),
                            )
                          : const Icon(Icons.photo_outlined),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.softSurface,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            productMeta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: tokens.heroGradientEnd,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.product.title,
                          maxLines: compact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.18,
                              ),
                        ),
                        if (secondaryMeta?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Text(
                            secondaryMeta!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _OrderItemFact(
                    icon: Icons.layers_outlined,
                    label: 'Quantity',
                    value: '${item.qty}',
                  ),
                  _OrderItemFact(
                    icon: Icons.sell_outlined,
                    label: 'Unit price',
                    value: _money(item.price),
                  ),
                  _OrderItemFact(
                    icon: Icons.receipt_long_outlined,
                    label: 'Line total',
                    value: _money(item.total),
                    highlighted: true,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderItemFact extends StatelessWidget {
  const _OrderItemFact({
    required this.icon,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final backgroundColor = highlighted
        ? tokens.heroGradientStart
        : tokens.softSurfaceAlt;
    final iconColor = highlighted ? tokens.onHero : tokens.heroGradientEnd;
    final labelColor = highlighted
        ? tokens.onHeroMuted
        : tokens.heroGradientEnd;
    final valueColor = highlighted
        ? tokens.onHero
        : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Container(
      constraints: const BoxConstraints(minWidth: 110, maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: highlighted
                  ? tokens.onHero.withValues(alpha: 0.12)
                  : Theme.of(context).cardTheme.color ?? Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final StoreAddress address;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: tokens.heroGradientStart.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 380;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tokens.softSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: tokens.heroGradientStart,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Saved delivery destination',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: tokens.heroGradientEnd,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: tokens.softSurfaceAlt,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  address.formattedAddress,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _DetailMetaChip(
                    icon: Icons.call_outlined,
                    label: address.mobile,
                    maxWidth: compact ? 240 : 280,
                  ),
                  if ((address.note ?? '').isNotEmpty)
                    _DetailMetaChip(
                      icon: Icons.sticky_note_2_outlined,
                      label: address.note!,
                      maxWidth: compact ? 260 : 320,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailMetaChip extends StatelessWidget {
  const _DetailMetaChip({
    required this.icon,
    required this.label,
    required this.maxWidth,
  });

  final IconData icon;
  final String label;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: tokens.softSurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: tokens.heroGradientEnd),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: order.subtotal),
          if (order.discount > 0)
            _SummaryRow(label: 'Discount', value: -order.discount),
          _SummaryRow(label: 'Shipping', value: order.shippingRate),
          if (order.handlingFee > 0)
            _SummaryRow(label: 'Handling', value: order.handlingFee),
          _SummaryRow(label: 'VAT', value: order.vat),
          const Divider(height: 28),
          _SummaryRow(label: 'Total', value: order.total, emphasize: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(_money(value), style: style),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        note,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          shadows: color == tokens.onHero ? null : const <Shadow>[],
        ),
      ),
    );
  }
}

String _money(double value) => 'EUR ${value.toStringAsFixed(2)}';

String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) {
    return 'Recently placed';
  }

  final date = DateTime.tryParse(raw)?.toLocal();
  if (date == null) {
    return raw;
  }

  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

Color _parseHexColor(String? raw, {required Color fallback}) {
  if (raw == null || raw.isEmpty) {
    return fallback;
  }

  final normalized = raw.replaceAll('#', '');
  if (normalized.length != 6) {
    return fallback;
  }

  final value = int.tryParse('FF$normalized', radix: 16);
  if (value == null) {
    return fallback;
  }

  return Color(value);
}
