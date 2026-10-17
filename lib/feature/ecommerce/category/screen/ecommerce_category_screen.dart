// lib/feature/ecommerce/category/screen/ecommerce_category_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../product/screen/ecommerce_product_screen.dart';
import '../controller/ecommerce_category_controller.dart';
import '../controller/ecommerce_subcategory_controller.dart';
import '../model/ecommerce_category_model.dart';
import '../model/ecommerce_subcategory_model.dart';

class EcommerceCategoryScreen extends StatefulWidget {
  /// Name of the category preselected (from home "tap category" flow).
  /// 'All' or null → "All" rail entry is selected (shows placeholder).
  final String? initialCategory;

  const EcommerceCategoryScreen({super.key, this.initialCategory});

  @override
  State<EcommerceCategoryScreen> createState() =>
      _EcommerceCategoryScreenState();
}

class _EcommerceCategoryScreenState extends State<EcommerceCategoryScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  /// Sentinel id for the virtual "All" rail entry
  static const int _kAllCategoryId = -1;

  late final EcommerceCategoryController categoryCtrl;
  late final EcommerceSubCategoryController subCtrl;

  int _selectedCategoryId = _kAllCategoryId;

  /// ✅ Controller for the left rail — used for auto-scrolling.
  final ScrollController _railScrollController = ScrollController();

  /// ✅ Per-tile GlobalKeys so we can scroll any selected tile into view,
  /// even if it's off-screen (e.g. user tapped a category from home).
  final Map<int, GlobalKey> _tileKeys = {};

  GlobalKey _keyFor(int id) => _tileKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void initState() {
    super.initState();
    categoryCtrl = Get.find<EcommerceCategoryController>();
    subCtrl = Get.find<EcommerceSubCategoryController>();

    _resolveInitialSelection();
  }

  @override
  void didUpdateWidget(covariant EcommerceCategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      _resolveInitialSelection();
    }
  }

  @override
  void dispose() {
    _railScrollController.dispose();
    super.dispose();
  }

  // =================================================================
  // Selection resolution
  // =================================================================
  void _resolveInitialSelection() {
    final name = widget.initialCategory;

    // ✅ 'All' or null → select the virtual "All" rail entry (no fetch)
    if (name == null || name.isEmpty || name.toLowerCase() == 'all') {
      if (_selectedCategoryId != _kAllCategoryId) {
        setState(() => _selectedCategoryId = _kAllCategoryId);
        _scrollSelectedIntoView();
      }
      return;
    }

    // Wait until categories are loaded, then resolve by name
    if (categoryCtrl.categories.isEmpty) {
      ever<List<EcommerceCategoryModel>>(categoryCtrl.categories, (_) {
        _resolveInitialSelection();
      });
      return;
    }

    EcommerceCategoryModel? match;
    for (final c in categoryCtrl.categories) {
      if (c.title.toLowerCase() == name.toLowerCase()) {
        match = c;
        break;
      }
    }
    match ??= categoryCtrl.categories.first;

    if (match.id != _selectedCategoryId) {
      setState(() => _selectedCategoryId = match!.id);
      subCtrl.fetchSubCategories(categoryId: match.id);
      _scrollSelectedIntoView();
    }
  }

  // =================================================================
  // ✅ Scroll selected tile into view
  // =================================================================
  void _scrollSelectedIntoView() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _tileKeys[_selectedCategoryId];
      final ctx = key?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: 0.5, // center in viewport
        );
      }
    });
  }

  // =================================================================
  // Tile taps
  // =================================================================
  void _onSelectAll() {
    setState(() => _selectedCategoryId = _kAllCategoryId);
    _scrollSelectedIntoView();
    // ⛔ No fetch — "All" shows a placeholder
  }

  void _onSelectCategory(EcommerceCategoryModel cat) {
    if (_selectedCategoryId == cat.id) return;
    setState(() => _selectedCategoryId = cat.id);
    subCtrl.fetchSubCategories(categoryId: cat.id);
    _scrollSelectedIntoView();
  }

  // =================================================================
  // Build
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: const Icon(Icons.category),
      ),
      body: Row(
        children: [
          // ================= LEFT — category rail =================
          Container(
            width: 100,
            color: const Color(0xFFF8F8F8),
            child: Obx(() {
              if (categoryCtrl.isLoading.value &&
                  categoryCtrl.categories.isEmpty) {
                return const _LeftShimmer();
              }

              final allSelected = _selectedCategoryId == _kAllCategoryId;
              final cats = categoryCtrl.categories;

              return ListView.builder(
                controller: _railScrollController, // ✅ scroll controller
                padding: EdgeInsets.zero,
                itemCount: cats.length + 1, // +1 for "All"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _AllCategoryTile(
                      key: _keyFor(_kAllCategoryId),
                      selected: allSelected,
                      accent: _accent,
                      onTap: _onSelectAll,
                    );
                  }

                  final cat = cats[index - 1];
                  final isSelected = cat.id == _selectedCategoryId;
                  return _SideCategoryTile(
                    key: _keyFor(cat.id), // ✅ per-tile key
                    category: cat,
                    selected: isSelected,
                    accent: _accent,
                    onTap: () => _onSelectCategory(cat),
                  );
                },
              );
            }),
          ),

          // ================= RIGHT — subcategory grid =================
          Expanded(
            child: Container(
              color: Colors.white,
              child: _selectedCategoryId == _kAllCategoryId
                  ? const _NoDataPlaceholder()
                  : Obx(() {
                if (subCtrl.isLoading.value) {
                  return const _RightShimmerGrid();
                }

                final subs = subCtrl.subCategories;
                if (subs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No sub-categories',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.82,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: subs.length,
                  itemBuilder: (context, index) {
                    final sub = subs[index];
                    return _SubCategoryTile(
                      sub: sub,
                      onTap: () {
                        Get.to(() => EcommerceProductListScreen(
                          subcategoryId: sub.id,
                          title: sub.title,
                        ));
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// "No Data" placeholder for the "All" selection
// ============================================================
class _NoDataPlaceholder extends StatelessWidget {
  const _NoDataPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 64,
              color: Color(0xFFCCCCCC),
            ),
            SizedBox(height: 12),
            Text(
              'No Data Working here',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Select a category on the left',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// "All" rail tile — animated selection
// ============================================================
class _AllCategoryTile extends StatelessWidget {
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _AllCategoryTile({
    super.key,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? accent : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: selected ? 46 : 44,
              height: selected ? 46 : 44,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accent.withOpacity(selected ? 0.18 : 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.apps_rounded,
                color: accent,
                size: selected ? 24 : 22,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? accent : const Color(0xFF333333),
              ),
              child: Text(
                'All',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LEFT TILE — vertical category rail entry with animation
// ============================================================
class _SideCategoryTile extends StatelessWidget {
  final EcommerceCategoryModel category;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  const _SideCategoryTile({
    super.key,
    required this.category,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: selected ? accent : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: selected ? 46 : 44,
              height: selected ? 46 : 44,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected
                    ? accent.withOpacity(0.12)
                    : const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  category.image,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: const Color(0xFFE8E8E8),
                      highlightColor: const Color(0xFFF5F5F5),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.category_rounded,
                    size: 20,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? accent : const Color(0xFF333333),
              ),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// RIGHT TILE — subcategory card
// ============================================================
class _SubCategoryTile extends StatelessWidget {
  final EcommerceSubCategoryModel sub;
  final VoidCallback onTap;

  const _SubCategoryTile({required this.sub, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  sub.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: const Color(0xFFE8E8E8),
                      highlightColor: const Color(0xFFF5F5F5),
                      child: Container(color: Colors.white),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub.title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
// LEFT shimmer
// ============================================================
class _LeftShimmer extends StatelessWidget {
  const _LeftShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 40,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// RIGHT shimmer
// ============================================================
class _RightShimmerGrid extends StatelessWidget {
  const _RightShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.82,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}