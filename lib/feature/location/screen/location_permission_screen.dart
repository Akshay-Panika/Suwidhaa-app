import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import '../../../router/app_routes.dart';
import '../controller/location_controller.dart';

class LocationPermissionScreen extends StatelessWidget {
  LocationPermissionScreen({super.key});

  final _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- TOP ILLUSTRATION ----------
              Container(
                width: double.infinity,
                height: h * 0.32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: w * 0.62,
                      height: w * 0.62,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.12),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.46,
                      height: w * 0.46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.20),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: w * 0.30,
                      height: w * 0.30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.10),
                      ),
                    ),
                    Container(
                      width: w * 0.20,
                      height: w * 0.20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: w * 0.09,
                      ),
                    ),
                    Positioned(
                      top: h * 0.03,
                      left: w * 0.05,
                      child: _chip("🏫 School", const Color(0xFF0891B2)),
                    ),
                    Positioned(
                      top: h * 0.04,
                      right: w * 0.04,
                      child: _chip("📖 College", const Color(0xFF7C3AED)),
                    ),
                    Positioned(
                      bottom: h * 0.03,
                      left: w * 0.04,
                      child: _chip("🎬 OTT", const Color(0xFFDC2626)),
                    ),
                    Positioned(
                      bottom: h * 0.02,
                      right: w * 0.05,
                      child: _chip("🛒 E-commerce", Colors.blue),
                    ),
                  ],
                ),
              ),

              // ---------- MIDDLE CONTENT ----------
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h * 0.02),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: w * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Suwidhaa Services",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: h * 0.01),

                        const Text(
                          "All Services\nIn One App",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),

                        SizedBox(height: h * 0.01),

                        const Text(
                          "Find schools, colleges, OTT, e-commerce, IT and NGO services around you.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        _featureTile(
                          context,
                          Icons.groups_2_rounded,
                          "Find nearby services",
                          "School, College, OTT, IT & more",
                          const Color(0xFF0891B2),
                        ),
                        SizedBox(height: h * 0.012),
                        _featureTile(
                          context,
                          Icons.auto_awesome_rounded,
                          "Personalised for your area",
                          "See trending services in your city",
                          const Color(0xFF7C3AED),
                        ),
                        SizedBox(height: h * 0.012),
                        _featureTile(
                          context,
                          Icons.shield_outlined,
                          "Your privacy is safe",
                          "Exact location is never shared",
                          Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ---------- BOTTOM BUTTONS ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.06,
                      child: ElevatedButton(
                        onPressed: _locationController.isLoading.value
                            ? null
                            : () async {
                          if (_locationController.isLoading.value) return;

                          // 1. Request permission & fetch location
                          await _locationController.requestLocationPermission();

                          // 2. Check if location fetched
                          if (_locationController.tempLat.value != 0.0 &&
                              _locationController.tempLng.value != 0.0) {
                            await _locationController.confirmLocation();
                            Get.offAllNamed(AppRoutes.dashboard);
                            print("Addess: ${_locationController.address}");
                          } else {
                            FlutterToast.error("Please allow location to continue");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _locationController.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Allow Location Access",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.06,
                      child: OutlinedButton(
                        onPressed: () =>
                            Get.offAllNamed(AppRoutes.dashboard),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Skip for now",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  // -------- Helper: Floating chip --------
  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.20), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // -------- Helper: Feature tile --------
  Widget _featureTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      ) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: w * 0.11,
          height: w * 0.11,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: w * 0.055),
        ),
        SizedBox(width: w * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}