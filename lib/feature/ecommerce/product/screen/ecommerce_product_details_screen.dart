import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ecommerce_product_controller.dart';
import '../model/ecommerce_product_model.dart';
import 'ecommerce_product_cart_screen.dart';

class EcommerceProductDetailsScreen extends StatefulWidget {
  final int productId;
  const EcommerceProductDetailsScreen({super.key, required this.productId});

  @override
  State<EcommerceProductDetailsScreen> createState() =>
      _EcommerceProductDetailsScreenState();
}

class _EcommerceProductDetailsScreenState
    extends State<EcommerceProductDetailsScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  int _productCount = 1;
  int _selectedSize = 0;
  int _selectedColor = 0;
  int _selectedImageIndex = 0;
  late PageController _pageController;

  final EcommerceProductController controller =
  Get.find<EcommerceProductController>();

  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<Map<String, dynamic>> _colors = [
    {'color': const Color(0xFF1E293B), 'name': 'Black'},
    {'color': const Color(0xFFEF4444), 'name': 'Red'},
    {'color': const Color(0xFF3B82F6), 'name': 'Blue'},
    {'color': const Color(0xFF10B981), 'name': 'Green'},
    {'color': const Color(0xFFF59E0B), 'name': 'Yellow'},
    {'color': const Color(0xFF8B5CF6), 'name': 'Purple'},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // ✅ Defer to next frame — Obx already mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductDetail(widget.productId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD TO CART — API
  // ============================================================
  Future<void> _handleAddToCart(EcommerceProductModel product) async {
    final ok = await controller.addToCart(
      product.id,
      quantity: _productCount,
    );
    // Just toast (already inside controller)
    if (ok) {
      // Optional: reset count
      setState(() => _productCount = 1);
    }
  }

  // BUY NOW — add then navigate to cart
  Future<void> _handleBuyNow(EcommerceProductModel product) async {
    final ok = await controller.addToCart(
      product.id,
      quantity: _productCount,
    );
    if (!ok) return;

    await controller.fetchCart();

    Get.to(() =>  EcommerceProductCartScreen());
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isProductDetailLoading.value) {
        return _buildScaffold(
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.productDetailError.value.isNotEmpty ||
          controller.selectedProduct.value == null) {
        return _buildScaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 64, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  controller.productDetailError.value.isEmpty
                      ? 'Product not found'
                      : controller.productDetailError.value,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      controller.fetchProductDetail(widget.productId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final product = controller.selectedProduct.value!;
      return _buildScaffold(
        body: _buildContent(product),
        bottom: _buildBottomBar(product),
      );
    });
  }

  Widget _buildScaffold({required Widget body, Widget? bottom}) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: body),
          if (bottom != null) bottom,
        ],
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================
  Widget _buildAppBar() {
    return Obx(() {
      final product = controller.selectedProduct.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Color(0xFF1E293B), size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product?.title ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product != null)
                GestureDetector(
                  onTap: () => controller.toggleFavoriteFromDetail(product.id),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: product.isFavorite
                          ? Colors.red
                          : const Color(0xFF1E293B),
                      size: 20,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Get.to(() => const EcommerceProductCartScreen());
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    final count = controller.cartCount;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined,
                            color: Color(0xFF1E293B), size: 20),
                        if (count > 0)
                          Positioned(
                            right: -6,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ============================================================
  // CONTENT
  // ============================================================
  Widget _buildContent(EcommerceProductModel product) {
    final priceValue = double.tryParse(product.price) ?? 0;
    final oldPriceValue = double.tryParse(product.oldPrice) ?? 0;
    final discountPercentage = oldPriceValue > priceValue && oldPriceValue > 0
        ? ((1 - priceValue / oldPriceValue) * 100)
        : 0.0;

    final images = <String>[
      if (product.primaryImage != null && product.primaryImage!.isNotEmpty)
        product.primaryImage!,
      ...product.images.map((e) => e.image),
    ];
    final productImages =
    images.isEmpty ? ['https://via.placeholder.com/400'] : images;

    if (_selectedImageIndex >= productImages.length) _selectedImageIndex = 0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 65,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productImages.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedImageIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Container(
                        height: 55,
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? _accent : Colors.grey[300]!,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            productImages[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  height: 300,
                  color: _accent.withOpacity(0.05),
                  child: Stack(
                    children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() => _selectedImageIndex = index);
                        },
                        children: productImages.map((imageUrl) {
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      if (product.badge != null && product.badge!.isNotEmpty)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              product.badge!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              '${_selectedImageIndex + 1} / ${productImages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                if (product.userDetail != null)
                  Row(
                    children: [
                      Icon(Icons.storefront_rounded,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        'Sold by: ${product.userDetail!.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (oldPriceValue > 0)
                      Text(
                        '₹${product.oldPrice}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF999999),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 10),
                    if (discountPercentage > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${discountPercentage.toStringAsFixed(0)}% OFF',
                          style: const TextStyle(
                            color: _accent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                if (product.description.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                const Text(
                  'Select Size',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _sizes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final size = entry.value;
                    final isSelected = _selectedSize == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSize = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                          isSelected ? _accent : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? _accent : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Select Color',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _colors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final colorData = entry.value;
                    final Color color = colorData['color'];
                    final String colorName = colorData['name'];
                    final bool isSelected = _selectedColor == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? _accent
                                    : Colors.grey[300]!,
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 16)
                                : null,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            colorName,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? _accent
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTION BAR
  // ============================================================
  Widget _buildBottomBar(EcommerceProductModel product) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (_productCount > 1) {
                            setState(() => _productCount--);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Icon(Icons.remove_rounded,
                              size: 18, color: Color(0xFF1E293B)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        color: Colors.white,
                        child: Text(
                          _productCount.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _productCount++),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Icon(Icons.add_rounded,
                              size: 18, color: Color(0xFF1E293B)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Add to Cart
                Expanded(
                  child: Obx(() {
                    final isAdding =
                    controller.addingToCartIds.contains(product.id);
                    return ElevatedButton(
                      onPressed: isAdding ? null : () => _handleAddToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent.withOpacity(0.1),
                        foregroundColor: _accent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: _accent, width: 1.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isAdding)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _accent,
                              ),
                            )
                          else
                            const Icon(Icons.shopping_cart_outlined,
                                size: 18, color: _accent),
                          const SizedBox(width: 6),
                          Text(
                            isAdding ? 'Adding...' : 'Add to Cart',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: _accent,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 8),

                // Buy Now
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleBuyNow(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.flash_on_rounded,
                            size: 18, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Buy Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}