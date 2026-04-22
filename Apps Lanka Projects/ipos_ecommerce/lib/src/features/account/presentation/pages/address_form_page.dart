import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_store_app/src/core/widgets/store_back_button.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';
import 'package:flutter_store_app/src/features/checkout/presentation/pages/address_picker_page.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key, this.initialAddress});

  final StoreAddress? initialAddress;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressController;
  late final TextEditingController _zipController;
  late final TextEditingController _noteController;
  AddressPlaceDetails? _selectedPlace;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAddress;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _mobileController = TextEditingController(text: initial?.mobile ?? '');
    _addressLine1Controller = TextEditingController(
      text: initial?.addressLine1 ?? '',
    );
    _addressController = TextEditingController(
      text: initial?.formattedAddress.isNotEmpty == true
          ? initial!.formattedAddress
          : (initial?.address ?? ''),
    );
    _zipController = TextEditingController(text: initial?.zip ?? '');
    _noteController = TextEditingController(text: initial?.note ?? '');

    if (initial != null &&
        initial.latitude != null &&
        initial.longitude != null) {
      _selectedPlace = AddressPlaceDetails(
        placeId: 'saved-${initial.id}',
        name: initial.name,
        formattedAddress: initial.formattedAddress,
        latitude: initial.latitude!,
        longitude: initial.longitude!,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressLine1Controller.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialAddress != null;

    return Scaffold(
      appBar: AppBar(
        leading: const StoreBackButton(),
        title: Text(isEditing ? 'Edit address' : 'Add address'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Label'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Mobile'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressLine1Controller,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Apartment, suite, or floor',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _addressController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Pick an address from the map',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickAddressOnMap,
            icon: const Icon(Icons.map_outlined),
            label: Text(
              _selectedPlace == null ? 'Pick on map' : 'Update map location',
            ),
          ),
          if (_selectedPlace != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE7),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedPlace!.formattedAddress,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_selectedPlace!.latitude.toStringAsFixed(6)}, ${_selectedPlace!.longitude.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _zipController,
            decoration: const InputDecoration(labelText: 'ZIP'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _submit,
            child: Text(isEditing ? 'Save changes' : 'Save address'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAddressOnMap() async {
    final repository = context.read<StoreRepository>();
    final place = await Navigator.of(context).push<AddressPlaceDetails>(
      MaterialPageRoute(
        builder: (_) => AddressPickerPage(
          repository: repository,
          initialPlace: _selectedPlace,
        ),
      ),
    );

    if (place == null || !mounted) {
      return;
    }

    setState(() {
      _selectedPlace = place;
      _addressController.text = place.formattedAddress;
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || mobile.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Name, mobile, and address are required.'),
          ),
        );
      return;
    }

    Navigator.of(context).pop(
      AddressFormResult(
        name: name,
        mobile: mobile,
        address: address,
        addressLine1: _addressLine1Controller.text.trim(),
        zip: _zipController.text.trim(),
        note: _noteController.text.trim(),
        latitude: _selectedPlace?.latitude ?? widget.initialAddress?.latitude,
        longitude:
            _selectedPlace?.longitude ?? widget.initialAddress?.longitude,
      ),
    );
  }
}

class AddressFormResult {
  const AddressFormResult({
    required this.name,
    required this.mobile,
    required this.address,
    required this.addressLine1,
    required this.zip,
    required this.note,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String mobile;
  final String address;
  final String addressLine1;
  final String zip;
  final String note;
  final double? latitude;
  final double? longitude;
}
