import 'package:flutter/material.dart';
import 'ecommerce_cart_screen.dart';

class EcommerceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EcommerceDetailsScreen({super.key, required this.product});

  @override
  State<EcommerceDetailsScreen> createState() => _EcommerceDetailsScreenState();
}

class _EcommerceDetailsScreenState extends State<EcommerceDetailsScreen> {
  int _productCount = 1;
  bool _isFavorite = false;
  int _selectedSize = 0;
  int _selectedColor = 0;
  int _donationAmount = 0;
  bool _showDonation = false;
  int _selectedImageIndex = 0;
  late PageController _pageController;

  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<Map<String, dynamic>> _colors = [
    {'color': const Color(0xFF1E293B), 'name': 'Black'},
    {'color': const Color(0xFFEF4444), 'name': 'Red'},
    {'color': const Color(0xFF3B82F6), 'name': 'Blue'},
    {'color': const Color(0xFF10B981), 'name': 'Green'},
    {'color': const Color(0xFFF59E0B), 'name': 'Yellow'},
    {'color': const Color(0xFF8B5CF6), 'name': 'Purple'},
  ];

  final List<Map<String, dynamic>> _donationOptions = [
    {'amount': 50, 'label': 'Coffee ☕'},
    {'amount': 100, 'label': 'Meal 🍽️'},
    {'amount': 250, 'label': 'Books 📚'},
    {'amount': 500, 'label': 'School 🏫'},
    {'amount': 1000, 'label': 'Education 🎓'},
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Rahul Sharma',
      'rating': 5,
      'date': '2 days ago',
      'comment': 'Excellent product! Highly recommend it to everyone.',
      'avatar': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Priya Patel',
      'rating': 4,
      'date': '1 week ago',
      'comment': 'Good quality, but delivery was a bit slow.',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Amit Kumar',
      'rating': 5,
      'date': '2 weeks ago',
      'comment': 'Best purchase I made this year!',
      'avatar': 'https://i.pravatar.cc/150?img=3',
    },
  ];

  final List<Map<String, dynamic>> _similarProducts = [
    {
      'title': 'Premium Headphones',
      'price': '₹1,999',
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
    },
    {
      'title': 'Smart Speaker',
      'price': '₹3,499',
      'image': 'https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=200',
    },
    {
      'title': 'Phone Case',
      'price': '₹499',
      'image': 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?q=80&w=200',
    },
    {
      'title': 'Charging Cable',
      'price': '₹299',
      'image': 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?q=80&w=200',
    },
    {
      'title': 'Screen Protector',
      'price': '₹199',
      'image': 'https://images.unsplash.com/photo-1592890288560-4b28c8bf6af1?q=80&w=200',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _productImages {
    final mainImage = widget.product['imageUrl'] ??
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400';
    return [
      mainImage,
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400&fit=crop&crop=center',
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400&fit=crop&crop=left',
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400&fit=crop&crop=right',
      'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400&fit=crop&crop=top',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product.isNotEmpty
        ? widget.product
        : {
      'title': 'Premium Wireless Buds',
      'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=400',
      'shop': 'Apex Digital Hub',
      'price': '₹2,499',
      'oldPrice': '₹4,199',
      'badge': 'Hot Deal',
      'rating': 4.8,
      'reviews': 120,
      'color': const Color(0xFFE63E3E),
      'description': 'This premium item is carefully selected and quality checked. Packed with high-grade materials to ensure best customer satisfaction and durability.',
    };

    final Color primaryColor = productData['color'] ?? const Color(0xFFE63E3E);
    final double priceValue = double.parse(
        productData['price'].replaceAll('₹', '').replaceAll(',', ''));
    final double oldPriceValue = productData['oldPrice'] != null
        ? double.parse(productData['oldPrice'].replaceAll('₹', '').replaceAll(',', ''))
        : 0;
    final double discountPercentage = oldPriceValue > 0
        ? ((1 - priceValue / oldPriceValue) * 100)
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ================= APP BAR =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
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
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      productData['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite ? 'Added to Wishlist ❤️' : 'Removed from Wishlist',
                          ),
                          backgroundColor: _isFavorite ? primaryColor : Colors.grey,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: _isFavorite ? Colors.red : const Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share link copied 📋'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= MAIN CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vertical Thumbnails
                        Container(
                          width: 65,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          color: Colors.white,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _productImages.length,
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
                                      color: isSelected ? primaryColor : Colors.grey[300]!,
                                      width: isSelected ? 2.5 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                        : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      _productImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
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
                        // Main Image
                        Expanded(
                          child: Container(
                            height: 300,
                            color: primaryColor.withOpacity(0.05),
                            child: Stack(
                              children: [
                                PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedImageIndex = index;
                                    });
                                  },
                                  children: _productImages.map((imageUrl) {
                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Container(
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
                                // Badge
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      productData['badge'] ?? 'Featured',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // Image Counter
                                Positioned(
                                  bottom: 12,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                    margin: const EdgeInsets.symmetric(horizontal: 80),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_selectedImageIndex + 1} / ${_productImages.length}',
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

                    // ================= PRODUCT INFO =================
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  final rating = productData['rating'] ?? 4.8;
                                  final fullStars = rating.floor();
                                  final hasHalfStar = rating - fullStars >= 0.5;
                                  if (index < fullStars) {
                                    return const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  } else if (index == fullStars && hasHalfStar) {
                                    return const Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.star_border_rounded,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }
                                }),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                (productData['rating'] ?? 4.8).toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "(${productData['reviews'] ?? 120} reviews)",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Title
                          Text(
                            productData['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Shop
                          Row(
                            children: [
                              Icon(
                                Icons.storefront_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Sold by: ${productData['shop']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Price
                          Row(
                            children: [
                              Text(
                                productData['price'],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (productData['oldPrice'] != null)
                                Text(
                                  productData['oldPrice'],
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
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${discountPercentage.toStringAsFixed(0)}% OFF',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Size Selection
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
                                onTap: () {
                                  setState(() {
                                    _selectedSize = index;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? primaryColor : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Color Selection
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
                                onTap: () {
                                  setState(() {
                                    _selectedColor = index;
                                  });
                                },
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
                                          color: isSelected ? primaryColor : Colors.grey[300]!,
                                          width: isSelected ? 2.5 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                          BoxShadow(
                                            color: color.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                            : null,
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      colorName,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        color: isSelected ? primaryColor : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // ================= DONATION SECTION =================
                          Container(
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.favorite_rounded,
                                        color: Color(0xFF10B981),
                                        size: 16,
                                      ),
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
                                            'Help us make a difference',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _showDonation,
                                      onChanged: (value) {
                                        setState(() {
                                          _showDonation = value;
                                          if (!_showDonation) {
                                            _donationAmount = 0;
                                          }
                                        });
                                      },
                                      activeColor: const Color(0xFF10B981),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ],
                                ),
                                if (_showDonation) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: _donationOptions.map((option) {
                                      final isSelected = _donationAmount == option['amount'];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _donationAmount = option['amount'];
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFF10B981)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFF10B981)
                                                  : Colors.grey[300]!,
                                              width: 1.5,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                              BoxShadow(
                                                color: const Color(0xFF10B981)
                                                    .withOpacity(0.3),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                                : null,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '₹${option['amount']}',
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
                                                  fontWeight: isSelected
                                                      ? FontWeight.w500
                                                      : FontWeight.w400,
                                                  color: isSelected
                                                      ? Colors.white.withOpacity(0.9)
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                              if (isSelected) ...[
                                                const SizedBox(width: 2),
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
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
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                            ),
                                          ),
                                          child: TextField(
                                            onChanged: (value) {
                                              final amount = int.tryParse(value) ?? 0;
                                              setState(() {
                                                _donationAmount = amount;
                                              });
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Enter amount',
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
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (_donationAmount > 0)
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
                                              const Icon(
                                                Icons.volunteer_activism_rounded,
                                                color: Color(0xFF10B981),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Donation Amount',
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
                                  if (_donationAmount == 0 && _showDonation)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Please select or enter a donation amount',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ================= SIMILAR PRODUCTS =================
                          const Text(
                            'Similar Products',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _similarProducts.length,
                              itemBuilder: (context, index) {
                                final product = _similarProducts[index];
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            product['image'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported_rounded,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['title'],
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 1),
                                            Text(
                                              product['price'],
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFE63E3E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM ACTION BAR =================
            Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Quantity
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: const Icon(
                                  Icons.remove_rounded,
                                  size: 18,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                              ),
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
                              onTap: () {
                                setState(() => _productCount++);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 18,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Add to Cart
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EcommerceCartScreen(
                                  product: productData,
                                  productCount: _productCount,
                                  showDonation: _showDonation,
                                  donationAmount: _donationAmount.toDouble(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            foregroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: primaryColor, width: 1.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 18, color: primaryColor),
                              const SizedBox(width: 6),
                              Text(
                                "Add to Cart",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Buy Now
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EcommerceCartScreen(
                                  product: productData,
                                  productCount: _productCount,
                                  showDonation: _showDonation,
                                  donationAmount: _donationAmount.toDouble(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.flash_on_rounded, size: 18, color: Colors.white),
                              const SizedBox(width: 6),
                              const Text(
                                "Buy Now",
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
                  const SizedBox(height: 10),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(priceValue * _productCount).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          if (oldPriceValue > 0)
                            Text(
                              '₹${(oldPriceValue * _productCount).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (_showDonation && _donationAmount > 0)
                            Text(
                              '+ ₹$_donationAmount donation',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
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