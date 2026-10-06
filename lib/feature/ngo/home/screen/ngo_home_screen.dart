import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../services/screen/donation_details_screen.dart';
import '../controller/ngo_category_controller.dart';
import '../model/ngo_category_model.dart';
import '../widget/ngo_banner_widget.dart';
import '../widget/open_donation_widget.dart';

class NgoHomeScreen extends StatefulWidget {
  final Function(int index, {String? category})? onNavigate;
  const NgoHomeScreen({super.key, this.onNavigate});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  static const Color primaryColor = Colors.teal;

  final controller = Get.find<NgoCategoryController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Banner Slider ──
          SliverToBoxAdapter(
            child: NgoBannerWidget(),
          ),

          // ── Sticky Search ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchBoxDelegate(
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Scaffold(
                          appBar: AppBar(
                            title: const Text('Search'),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          body: const Center(child: Text('Search Screen')),
                        ),
                  ),
                );
              },
            ),
          ),

          // ── Categories ──
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value && controller.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.categories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Categories",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                      ),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return _buildCategoryCard(category);
                      },
                    ),
                  ],
                ),
              );
            }
            ),
          ),

          // ── Open Donations ──
          SliverToBoxAdapter(
            child: OpenDonationWidget(headline:  "Open Donations", color: Colors.teal.shade100,),
          ),

          // ── All Donations ──
          SliverToBoxAdapter(
            child: OpenDonationWidget(headline:  "All Donations",color: Colors.teal.shade50,),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }


  Widget _buildCategoryCard(NgoCategoryData category) {
    return InkWell(
      onTap: () {
        widget.onNavigate?.call(1, category: category.name);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: NetworkImage(category.image))
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

}

class _StickySearchBoxDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onSearchTap;

  _StickySearchBoxDelegate({required this.onSearchTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: maxExtent,
        padding: const EdgeInsets.symmetric(horizontal: 16,),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.teal,width: 0.3),
          borderRadius: BorderRadius.circular(12)
        ),
        child: InkWell(
          onTap: onSearchTap,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600], size: 22),
              const SizedBox(width: 12),
              Text(
                "Search here...",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}