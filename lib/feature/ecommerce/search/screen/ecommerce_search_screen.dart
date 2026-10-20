// lib/feature/ecommerce/product/screen/ecommerce_search_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../product/controller/ecommerce_product_controller.dart';
import '../../product/model/ecommerce_product_model.dart';

class EcommerceSearchScreen extends StatefulWidget {
  const EcommerceSearchScreen({super.key});

  @override
  State<EcommerceSearchScreen> createState() => _EcommerceSearchScreenState();
}

class _EcommerceSearchScreenState extends State<EcommerceSearchScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;

  // Local state
  final RxString _query = ''.obs;
  final RxBool _isSearching = false.obs;
  final RxList<EcommerceProductModel> _results = <EcommerceProductModel>[].obs;
  final RxList<String> _recentSearches = <String>[
    'sneakers',
    'headphones',
    't-shirt',
  ].obs; // TODO: SharedPreferences se load karo

  // Popular/trending suggestions (static — API se laa sakte ho)
  final List<String> _trending = const [
    'iPhone 15',
    'Nike shoes',
    'Wireless earbuds',
    'Smart watch',
    'Backpack',
  ];

  late final EcommerceProductController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<EcommerceProductController>();
    _searchController.addListener(_onTextChanged);
    // Screen open hote hi keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _searchController.text.trim();
    _query.value = text;

    // Debounce
    _debounce?.cancel();
    if (text.isEmpty) {
      _results.clear();
      _isSearching.value = false;
      return;
    }
    if (text.length < 2) return; // 2+ chars pe hi search

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(text);
    });
  }

  /// ✅ Local filter — controller.products pe, koi API call nahi
  void _performSearch(String query) {
    _isSearching.value = true;

    final q = query.toLowerCase();
    final all = _controller.products; // already fetched list

    final filtered = all.where((p) {
      final title = p.title.toLowerCase();
      // chaho to brand/category bhi include kar lo:
      // final brand = p.brand?.toLowerCase() ?? '';
      return title.contains(q);
    }).toList();

    _results.assignAll(filtered);
    _isSearching.value = false;
  }

  void _submitSearch(String text) {
    final q = text.trim();
    if (q.isEmpty) return;

    _searchController.text = q;
    _searchController.selection =
        TextSelection.fromPosition(TextPosition(offset: q.length));

    // Recent update
    _recentSearches.remove(q);
    _recentSearches.insert(0, q);
    if (_recentSearches.length > 8) _recentSearches.removeLast();

    _focusNode.unfocus();
    _performSearch(q);
  }

  void _clearSearch() {
    _searchController.clear();
    _results.clear();
    _query.value = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        title: _buildSearchField(),
        actions: [
          Obx(() => _query.value.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: _clearSearch,
          )),
        ],
      ),
      body: Obx(() {
        // 1) Query empty → recent + trending
        if (_query.value.isEmpty) {
          return _buildDiscoverView();
        }

        // 2) Searching → shimmer
        if (_isSearching.value) {
          return const _SearchShimmerGrid();
        }

        // 3) No results
        if (_results.isEmpty) {
          return _buildNoResults();
        }

        // 4) Results grid
        return _buildResultsGrid();
      }),
    );
  }

  // ============================================================
  // Search field in AppBar
  // ============================================================
  Widget _buildSearchField() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: _submitSearch,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search products, brands...',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
          prefixIcon:
          Icon(Icons.search_rounded, size: 20, color: Color(0xFF666666)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // ============================================================
  // Discover view (recent + trending)
  // ============================================================
  Widget _buildDiscoverView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recent searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              GestureDetector(
                onTap: () => _recentSearches.clear(),
                child: const Text(
                  'Clear',
                  style: TextStyle(fontSize: 12, color: _accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches
                .map((q) => _chip(
              label: q,
              icon: Icons.history_rounded,
              onTap: () => _submitSearch(q),
              onDelete: () => _recentSearches.remove(q),
            ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Trending
        const Text(
          'Trending Now',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _trending
              .map((q) => _chip(
            label: q,
            icon: Icons.trending_up_rounded,
            onTap: () => _submitSearch(q),
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF888888)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close_rounded,
                  size: 14,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // No results
  // ============================================================
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            'Try different keywords',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Results grid
  // ============================================================
  Widget _buildResultsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final product = _results[index];
        return _SearchProductCard(
          product: product,
          onTap: () {
            // TODO: product detail pe navigate karo
            // Get.to(() => EcommerceProductScreen(product: product));
          },
          onFavoriteTap: () => _controller.toggleFavorite(product.id),
        );
      },
    );
  }
}

// ============================================================
// Search result card (same look as product list)
// ============================================================
class _SearchProductCard extends StatelessWidget {
  final EcommerceProductModel product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const _SearchProductCard({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: Image.network(
                      product.primaryImage ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (product.badge != null && product.badge!.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: product.isFavorite
                              ? const Color(0xFFE63E3E)
                              : const Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product.oldPrice != '0')
                        Flexible(
                          child: Text(
                            '₹${product.oldPrice}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

// ============================================================
// Shimmer
// ============================================================
class _SearchShimmerGrid extends StatelessWidget {
  const _SearchShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}