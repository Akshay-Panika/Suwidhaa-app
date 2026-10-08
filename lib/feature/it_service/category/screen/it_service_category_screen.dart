import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_color.dart';
import '../../home/controller/it_service_category_controller.dart';
import '../../service/controller/it_service_controller.dart';
import '../../service/model/it_service_model.dart';
import '../../service/screen/it_service_details_screen.dart';

class ItServiceCategoryScreen extends StatefulWidget {
  final String? initialCategory;

  const ItServiceCategoryScreen({super.key, this.initialCategory});

  @override
  State<ItServiceCategoryScreen> createState() =>
      _ItServiceCategoryScreenState();
}

class _ItServiceCategoryScreenState extends State<ItServiceCategoryScreen> {
  late String _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  final ItServiceCategoryController _categoryCtrl =
  Get.find<ItServiceCategoryController>();
  final ItServiceController _serviceCtrl = Get.find<ItServiceController>();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
  }

  @override
  void didUpdateWidget(covariant ItServiceCategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategory != null &&
        widget.initialCategory != oldWidget.initialCategory) {
      setState(() => _selectedCategory = widget.initialCategory!);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _scrollToSelected() {
    final list = _sideCategories;
    final index = list.indexWhere((c) => c['name'] == _selectedCategory);
    if (index < 0 || !_scrollController.hasClients) return;

    const itemHeight = 90.0;
    final target = (index * itemHeight)
        .clamp(0.0, _scrollController.position.maxScrollExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('app')) return Icons.mobile_friendly_rounded;
    if (n.contains('web')) return Icons.web_rounded;
    if (n.contains('iot') || n.contains('robot')) {
      return Icons.smart_toy_rounded;
    }
    if (n.contains('game')) return Icons.sports_esports_rounded;
    if (n.contains('toy')) return Icons.toys_rounded;
    return Icons.grid_view_rounded;
  }

  Color _colorFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('app')) return AppColors.ecommerce;
    if (n.contains('web')) return AppColors.primary;
    if (n.contains('iot') || n.contains('robot')) return AppColors.ngo;
    if (n.contains('game')) return AppColors.school;
    if (n.contains('toy')) return AppColors.ngo;
    return AppColors.itServices;
  }

  List<Map<String, dynamic>> get _sideCategories {
    return [
      {
        'name': 'All',
        'icon': Icons.dashboard,
        'color': AppColors.itServices,
        'image': null,
      },
      ..._categoryCtrl.categories.map((c) => {
        'name': c.name,
        'icon': _iconFor(c.name),
        'color': _colorFor(c.name),
        'image': c.image,
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.itServices,
        title: const Text(
          'IT Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppColors.itServices,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: Obx(() {
        if (_categoryCtrl.isLoading.value &&
            _categoryCtrl.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.itServices),
          );
        }

        final sideCats = _sideCategories;

        return Row(
          children: [
            // ====== LEFT CATEGORY RAIL ======
            Container(
              width: 100,
              color: AppColors.white,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: sideCats.length,
                itemBuilder: (context, index) {
                  final category = sideCats[index];
                  final isSelected = _selectedCategory == category['name'];

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedCategory = category['name']);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.itServices.withOpacity(0.08)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? AppColors.itServices
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: [
                                AppColors.itServices,
                                AppColors.itServices
                                    .withOpacity(0.6),
                              ])
                                  : null,
                              color: isSelected
                                  ? null
                                  : category['color'].withOpacity(0.12),
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: AppColors.itServices
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                                  : null,
                            ),
                            child: category['image'] != null
                                ? ClipOval(
                              child: Image.network(
                                category['image'],
                                fit: BoxFit.cover,
                                width: 44,
                                height: 44,
                                gaplessPlayback: true,
                                errorBuilder: (_, __, ___) => Icon(
                                  category['icon'],
                                  color: isSelected
                                      ? AppColors.white
                                      : category['color'],
                                  size: 22,
                                ),
                              ),
                            )
                                : Icon(
                              category['icon'],
                              color: isSelected
                                  ? AppColors.white
                                  : category['color'],
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.itServices
                                  : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ====== PROJECT GRID (LIVE) ======
            Expanded(
              child: Obx(() {
                final services =
                _serviceCtrl.filteredByCategory(_selectedCategory);

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${services.length} services',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _serviceCtrl.isLoading.value &&
                            _serviceCtrl.services.isEmpty
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.itServices,
                          ),
                        )
                            : services.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.inbox_rounded,
                                size: 64,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No services in this category',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                            : GridView.builder(
                          padding: const EdgeInsets.all(4),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return _buildServiceCard(
                                services[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildServiceCard(ItServiceData service) {
    final categoryName = service.category?.name ?? '';
    final categoryImage = service.category?.image ?? '';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItServiceDetailsScreen(service: service),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            if (categoryImage.isNotEmpty)
                              ClipOval(
                                child: Image.network(
                                  categoryImage,
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(),
                                ),
                              ),
                            if (categoryImage.isNotEmpty)
                              const SizedBox(width: 4),
                            Text(
                              categoryName,
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
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${service.price}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.itServices,
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}