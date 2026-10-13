// lib/screens/dashboard/it_service_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_color.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../booking/widget/it_service_order_widget.dart';

class ItServiceProfileScreen extends StatelessWidget {
  const ItServiceProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.itServices,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.itServices,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            pinned: false,
            snap: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.itServices,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.itServices,
                      AppColors.itServices.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.white,
                        child: Icon(
                          Icons.person_rounded,
                          size: 30,
                          color: AppColors.itServices,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          final user = authController.currentUser.value;

                          final name = (user?.name ?? '').trim().isEmpty
                              ? 'Guest User'
                              : user!.name;

                          final phone = (user?.phoneNumber ?? '').trim();

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                phone.isEmpty
                                    ? 'Not signed in'
                                    : phone,
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ItServiceOrderWidget(),
          ),
        ],
      ),
    );
  }
}