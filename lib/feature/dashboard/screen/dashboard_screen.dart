import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/app_color.dart';
import '../../account/screen/account_screen.dart';
import '../../module/screen/module_screen.dart';
import '../widget/promotional_bottomsheet_card.dart';

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
        width: 350,
        child: AccountScreen(),
      ),
      body: Stack(
        children: [
          const ModuleScreen(),

          // Promotional Bottom Sheet Widget (invisible, handles logic)
          const PromotionalBottomSheet(),

          // You can uncomment the bottom navigation if needed
          // _buildBottomNavigation(),
        ],
      ),
    );
  }

// Optional: Uncomment if you need bottom navigation
// Widget _buildBottomNavigation() {
//   return Positioned(
//     left: 25,
//     right: 25,
//     bottom: 25,
//     child: SizedBox(
//       height: 75,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(35),
//               border: Border.all(
//                 color: AppColors.primary.withOpacity(0.15),
//                 width: 1.5,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(30),
//                     onTap: () {},
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         FaIcon(
//                           FontAwesomeIcons.house,
//                           size: 18,
//                           color: AppColors.primary,
//                         ),
//                         const SizedBox(height: 3),
//                         Text(
//                           'Home',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 70),
//                 Expanded(
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(30),
//                     onTap: () {
//                       _scaffoldKey.currentState?.openDrawer();
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.account_box_rounded,
//                           size: 20,
//                           color: AppColors.primary,
//                         ),
//                         const SizedBox(height: 3),
//                         Text(
//                           'Account',
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: -12,
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 height: 66,
//                 width: 66,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.primary,
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.primary.withOpacity(0.30),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.face_rounded,
//                   color: Colors.white,
//                   size: 36,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}