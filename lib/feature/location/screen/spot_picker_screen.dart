import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/app_color.dart';
import '../controller/location_controller.dart';

class SpotPickerScreen extends StatefulWidget {
  const SpotPickerScreen({super.key});

  @override
  State<SpotPickerScreen> createState() => _SpotPickerScreenState();
}

class _SpotPickerScreenState extends State<SpotPickerScreen> {
  final LocationController locationController = Get.find<LocationController>();
  late final MapController mapController;

  LatLng? selected;
  LatLng? current;
  bool loading = false;
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    locationController.resetTemp();
    selected = _initialLocation();

    // 🔥 Fetch address for initial location
    _fetchAddress(selected!.latitude, selected!.longitude);

    _loadCurrent();
  }

  LatLng _initialLocation() {
    if (locationController.tempLat.value != 0 &&
        locationController.tempLng.value != 0) {
      return LatLng(
        locationController.tempLat.value,
        locationController.tempLng.value,
      );
    }
    return const LatLng(20.5937, 78.9629);
  }

  Future<void> _loadCurrent() async {
    final pos = await locationController.getCurrentLatLng();
    if (pos != null && mounted) {
      setState(() => current = pos);
    }
  }

  Future<void> goCurrent() async {
    setState(() => loading = true);
    final pos = await locationController.getCurrentLatLng();

    if (pos != null) {
      current = pos;
      mapController.move(pos, 16);
      selected = pos;

      // 🔥 Fetch address
      await _fetchAddress(pos.latitude, pos.longitude);

      if (mounted) setState(() {});
    }

    if (mounted) setState(() => loading = false);
  }

  // 🔥 Single source for address fetching
  Future<void> _fetchAddress(double lat, double lng) async {
    if (_isFetchingAddress) return;
    _isFetchingAddress = true;

    try {
      await locationController.setTempLocation(lat, lng);
    } finally {
      _isFetchingAddress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set Your Location",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: selected!,
              initialZoom: 15,
              // 🔥 Only update selected — don't fetch address here
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  selected = position.center;
                }
              },
              // 🔥 Fetch address only when map STOPS
              onMapEvent: (event) {
                if (event is MapEventMoveEnd) {
                  if (selected != null) {
                    _fetchAddress(
                      selected!.latitude,
                      selected!.longitude,
                    );
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
              ),
              if (current != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: current!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Fixed Center Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Select your area",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.location_on, size: 45, color: AppColors.primary),
                ],
              ),
            ),
          ),


          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      elevation: 4,
                      onPressed: loading ? null : goCurrent,
                      child: loading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                          : Icon(Icons.my_location, color: AppColors.primary),
                    ),
                  ),
                  // Address Display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Location",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(() {
                              final address =
                              locationController.tempAddress.value.isEmpty
                                  ? "Fetching location..."
                                  : locationController.tempAddress.value;
                              return Text(
                                address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 🔥 Save final location (lat, lng, id, address)
                        await locationController.confirmLocation();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}