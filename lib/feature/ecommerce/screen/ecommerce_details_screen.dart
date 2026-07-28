import 'package:flutter/material.dart';

class EcommerceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  // Hamein pichli screen se product details milengi
  const EcommerceDetailsScreen({super.key, required this.product});

  @override
  State<EcommerceDetailsScreen> createState() => _EcommerceDetailsScreenState();
}

class _EcommerceDetailsScreenState extends State<EcommerceDetailsScreen> {
  int _productCount = 1; // Product quantity counter
  bool _isFavorite = false; // Wishlist state

  @override
  Widget build(BuildContext context) {
    // Agar pichli screen se data nahi aa raha toh fallback dummy data
    final productData = widget.product.isNotEmpty
        ? widget.product
        : {
      'title': 'Premium Wireless Buds',
      'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
      'shop': 'Apex Digital Hub',
      'price': '\$29.99',
      'badge': 'Hot Deal',
      'color': const Color(0xFF0EA5E9),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // ================= 1. PREMIUM IMAGE HERO & APPBAR =================
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavorite ? Colors.red : const Color(0xFF1E293B),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: productData['color'].withOpacity(0.05)),
                  Image.network(
                    productData['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          // ================= 2. PRODUCT INFO & SPECIFICATIONS =================
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge & Shop Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: productData['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          productData['badge'] ?? 'Featured',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: productData['color']),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          const Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(" (120 reviews)", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Title
                  Text(
                    productData['title'],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),

                  // Shop Name
                  Text(
                    "Sold by: ${productData['shop']}",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 10),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This premium item is carefully selected and quality checked. Packed with high-grade materials to ensure best customer satisfaction and durability.",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= 3. BETTER UX BOTTOM ACTION BAR =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4)),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity Selector & Price row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Price", style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(
                      productData['price'],
                      style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),

                // UX-Optimized Counter (Plus/Minus)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_productCount > 1) {
                            setState(() => _productCount--);
                          }
                        },
                        icon: const Icon(Icons.remove_rounded, size: 18, color: Color(0xFF1E293B)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          _productCount.toString().padLeft(2, '0'),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => _productCount++);
                        },
                        icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Add to Cart & Buy Now Buttons Row
            Row(
              children: [
                // Add To Cart Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Added $_productCount item(s) to Cart!"), backgroundColor: Colors.green),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF1E293B),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Add to Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),

                // Buy Now Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Checkout action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Buy Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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