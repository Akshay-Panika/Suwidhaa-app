import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_color.dart';
import '../../category/widget/it_service_category_widget.dart';
import '../../service/controller/it_service_controller.dart';
import '../../service/model/it_service_model.dart';
import '../../service/screen/it_service_details_screen.dart';
import '../widget/it_service_banner_widget.dart';

class ItServiceHomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategory;
  final Function(String)? onNavigateToCategoryWithName;

  const ItServiceHomeScreen({
    super.key,
    this.onNavigateToCategory,
    this.onNavigateToCategoryWithName,
  });

  @override
  State<ItServiceHomeScreen> createState() => ItServiceHomeScreenState();
}

class ItServiceHomeScreenState extends State<ItServiceHomeScreen> {
  final ItServiceController _serviceCtrl = Get.find<ItServiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.itServices,
        elevation: 0,
        surfaceTintColor: AppColors.itServices,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.computer_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'IT Services',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Find your perfect tech partner',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
                onPressed: () {
                  // handle notifications
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  color: AppColors.itServices,
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400,width: 0.6),
                    color:  Colors.white,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Icon(Icons.search),
                      Text("Search for 'Service'")
                    ],
                  ),
                ),
              ],
            ),
            const ItServiceBannerWidget(),
            const SizedBox(height: 16),

            // ---------- Categories row ----------
            ItServiceCategoryWidget(
              onNavigateToCategory: widget.onNavigateToCategory,
              onNavigateToCategoryWithName:
              widget.onNavigateToCategoryWithName,
            ),
            const SizedBox(height: 20),

            // ---------- Featured services (live) ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToCategory,
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.itServices,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Obx(() {
              if (_serviceCtrl.isLoading.value &&
                  _serviceCtrl.services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.itServices,
                    ),
                  ),
                );
              }

              if (_serviceCtrl.services.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No services available',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }

              // Show first 6 services on home
              final list = _serviceCtrl.services.take(6).toList();

              return SizedBox(
                height: 400,
                child: GridView.builder(
                  // shrinkWrap: true,
                  itemCount: list.length,
                 padding: EdgeInsets.symmetric(horizontal: 12),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6
                  ),
                  itemBuilder: (context, index) {
                    return _buildHomeServiceCard(list[index]);
                  },),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeServiceCard(ItServiceData service) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItServiceDetailsScreen(
                serviceId: service.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Image ----------
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      service.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                     if (service.category != null)
                     Positioned(
                         top: 8,
                         left: 8,
                         child: Container(
                           padding: const EdgeInsets.symmetric(
                               horizontal: 8, vertical: 3),
                           decoration: BoxDecoration(
                             color: AppColors.itServices,
                             borderRadius: BorderRadius.circular(6),
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               if (service.category!.image.isNotEmpty)
                                 ClipOval(
                                   child: Image.network(
                                     service.category!.image,
                                     width: 14,
                                     height: 14,
                                     fit: BoxFit.cover,
                                     errorBuilder: (_, __, ___) =>
                                     const SizedBox.shrink(),
                                   ),
                                 ),
                               if (service.category!.name.isNotEmpty)
                                 const SizedBox(width: 4),
                               Text(
                                 service.category!.name,
                                 style: const TextStyle(
                                   color: AppColors.white,
                                   fontSize: 9,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                  ],
                ),
              ),
            ),

            // ---------- Info ----------
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '₹${service.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.itServices,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (service.oldPrice.isNotEmpty)
                              Text(
                                '₹${service.oldPrice}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:service.isBooked?  Colors.green : AppColors.itServices, width: 0.6),
                    ),
                    child:  Row(
                      children: [
                        Icon(Icons.bookmark,
                            size: 12, color: service.isBooked?  Colors.green :AppColors.itServices),
                        SizedBox(width: 4),
                        Text(
                          service.isBooked? "Booked":"Book Now",
                          style: TextStyle(
                            color: service.isBooked?  Colors.green :AppColors.itServices,
                            fontSize: 10,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}