import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/app_color.dart';
import '../../account/screen/account_screen.dart';
import '../../module/screen/ai_assistant_screen.dart';
import '../../module/screen/module_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const Drawer(
        width: 300, // More reasonable width
        child: AccountScreen(),
      ),
      body: Stack(
        children: [
          // Main content
          const ModuleScreen(),

          // Bottom action buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
              child: Row(
                children: [
                  // Social media button
                  Card(
                    elevation: 2,
                    color: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Handle Instagram action
                        // You can add your Instagram link here
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white, // Using the imported color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Main action button
                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AIAssistantScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Center(
                            child: Text(
                              "Tell Your Doubt",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
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