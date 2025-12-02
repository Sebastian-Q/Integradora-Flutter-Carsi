import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sigaut_frontend/features/others/view/widgets/form_input_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

class MapAddressPicker extends StatefulWidget {
  final String initialAddress;
  final Function(String address) onAddressSelected;

  const MapAddressPicker({
    super.key,
    required this.initialAddress,
    required this.onAddressSelected,
  });

  @override
  State<MapAddressPicker> createState() => _MapAddressPickerState();
}

class _MapAddressPickerState extends State<MapAddressPicker> {
  late TextEditingController addressController;

  GoogleMapController? _mapController;
  LatLng _selectedPosition = const LatLng(19.4326, -99.1332); // CDMX por defecto

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.initialAddress);
  }

  Future<void> _moveMapToAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _selectedPosition = LatLng(loc.latitude, loc.longitude);

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedPosition, 16),
        );
      }
    } catch (_) {}
  }

  Future<void> _setAddressFromMap(LatLng pos) async {
    _selectedPosition = pos;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String text =
            "${place.street}, ${place.locality}, ${place.country}";
        addressController.text = text;
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FormInputWidget(
          title: "Dirección",
          iconSuffix: const Icon(Icons.location_on_outlined),
          bottomPadding: 16,
          onChange: (value) {
            if (value.length > 5) {
              _moveMapToAddress(value);
            }
          },
        ),
        SizedBox(
          height: 350,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedPosition,
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (pos) async {
              await _setAddressFromMap(pos);
              setState(() {});
            },
            markers: {
              Marker(
                markerId: const MarkerId("selected"),
                position: _selectedPosition,
              ),
            },
          ),
        ),
        customSizeHeight
      ],
    );
  }
}
