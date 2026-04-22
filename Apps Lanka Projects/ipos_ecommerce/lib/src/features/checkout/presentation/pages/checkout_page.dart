import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/widgets/store_back_button.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/account/presentation/pages/address_form_page.dart';
import 'package:flutter_store_app/src/features/account/presentation/cubit/account_cubit.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    context.read<CheckoutCubit>().loadSummary();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.success &&
            state.placedOrder != null) {
          context.read<AccountCubit>().refresh();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Order ${state.placedOrder!.reference} placed successfully.',
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        final summary = state.summary;
        final selectedAddress = summary?.addresses
            .cast<StoreAddress?>()
            .firstWhere(
              (address) => address?.id == state.selectedAddressId,
              orElse: () => null,
            );

        return Scaffold(
          appBar: AppBar(
            leading: const StoreBackButton(),
            title: const Text('Checkout'),
          ),
          body: summary == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    Text(
                      'Delivery address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    if (summary.addresses.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('No saved address yet.'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () =>
                                    _showCreateAddressSheet(context),
                                child: const Text('Add address'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      _SelectedAddressCard(
                        address: selectedAddress ?? summary.addresses.first,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showAddressSelector(
                                context,
                                summary.addresses,
                                state.selectedAddressId,
                              ),
                              icon: const Icon(Icons.swap_horiz_rounded),
                              label: const Text('Change address'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showCreateAddressSheet(context),
                              icon: const Icon(Icons.add_location_alt_outlined),
                              label: const Text('Add new'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Payment method',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...summary.paymentMethods.map(
                      (method) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _PaymentMethodCard(
                          method: method,
                          selected: state.paymentMethod == method.code,
                          onTap: () => context
                              .read<CheckoutCubit>()
                              .setPaymentMethod(method.code),
                        ),
                      ),
                    ),
                    if (state.paymentMethod == 'stripe') ...[
                      const SizedBox(height: 8),
                      Card(
                        color: const Color(0xFFF8F3EA),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stripe preparation',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.stripePaymentIntent == null
                                    ? 'Tap the button below to prepare your secure payment before confirmation.'
                                    : 'Payment is ready to confirm. Reference `${state.stripePaymentIntent!.paymentIntentId}` is prepared for the next checkout step.',
                              ),
                              if (state.stripePaymentIntent != null) ...[
                                const SizedBox(height: 12),
                                _CheckoutRow(
                                  label: 'Amount',
                                  value: state.stripePaymentIntent!.amount,
                                  currency: summary.currencySymbol,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Currency: ${state.stripePaymentIntent!.currency.toUpperCase()}',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Publishable key: ${_maskValue(state.stripePaymentIntent!.publishableKey)}',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    TextField(
                      controller: _noteController,
                      minLines: 2,
                      maxLines: 4,
                      onChanged: context.read<CheckoutCubit>().setNote,
                      decoration: const InputDecoration(
                        labelText: 'Order note',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            _CheckoutRow(
                              label: 'Subtotal',
                              value: summary.totals.subtotal,
                              currency: summary.currencySymbol,
                            ),
                            _CheckoutRow(
                              label: 'Shipping',
                              value: summary.totals.shipping,
                              currency: summary.currencySymbol,
                            ),
                            _CheckoutRow(
                              label: 'VAT',
                              value: summary.totals.vat,
                              currency: summary.currencySymbol,
                            ),
                            const Divider(height: 28),
                            _CheckoutRow(
                              label: 'Total',
                              value: summary.totals.total,
                              currency: summary.currencySymbol,
                              emphasize: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.status == CheckoutStatus.placing ||
                                state.status == CheckoutStatus.preparingPayment
                            ? null
                            : () {
                                if (state.paymentMethod == 'stripe') {
                                  context
                                      .read<CheckoutCubit>()
                                      .prepareStripePayment();
                                  return;
                                }

                                context.read<CheckoutCubit>().placeOrder();
                              },
                        child: Text(_primaryActionLabel(state)),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _primaryActionLabel(CheckoutState state) {
    if (state.status == CheckoutStatus.preparingPayment) {
      return 'Preparing Stripe payment...';
    }

    if (state.status == CheckoutStatus.placing) {
      return 'Placing order...';
    }

    if (state.paymentMethod == 'stripe') {
      return state.stripePaymentIntent == null
          ? 'Prepare Stripe payment'
          : 'Refresh Stripe payment';
    }

    return 'Place order';
  }

  String _maskValue(String value) {
    if (value.length <= 12) {
      return value;
    }

    return '${value.substring(0, 8)}...${value.substring(value.length - 4)}';
  }

  Future<void> _showAddressSelector(
    BuildContext context,
    List<StoreAddress> addresses,
    int? selectedAddressId,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select delivery address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose where you want this order delivered.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final selected = selectedAddressId == address.id;

                      return _AddressChoiceCard(
                        address: address,
                        selected: selected,
                        onTap: () {
                          context.read<CheckoutCubit>().selectAddress(
                            address.id,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCreateAddressSheet(BuildContext context) async {
    final accountCubit = context.read<AccountCubit>();
    final checkoutCubit = context.read<CheckoutCubit>();
    final result = await Navigator.of(context).push<AddressFormResult>(
      MaterialPageRoute(builder: (_) => const AddressFormPage()),
    );

    if (result == null) {
      return;
    }

    final createdAddress = await accountCubit.createAddress(
      name: result.name,
      mobile: result.mobile,
      address: result.address,
      addressLine1: result.addressLine1,
      zip: result.zip,
      latitude: result.latitude,
      longitude: result.longitude,
      note: result.note,
    );

    await checkoutCubit.loadSummary();
    if (createdAddress != null) {
      checkoutCubit.selectAddress(createdAddress.id);
    }
  }
}

class _CheckoutRow extends StatelessWidget {
  const _CheckoutRow({
    required this.label,
    required this.value,
    required this.currency,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final String currency;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text('$currency${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}

class _SelectedAddressCard extends StatelessWidget {
  const _SelectedAddressCard({required this.address});

  final StoreAddress address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF5ECDD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1F4F46),
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
                    fontWeight: FontWeight.w800,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressChoiceCard extends StatelessWidget {
  const _AddressChoiceCard({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final StoreAddress address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF1F4F46) : Colors.white,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.location_on_outlined,
                color: selected ? Colors.white : const Color(0xFF1F4F46),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selected ? Colors.white : null,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address.formattedAddress,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.88)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      address.mobile,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.82)
                            : null,
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

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethodOption method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF1F4F46) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.16)
                      : const Color(0xFFF5ECDD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  method.code == 'stripe'
                      ? Icons.credit_card_rounded
                      : Icons.payments_outlined,
                  color: selected ? Colors.white : const Color(0xFF1F4F46),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selected ? Colors.white : null,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (method.code == 'stripe') ...[
                      const SizedBox(height: 4),
                      Text(
                        'Pay securely with Stripe.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected
                              ? Colors.white.withValues(alpha: 0.84)
                              : null,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? Colors.white : const Color(0xFF8A8178),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
