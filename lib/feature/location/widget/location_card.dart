import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../screen/location_permission_screen.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: w * 0.02,
          horizontal: w * 0.02,
        ),
        child: Column(
          children: [
            /// Icon
            Container(
              height: w * 0.16,
              width: w * 0.16,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: w * 0.1,
                color: Colors.green,
              ),
            ),

            SizedBox(height: w * 0.03),

            /// Title
            const Text(
              "Enable Location",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: w * 0.01),

            /// Subtitle
            Text(
              "Please allow location access to find nearby people\nfor teaching and learning skills.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: w * 0.06),

            /// Button
            GestureDetector(
              onTap: () {
                Get.to(() => LocationPermissionScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: w * 0.04,
                    ),
                    SizedBox(width: w * 0.02),
                    const Text(
                      "Allow Location",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class EmptyServiceWidget extends StatelessWidget {
  const EmptyServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: w * 0.02,
          horizontal: w * 0.02,
        ),
        child: Column(
          children: [
            /// Icon
            Container(
              height: w * 0.16,
              width: w * 0.16,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off,
                size: w * 0.1,
                color: Colors.green,
              ),
            ),

            SizedBox(height: w * 0.03),

            /// Title
            const Text(
              "No Services Nearby",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: w * 0.01),

            /// Subtitle
            Text(
              "We couldn’t find any services within 20 km.\nTry changing location or check later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: w * 0.06),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}