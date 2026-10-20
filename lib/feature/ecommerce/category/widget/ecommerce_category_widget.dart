// lib/feature/ecommerce/category/widget/ecommerce_category_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/ecommerce_category_controller.dart';
import '../model/ecommerce_category_model.dart';

class EcommerceCategoryWidget extends StatefulWidget {
  final Function(String)? onNavigateToCategoryWithName;

  /// Optional: called when user taps the "More" tile.
  /// If null, falls back to onNavigateToCategoryWithName('All').
  final VoidCallback? onMoreTap;

  const EcommerceCategoryWidget({
    super.key,
    this.onNavigateToCategoryWithName,
    this.onMoreTap,
  });

  @override
  State<EcommerceCategoryWidget> createState() =>
      _EcommerceCategoryWidgetState();
}

class _EcommerceCategoryWidgetState extends State<EcommerceCategoryWidget> {
  static const int _maxVisible = 11;
  static const Color _fallbackColor = Color(0xFFE63E3E);

  late final EcommerceCategoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceCategoryController>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        color: Colors.white,
        elevation: 0.1,
        child: Obx(() {
          // ---- Shimmer loading ----
          if (controller.isLoading.value && controller.categories.isEmpty) {
            return const _CategoryShimmerGrid();
          }

          // ---- Empty ----
          if (controller.categories.isEmpty) {
            return  SizedBox(
              height: 600,
              child: Center(child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info,size: 40,color: Colors.red,),
                  Text('No categories available',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey.shade700),),
                ],
              )),
            );
          }

          final visible = controller.categories.take(_maxVisible).toList();
          final itemCount = visible.length + 1; // always + "More"

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 0.8,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == visible.length) {
                return _MoreTile(
                  onTap: () {
                    if (widget.onMoreTap != null) {
                      widget.onMoreTap!();
                    } else {
                      widget.onNavigateToCategoryWithName?.call('All');
                    }
                  },
                );
              }

              return _CategoryTile(
                category: visible[index],
                fallbackColor: _fallbackColor,
                onTap: () => widget.onNavigateToCategoryWithName
                    ?.call(visible[index].title),
              );
            },
          );
        }),
      ),
    );
  }
}

// ============================================================
// Shimmer skeleton — same grid shape as the real content
// ============================================================
class _CategoryShimmerGrid extends StatelessWidget {
  const _CategoryShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 0.8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 12, // 2 full rows skeleton
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // circle skeleton
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 6),
              // label skeleton
              Container(
                width: 30,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// Single category tile
// ============================================================
class _CategoryTile extends StatelessWidget {
  final EcommerceCategoryModel category;
  final Color fallbackColor;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.fallbackColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: fallbackColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                category.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  // Per-image shimmer
                  return Shimmer.fromColors(
                    baseColor: const Color(0xFFE8E8E8),
                    highlightColor: const Color(0xFFF5F5F5),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.category_rounded,
                  color: fallbackColor,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// "More" tile — always the last one
// ============================================================
class _MoreTile extends StatelessWidget {
  final VoidCallback onTap;

  const _MoreTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE63E3E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Color(0xFFE63E3E),
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'More',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE63E3E),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}