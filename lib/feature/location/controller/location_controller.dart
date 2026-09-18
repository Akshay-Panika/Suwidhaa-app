import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String area;
  final String city;
  final String state;
  final String address;
  final String id;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.city,
    required this.state,
    required this.address,
    required this.id,
  });

  bool get isEmpty => latitude == 0.0 && longitude == 0.0;
}

class LocationController extends GetxController {
  static LocationController get to => Get.find();

  // FINAL SAVED
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final area = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final address = ''.obs;
  final locationId = ''.obs;

  // TEMP (MAP PREVIEW)
  final tempLat = 0.0.obs;
  final tempLng = 0.0.obs;
  final tempArea = ''.obs;
  final tempCity = ''.obs;
  final tempState = ''.obs;
  final tempAddress = ''.obs;
  final tempLocationId = ''.obs;

  final isLoading = false.obs;

  static const _kLat = 'loc_lat';
  static const _kLng = 'loc_lng';
  static const _kArea = 'loc_area';
  static const _kCity = 'loc_city';
  static const _kState = 'loc_state';
  static const _kAddress = 'loc_address';
  static const _kId = 'loc_id';

  @override
  void onInit() {
    super.onInit();
    loadSaved();
  }

  void resetTemp() {
    tempLat.value = latitude.value;
    tempLng.value = longitude.value;
    tempArea.value = area.value;
    tempCity.value = city.value;
    tempState.value = state.value;
    tempAddress.value = address.value;
    tempLocationId.value = locationId.value;
  }

  /// Generate a unique ID for this location entry
  String _generateLocationId() {
    return 'loc_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<LatLng?> getCurrentLatLng() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint("GPS error: $e");
      return null;
    }
  }

  Future<void> requestLocationPermission() async {
    isLoading.value = true;

    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      if (permission == LocationPermission.denied) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await setTempLocation(pos.latitude, pos.longitude);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setTempLocation(double lat, double lng) async {
    tempLat.value = lat;
    tempLng.value = lng;

    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;

      tempArea.value = p.subLocality ?? '';
      tempCity.value = p.locality ?? '';
      tempState.value = p.administrativeArea ?? '';

      // Build full address string
      final parts = [
        p.name,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.postalCode,
        p.country,
      ].where((e) => e != null && e.isNotEmpty).toList();

      tempAddress.value = parts.join(', ');

      // Generate ID if not present
      if (tempLocationId.value.isEmpty) {
        tempLocationId.value = _generateLocationId();
      }
    }
  }

  Future<void> confirmLocation() async {
    latitude.value = tempLat.value;
    longitude.value = tempLng.value;
    area.value = tempArea.value;
    city.value = tempCity.value;
    state.value = tempState.value;
    address.value = tempAddress.value;
    locationId.value = tempLocationId.value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_kLat, latitude.value);
    await prefs.setDouble(_kLng, longitude.value);
    await prefs.setString(_kArea, area.value);
    await prefs.setString(_kCity, city.value);
    await prefs.setString(_kState, state.value);
    await prefs.setString(_kAddress, address.value);
    await prefs.setString(_kId, locationId.value);
  }

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();

    latitude.value = prefs.getDouble(_kLat) ?? 0.0;
    longitude.value = prefs.getDouble(_kLng) ?? 0.0;
    area.value = prefs.getString(_kArea) ?? '';
    city.value = prefs.getString(_kCity) ?? '';
    state.value = prefs.getString(_kState) ?? '';
    address.value = prefs.getString(_kAddress) ?? '';
    locationId.value = prefs.getString(_kId) ?? '';

    // 🔥 Sync temp with saved
    resetTemp();
  }

  bool get hasLocation =>
      latitude.value != 0.0 && longitude.value != 0.0;

  /// Get full location data as object
  LocationData? getLocationData() {
    if (!hasLocation) return null;
    return LocationData(
      latitude: latitude.value,
      longitude: longitude.value,
      area: area.value,
      city: city.value,
      state: state.value,
      address: address.value,
      id: locationId.value,
    );
  }

  /// Clear saved location
  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLat);
    await prefs.remove(_kLng);
    await prefs.remove(_kArea);
    await prefs.remove(_kCity);
    await prefs.remove(_kState);
    await prefs.remove(_kAddress);
    await prefs.remove(_kId);

    latitude.value = 0.0;
    longitude.value = 0.0;
    area.value = '';
    city.value = '';
    state.value = '';
    address.value = '';
    locationId.value = '';

    resetTemp();
  }
}