import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_store_app/src/core/widgets/store_back_button.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';
import 'package:flutter_store_app/src/features/cart/data/store_repository.dart';

class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({
    super.key,
    required this.repository,
    this.initialPlace,
  });

  final StoreRepository repository;
  final AddressPlaceDetails? initialPlace;

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  static const _defaultCenter = LatLng(6.9271, 79.8612);

  late final TextEditingController _searchController;
  late final MapController _mapController;
  Timer? _debounce;
  List<AddressSuggestion> _suggestions = const [];
  AddressPlaceDetails? _selectedPlace;
  LatLng _mapCenter = _defaultCenter;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedPlace = widget.initialPlace;
    _mapCenter = widget.initialPlace == null
        ? _defaultCenter
        : LatLng(widget.initialPlace!.latitude, widget.initialPlace!.longitude);
    _searchController = TextEditingController(
      text: widget.initialPlace?.formattedAddress ?? '',
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final query = value.trim();
      if (query.length < 3) {
        if (mounted) {
          setState(() {
            _suggestions = const [];
            _error = null;
          });
        }
        return;
      }

      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        final suggestions = await widget.repository.searchAddressSuggestions(
          input: query,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _suggestions = suggestions;
          _loading = false;
        });
      } catch (error) {
        if (!mounted) {
          return;
        }

        setState(() {
          _loading = false;
          _error = error.toString();
        });
      }
    });
  }

  Future<void> _selectSuggestion(AddressSuggestion suggestion) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final place = await widget.repository.fetchPlaceDetails(
        placeId: suggestion.placeId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedPlace = place;
        _mapCenter = LatLng(place.latitude, place.longitude);
        _loading = false;
        _suggestions = const [];
        _searchController.text = place.formattedAddress;
      });

      _mapController.move(_mapCenter, 16);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    setState(() {
      _mapCenter = camera.center;
    });
  }

  void _usePinnedLocation() {
    final place = _selectedPlace;
    final query = _searchController.text.trim();
    final baseAddress = place?.formattedAddress ?? query;
    final label = place?.name.isNotEmpty == true
        ? place!.name
        : (query.isNotEmpty ? query : 'Pinned location');
    final moved = place == null
        ? false
        : _distanceInMeters(
                LatLng(place.latitude, place.longitude),
                _mapCenter,
              ) >
              25;

    Navigator.of(context).pop(
      AddressPlaceDetails(
        placeId: place?.placeId ?? 'pinned-location',
        name: label,
        formattedAddress: baseAddress.isNotEmpty
            ? (moved ? '$baseAddress (pin adjusted)' : baseAddress)
            : 'Pinned location',
        latitude: _mapCenter.latitude,
        longitude: _mapCenter.longitude,
      ),
    );
  }

  double _distanceInMeters(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final dLat = (b.latitude - a.latitude) * math.pi / 180;
    final dLng = (b.longitude - a.longitude) * math.pi / 180;

    final haversine =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlace = _selectedPlace;
    final canConfirm =
        selectedPlace != null || _searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: const StoreBackButton(),
        title: const Text('Pick address'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search address',
              hintText: 'Street, building, or landmark',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          if (_loading) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: _suggestions
                    .map(
                      (suggestion) => ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(
                          suggestion.primaryText.isNotEmpty
                              ? suggestion.primaryText
                              : suggestion.description,
                        ),
                        subtitle: suggestion.secondaryText.isNotEmpty
                            ? Text(suggestion.secondaryText)
                            : null,
                        onTap: () => _selectSuggestion(suggestion),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Text(
            'Fine-tune on map',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Search first, then drag the map until the pin sits exactly where you want delivery.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _mapCenter,
                      initialZoom: selectedPlace == null ? 12 : 16,
                      onPositionChanged: _onPositionChanged,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'flutter_store_app',
                      ),
                    ],
                  ),
                  const IgnorePointer(
                    child: Icon(
                      Icons.location_on,
                      size: 44,
                      color: Color(0xFFB76033),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPlace?.name.isNotEmpty == true
                      ? selectedPlace!.name
                      : 'Pinned delivery point',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedPlace?.formattedAddress.isNotEmpty == true
                      ? selectedPlace!.formattedAddress
                      : (_searchController.text.trim().isNotEmpty
                            ? _searchController.text.trim()
                            : 'Move the map to position the pin.'),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_mapCenter.latitude.toStringAsFixed(6)}, ${_mapCenter.longitude.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: canConfirm ? _usePinnedLocation : null,
            child: Text(
              selectedPlace == null
                  ? 'Use pinned location'
                  : 'Confirm pinned location',
            ),
          ),
        ],
      ),
    );
  }
}
