import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Drawer(
        width: double.infinity,
        child: AccountScreen(),
      ),
      body: ModuleScreen(),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 4),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIAssistantScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/image/ai-assistant.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}