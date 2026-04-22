import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/theme/app_theme.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/account_cubit.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/account_state.dart';
import 'package:flutter_store_app/src/features/account/presentation/pages/address_form_page.dart';
import 'package:flutter_store_app/src/features/account/presentation/pages/order_detail_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      builder: (context, state) {
        if (!state.isAuthenticated) {
          final tokens = context.storeTheme;
          final isRegisterMode = state.formMode == AccountFormMode.register;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
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
                        isRegisterMode ? 'Create your account' : 'Welcome back',
                        style: TextStyle(
                          color: tokens.onHero,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRegisterMode ? 'Join the club' : 'Your account',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(color: tokens.onHero),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRegisterMode
                          ? 'Create an account to save your addresses, track orders, and enjoy a faster checkout.'
                          : 'Sign in to access your saved addresses, order history, and a faster checkout.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: tokens.onHeroMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: const Text('Sign in'),
                    selected: !isRegisterMode,
                    onSelected: (_) => context.read<AccountCubit>().setFormMode(
                      AccountFormMode.login,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('Create account'),
                    selected: isRegisterMode,
                    onSelected: (_) => context.read<AccountCubit>().setFormMode(
                      AccountFormMode.register,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isRegisterMode) ...[
                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Full name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              if (isRegisterMode) ...[
                const SizedBox(height: 8),
                Text(
                  'Use at least 6 characters to create a secure password.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: state.status == AccountStatus.submitting
                    ? null
                    : () {
                        if (isRegisterMode) {
                          context.read<AccountCubit>().register(
                            name: _nameController.text.trim(),
                            mobile: _mobileController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                          return;
                        }

                        context.read<AccountCubit>().login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                child: Text(
                  state.status == AccountStatus.submitting
                      ? (isRegisterMode
                            ? 'Creating account...'
                            : 'Signing in...')
                      : (isRegisterMode ? 'Create account' : 'Sign in'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: _BenefitCard(
                      title: 'Fast checkout',
                      subtitle: 'Save your details for smoother repeat orders.',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _BenefitCard(
                      title: 'Order tracking',
                      subtitle:
                          'Keep your recent purchases and delivery info in one place.',
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        final user = state.user!;

        return RefreshIndicator(
          onRefresh: () => context.read<AccountCubit>().refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              _AccountHero(user: user),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Saved addresses',
                subtitle: state.addresses.isEmpty
                    ? 'Add one during checkout to speed up future orders.'
                    : 'Your saved delivery destinations.',
                actionLabel: 'Add',
                onAction: state.status == AccountStatus.submitting
                    ? null
                    : () => _openAddressForm(context),
              ),
              const SizedBox(height: 12),
              if (state.addresses.isEmpty)
                const _EmptyCard(message: 'No address saved yet.')
              else
                ...state.addresses.map(
                  (address) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AddressCard(
                      address: address,
                      onEdit: state.status == AccountStatus.submitting
                          ? null
                          : () => _openAddressForm(context, address: address),
                      onDelete: state.status == AccountStatus.submitting
                          ? null
                          : () => _deleteAddress(context, address),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Recent orders',
                subtitle: state.orders.isEmpty
                    ? 'Your completed purchases will appear here.'
                    : 'Tap any order to view the full breakdown.',
              ),
              const SizedBox(height: 12),
              if (state.orders.isEmpty)
                const _EmptyCard(message: 'No orders yet.')
              else
                ...state.orders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OrderPreviewCard(
                      order: order,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(orderId: order.id),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openAddressForm(
    BuildContext context, {
    StoreAddress? address,
  }) async {
    final result = await Navigator.of(context).push<AddressFormResult>(
      MaterialPageRoute(
        builder: (_) => AddressFormPage(initialAddress: address),
      ),
    );

    if (result == null || !context.mounted) {
      return;
    }

    final cubit = context.read<AccountCubit>();
    final savedAddress = address == null
        ? await cubit.createAddress(
            name: result.name,
            mobile: result.mobile,
            address: result.address,
            addressLine1: result.addressLine1,
            zip: result.zip,
            latitude: result.latitude,
            longitude: result.longitude,
            note: result.note,
          )
        : await cubit.updateAddress(
            addressId: address.id,
            name: result.name,
            mobile: result.mobile,
            address: result.address,
            addressLine1: result.addressLine1,
            zip: result.zip,
            latitude: result.latitude,
            longitude: result.longitude,
            note: result.note,
          );

    if (!context.mounted || savedAddress == null) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            address == null
                ? 'Address saved successfully.'
                : 'Address updated successfully.',
          ),
        ),
      );
  }

  Future<void> _deleteAddress(
    BuildContext context,
    StoreAddress address,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete address'),
          content: Text('Remove "${address.name}" from your saved addresses?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final cubit = context.read<AccountCubit>();
    await cubit.deleteAddress(address.id);

    if (!context.mounted || cubit.state.status == AccountStatus.failure) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Address deleted.')));
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({required this.user});

  final StoreUser user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: tokens.onHero.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.person_outline, color: tokens.onHero),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: tokens.onHero),
          ),
          const SizedBox(height: 8),
          Text(
            user.email,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: tokens.onHeroMuted),
          ),
          if ((user.mobile ?? '').isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              user.mobile!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.onHeroMuted.withValues(alpha: 0.92),
              ),
            ),
          ],
          const SizedBox(height: 18),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: tokens.onHero,
              side: BorderSide(color: tokens.onHero.withValues(alpha: 0.35)),
            ),
            onPressed: () => context.read<AccountCubit>().logout(),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, this.onEdit, this.onDelete});

  final StoreAddress address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address.formattedAddress,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  address.mobile,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if ((address.zip ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'ZIP ${address.zip}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if ((address.note ?? '').isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.softSurfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      address.note!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                    ),
                    if (address.latitude != null && address.longitude != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.softSurface,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Pinned map location',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderPreviewCard extends StatelessWidget {
  const _OrderPreviewCard({required this.order, required this.onTap});

  final StoreOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _parseHexColor(
      order.statusColor,
      fallback: context.storeTheme.heroGradientStart,
    );
    final orderDate = _formatDate(order.orderAt ?? order.createdAt);
    final itemCount = order.items.length;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            boxShadow: [
              BoxShadow(
                color: context.storeTheme.heroGradientStart.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  right: -16,
                  child: IgnorePointer(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.14),
                            context.storeTheme.softSurfaceAlt.withValues(
                              alpha: 0.8,
                            ),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 360;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order overview',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: context
                                                .storeTheme
                                                .heroGradientEnd,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.2,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      order.reference,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.3,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: context.storeTheme.softSurface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: context.storeTheme.heroGradientStart,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _OrderMetaChip(
                                icon: Icons.calendar_today_rounded,
                                label: orderDate,
                              ),
                              if (order.paymentTypeName?.isNotEmpty == true)
                                _OrderMetaChip(
                                  icon: Icons.payments_outlined,
                                  label: order.paymentTypeName!,
                                ),
                              _OrderMetaChip(
                                icon: Icons.shopping_bag_outlined,
                                label: itemCount == 1
                                    ? '1 item'
                                    : '$itemCount items',
                              ),
                              _StatusPill(
                                label: order.statusName ?? 'Pending',
                                color: statusColor,
                                compact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _OrderSummaryHighlight(
                            itemCount: itemCount,
                            total: order.total,
                            note: order.note,
                            compact: compact,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _PreviewMetric(
                                label: 'Paid',
                                value: 'EUR ${order.paid.toStringAsFixed(2)}',
                              ),
                              if (order.address?.name.isNotEmpty == true)
                                _PreviewMetric(
                                  label: 'Delivery',
                                  value: order.address!.name,
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
          ),
        ),
      ),
    );
  }
}

class _OrderSummaryHighlight extends StatelessWidget {
  const _OrderSummaryHighlight({
    required this.itemCount,
    required this.total,
    required this.note,
    required this.compact,
  });

  final int itemCount;
  final double total;
  final String? note;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    final detailsText = note?.isNotEmpty == true
        ? note!
        : 'Tap to view line items, delivery details, and totals.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.softSurfaceAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _OrderSummaryIcon(),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready to review',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: tokens.heroGradientEnd,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            itemCount == 1
                                ? '1 item in this order'
                                : '$itemCount items in this order',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  detailsText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 14),
                _OrderTotalTile(total: total),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _OrderSummaryIcon(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready to review',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: tokens.heroGradientEnd,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              itemCount == 1
                                  ? '1 item in this order'
                                  : '$itemCount items in this order',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              detailsText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _OrderTotalTile(total: total),
              ],
            ),
    );
  }
}

class _OrderSummaryIcon extends StatelessWidget {
  const _OrderSummaryIcon();

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.receipt_long_outlined, color: tokens.onHero),
    );
  }
}

class _OrderMetaChip extends StatelessWidget {
  const _OrderMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: tokens.softSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: tokens.heroGradientEnd),
          const SizedBox(width: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTotalTile extends StatelessWidget {
  const _OrderTotalTile({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tokens.heroGradientStart, tokens.heroGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tokens.heroGradientStart.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order total',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: tokens.onHeroMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'EUR ${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: tokens.onHero,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_rounded, size: 18, color: tokens.onHero),
        ],
      ),
    );
  }
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.storeTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: tokens.softSurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$label: $value',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    this.compact = false,
  });

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: compact ? 12 : 13,
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

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
      child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

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
