import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_color.dart';
import '../../home/controller/it_service_category_controller.dart';

class ItServiceCategoryWidget extends StatefulWidget {
  final VoidCallback? onNavigateToCategory;
  final Function(String)? onNavigateToCategoryWithName;

  const ItServiceCategoryWidget({
    super.key,
    this.onNavigateToCategory,
    this.onNavigateToCategoryWithName,
  });

  @override
  State<ItServiceCategoryWidget> createState() => _ItServiceCategoryWidgetState();
}

class _ItServiceCategoryWidgetState extends State<ItServiceCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    final ItServiceCategoryController controller =
    Get.find<ItServiceCategoryController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Header ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.grid_view_rounded,
                      color: AppColors.itServices, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  widget.onNavigateToCategory?.call();
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.itServices,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ---------- Grid (live from API) ----------
          Obx(() {
            // Loading skeleton
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 10,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('  '),
                    ),
                  ],
                ),
              );
            }

            // Empty
            if (controller.categories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No services available',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            }

            // Data — build list with "All" appended at the end
            final apiCategories = controller.categories;
            final totalItems = apiCategories.length + 1; // +1 for "All"

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                final bool isAll = index == apiCategories.length;
                final String name =
                isAll ? 'All' : apiCategories[index].name;

                return InkWell(
                  onTap: () {
                    widget.onNavigateToCategoryWithName?.call(name);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ---------- Image / Icon box ----------
                      Expanded(
                        child: Container(
                          width: double.infinity,
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
                          child: isAll
                          // "All" → icon (no image from API)
                              ? Icon(
                            Icons.dashboard_rounded,
                            color: AppColors.itServices,
                            size: 22,
                          )
                          // Real category → Cloudinary image from API
                              : Padding(
                            padding: const EdgeInsets.all(6),
                            child: Image.network(
                              apiCategories[index].image,
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                              loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                color: AppColors.itServices
                                    .withOpacity(0.5),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ---------- Name ----------
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isAll
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isAll
                                ? AppColors.itServices
                                : AppColors.textMain,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}