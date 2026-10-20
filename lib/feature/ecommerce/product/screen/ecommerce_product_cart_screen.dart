import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ecommerce_product_controller.dart';
import '../model/ecommerce_product_model.dart';
import 'ecommerce_product_details_screen.dart';

class EcommerceProductCartScreen extends StatefulWidget {
  const EcommerceProductCartScreen({super.key});

  @override
  State<EcommerceProductCartScreen> createState() =>
      _EcommerceProductCartScreenState();
}

class _EcommerceProductCartScreenState
    extends State<EcommerceProductCartScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  // ============================================================
  // CHARGES CONFIG
  // ============================================================
  static const double _gstPercent = 18.0;
  static const double _platformFeePercent = 2.0;
  static const double _handlingChargePerItem = 10;

  // Charity — no toggle, just amount
  int _donationAmount = 0;
  static const List<Map<String, dynamic>> _donationOptions = [
    {'amount': 50, 'label': 'Coffee ☕'},
    {'amount': 100, 'label': 'Meal 🍽️'},
    {'amount': 250, 'label': 'Books 📚'},
    {'amount': 500, 'label': 'School 🏫'},
    {'amount': 1000, 'label': 'Education 🎓'},
  ];

  final TextEditingController _customDonationCtrl = TextEditingController();

  final EcommerceProductController controller =
  Get.find<EcommerceProductController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.fetchCart();
    });
  }

  @override
  void dispose() {
    _customDonationCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() => controller.fetchCart();

  // ============================================================
  // BILL BREAKDOWN
  // ============================================================
  double get _subtotal {
    return controller.cartItems.fold<double>(
      0,
          (sum, item) => sum + (double.tryParse(item.price) ?? 0) * item.quantity,
    );
  }

  int get _totalItems {
    return controller.cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  double get _handlingCharge => _totalItems * _handlingChargePerItem;

  double get _platformFee => _subtotal * _platformFeePercent / 100;

  double get _gstAmount {
    final base = _subtotal + _platformFee + _handlingCharge;
    return base * _gstPercent / 100;
  }

  double get _donation => _donationAmount.toDouble();

  double get _grandTotal =>
      _subtotal + _handlingCharge + _platformFee + _gstAmount + _donation;

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isCartLoading.value && controller.cartItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cartItems.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.cartItems.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == controller.cartItems.length) {
                      return _buildDonationSection();
                    }
                    final item = controller.cartItems[index];
                    return _CartItemTile(
                      item: item,
                      onIncrement: () => _increment(item),
                      onDecrement: () => _decrement(item),
                      onRemove: () => _remove(item),
                    );
                  },
                ),
              ),
              _buildCheckoutBar(),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // DONATION SECTION (no toggle)
  // ============================================================
  Widget _buildDonationSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: Color(0xFF10B981), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Support a Cause ❤️',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Optional — add a small donation',
                      style:
                      TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Preset chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _donationOptions.map((option) {
              final amount = option['amount'] as int;
              final isSelected = _donationAmount == amount;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    // Tapping same chip deselects
                    _donationAmount = isSelected ? 0 : amount;
                    _customDonationCtrl.clear();
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? const Color(0xFF10B981) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹$amount',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        option['label'],
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Custom input
          Row(
            children: [
              const Text(
                'Custom: ',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _customDonationCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final amount = int.tryParse(value) ?? 0;
                      setState(() {
                        _donationAmount = amount;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter amount (optional)',
                      hintStyle: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      prefixText: '₹ ',
                      prefixStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Show selected donation
          if (_donationAmount > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volunteer_activism_rounded,
                          color: Color(0xFF10B981), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Donation',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹$_donationAmount',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================
  Future<void> _increment(EcommerceCartItemModel item) async {
    await controller.addToCart(item.productId, quantity: 1);
    await controller.fetchCart();
  }

  Future<void> _decrement(EcommerceCartItemModel item) async {
    if (item.quantity <= 1) {
      await _remove(item);
      return;
    }
    await controller.removeFromCart(item.productId, quantity: 1);
    await controller.fetchCart();
  }

  Future<void> _remove(EcommerceCartItemModel item) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Remove item?'),
        content: Text('Remove "${item.product.title}" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove',
                style: TextStyle(color: _accent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await controller.removeFromCart(item.productId);
    }
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            'Add products to see them here',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BILL ROW
  // ============================================================
  Widget _billRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 14 : 12,
              color: bold ? const Color(0xFF1E293B) : Colors.grey[600],
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 15 : 12,
              color: bold ? _accent : const Color(0xFF1E293B),
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHECKOUT BAR
  // ============================================================
  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _billRow('Subtotal (${_totalItems} items)',
                '₹${_subtotal.toStringAsFixed(2)}'),
            _billRow(
                'Handling Charge (₹${_handlingChargePerItem.toInt()}/item)',
                '₹${_handlingCharge.toStringAsFixed(2)}'),
            _billRow('Platform Fee (${_platformFeePercent.toInt()}%)',
                '₹${_platformFee.toStringAsFixed(2)}'),
            _billRow('GST (${_gstPercent.toInt()}%)',
                '₹${_gstAmount.toStringAsFixed(2)}'),
            if (_donationAmount > 0)
              _billRow('Donation ❤️', '₹$_donationAmount'),
            const Divider(height: 16),
            _billRow('Total Amount',
                '₹${_grandTotal.toStringAsFixed(2)}', bold: true),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckout() {
    Get.snackbar(
      'Checkout',
      'Total: ₹${_grandTotal.toStringAsFixed(2)}'
          '${_donationAmount > 0 ? ' (includes ₹$_donationAmount donation ❤️)' : ''}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

// ============================================================
// Cart item tile (unchanged)
// ============================================================
class _CartItemTile extends StatelessWidget {
  final EcommerceCartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  static const Color _accent = Color(0xFFE63E3E);

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final price = double.tryParse(item.price) ?? 0;
    final oldPrice = double.tryParse(product.oldPrice) ?? 0;
    final lineTotal = price * item.quantity;

    return GestureDetector(
      onTap: () {
        Get.to(() => EcommerceProductDetailsScreen(productId: product.id));
      },
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
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.primaryImage ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.delete_outline_rounded,
                              size: 18, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  if (product.userDetail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Sold by: ${product.userDetail!.name}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${item.price}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (oldPrice > 0)
                        Text(
                          '₹${product.oldPrice}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: onDecrement,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Icon(Icons.remove_rounded,
                                    size: 14, color: Color(0xFF1E293B)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              color: Colors.white,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onIncrement,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Icon(Icons.add_rounded,
                                    size: 14, color: Color(0xFF1E293B)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${lineTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
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