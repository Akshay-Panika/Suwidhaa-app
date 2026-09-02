import 'package:flutter/material.dart';
import '../../canteen/screen/canteen_screen.dart';
import '../../library/screen/library_screen.dart';
import '../../science_lab/screen/science_lab_screen.dart';
import '../../sports/screen/sports_screen.dart';
import '../computer_lab/screen/somputer_lab_screen.dart';

class SchoolFacilitiesCard extends StatelessWidget {
  const SchoolFacilitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "School Facilities",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFacilityItem(
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LibraryScreen(),));
                },
                Icons.local_library,
                "Library",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFacilityItem(
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScienceLabScreen(),));
                },
                Icons.science,
                "Science Lab",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFacilityItem(
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ComputerLabScreen(),));
                },
                Icons.computer,
                "Computer Lab",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildFacilityItem(
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SportsScreen(),));
                },
                Icons.sports_soccer,
                "Sports",
              ),
            ),
            const SizedBox(width: 10),
            // Expanded(
            //   child: _buildFacilityItem(
            //     () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolStudentTransportScreen(),));
            //     },
            //     Icons.directions_bus,
            //     "Transport",
            //   ),
            // ),
            // const SizedBox(width: 10),
            Expanded(
              child: _buildFacilityItem(
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CanteenScreen(),));
                },
                Icons.restaurant,
                "Canteen",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
Widget _buildFacilityItem(VoidCallback onTap,IconData icon, String title) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 26,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
