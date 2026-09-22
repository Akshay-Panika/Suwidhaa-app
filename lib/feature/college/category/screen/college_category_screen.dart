import 'package:flutter/material.dart';

import '../../../../core/utils/app_color.dart';
import 'college_category_list_screen.dart';

class CollegeCategoryScreen extends StatefulWidget {
  const CollegeCategoryScreen({super.key});

  @override
  State<CollegeCategoryScreen> createState() => _CollegeCategoryScreenState();
}

class _CollegeCategoryScreenState extends State<CollegeCategoryScreen> {
  final List<Map<String, dynamic>> _collegeCategory = [
    {
      'name': 'Engineering',
      'icon': Icons.engineering,
    },
    {
      'name': 'Medical',
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Arts',
      'icon': Icons.palette,
    },
    {
      'name': 'Commerce',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Agriculture',
      'icon': Icons.agriculture,
    },
    {
      'name': 'Science',
      'icon': Icons.science,
    },
    {
      'name': 'Law',
      'icon': Icons.gavel,
    },
    {
      'name': 'Management',
      'icon': Icons.business_center,
    },
    {
      'name': 'Computer Science',
      'icon': Icons.computer,
    },
    {
      'name': 'Pharmacy',
      'icon': Icons.medication,
    },
    {
      'name': 'Nursing',
      'icon': Icons.health_and_safety,
    },
    {
      'name': 'Education',
      'icon': Icons.school,
    },
    {
      'name': 'Architecture',
      'icon': Icons.architecture,
    },
    {
      'name': 'Hotel Management',
      'icon': Icons.hotel,
    },
    {
      'name': 'Design',
      'icon': Icons.design_services,
    },
    {
      'name': 'Veterinary',
      'icon': Icons.pets,
    },
    {
      'name': 'Paramedical',
      'icon': Icons.medical_services,
    },
    {
      'name': 'Dental',
      'icon': Icons.health_and_safety,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: _collegeCategory.length,
        itemBuilder: (context, index) {
          final category = _collegeCategory[index];

          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CollegeCategoryListScreen(
                collegeCategory: category['name'] ,
              ),));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: CollegeColors.primary,
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    size: 30,
                    color: CollegeColors.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
