import 'package:flutter/material.dart';
import 'package:untitled/feature/collage/screen/room_view_screen.dart';
import '../../../core/utils/app_color.dart';

class CollageViewScreen extends StatefulWidget {
  final String collageName;
  const CollageViewScreen({super.key, required this.collageName});

  @override
  State<CollageViewScreen> createState() => _CollageViewScreenState();
}

class _CollageViewScreenState extends State<CollageViewScreen> {
  int _selectedTab = 0; // 0 for Room, 1 for Tiffin
  String _selectedRoomType = 'All';
  String _selectedTiffinType = 'All';
  int _selectedImageIndex = 0;

  // College Gallery Images
  final List<String> _galleryImages = [
    "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800&h=500&fit=crop",
    "https://images.unsplash.com/photo-1562774053-701939374585?w=800&h=500&fit=crop",
    "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=800&h=500&fit=crop",
    "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800&h=500&fit=crop",
    "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800&h=500&fit=crop",
    "https://images.unsplash.com/photo-1592823680328-7b67d7d76c14?w=800&h=500&fit=crop",
  ];

  // Room type filters
  final List<String> _roomTypes = ['All', 'Single Room', '1BHK', '2BHK', '3BHK', 'PG'];

  // Tiffin type filters
  final List<String> _tiffinTypes = ['All', 'Veg', 'Non-Veg', 'Jain', 'Egg'];

  // Sample room data with room type and distance
  final List<RoomModel> _allRooms = [
    RoomModel(
      name: "Comfort Single Room",
      type: "Single Room",
      price: "₹8,000/month",
      imageUrl: "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop",
      rating: 4.5,
      isAvailable: true,
      distance: "0.5 km",
      address: "Near College Gate, Jabalpur",
    ),
    RoomModel(
      name: "Spacious 1BHK",
      type: "1BHK",
      price: "₹12,000/month",
      imageUrl: "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400&h=300&fit=crop",
      rating: 4.3,
      isAvailable: true,
      distance: "1.2 km",
      address: "Ranital, Jabalpur",
    ),
    RoomModel(
      name: "Modern 2BHK Apartment",
      type: "2BHK",
      price: "₹18,000/month",
      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=300&fit=crop",
      rating: 4.7,
      isAvailable: true,
      distance: "2.0 km",
      address: "Vijay Nagar, Jabalpur",
    ),
    RoomModel(
      name: "Luxury 3BHK",
      type: "3BHK",
      price: "₹25,000/month",
      imageUrl: "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=400&h=300&fit=crop",
      rating: 4.8,
      isAvailable: false,
      distance: "3.5 km",
      address: "Civil Lines, Jabalpur",
    ),
    RoomModel(
      name: "Boys PG",
      type: "PG",
      price: "₹6,000/month",
      imageUrl: "https://images.unsplash.com/photo-1554995207-c18c203602cb?w=400&h=300&fit=crop",
      rating: 4.0,
      isAvailable: true,
      distance: "0.8 km",
      address: "Garha, Jabalpur",
    ),
    RoomModel(
      name: "Girls PG",
      type: "PG",
      price: "₹7,000/month",
      imageUrl: "https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=400&h=300&fit=crop",
      rating: 4.2,
      isAvailable: true,
      distance: "1.5 km",
      address: "Pachpedi, Jabalpur",
    ),
    RoomModel(
      name: "Studio Single Room",
      type: "Single Room",
      price: "₹9,000/month",
      imageUrl: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=300&fit=crop",
      rating: 4.1,
      isAvailable: false,
      distance: "2.8 km",
      address: "Madan Mahal, Jabalpur",
    ),
    RoomModel(
      name: "Premium 1BHK",
      type: "1BHK",
      price: "₹14,000/month",
      imageUrl: "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=400&h=300&fit=crop",
      rating: 4.6,
      isAvailable: true,
      distance: "1.8 km",
      address: "Adhartal, Jabalpur",
    ),
    RoomModel(
      name: "Family 2BHK",
      type: "2BHK",
      price: "₹20,000/month",
      imageUrl: "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400&h=300&fit=crop",
      rating: 4.4,
      isAvailable: true,
      distance: "4.0 km",
      address: "Civic Center, Jabalpur",
    ),
  ];

  // Sample tiffin data with center details
  final List<TiffinModel> _allTiffins = [
    TiffinModel(
      name: "Sharma Veg Tiffin",
      type: "Veg",
      price: "₹120/meal",
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop",
      rating: 4.6,
      cuisine: "North Indian",
      distance: "0.3 km",
      address: "Near College Gate, Jabalpur",
      timing: "12:00 PM - 2:00 PM",
      contact: "+91 98765 43210",
    ),
    TiffinModel(
      name: "Royal Non-Veg Special",
      type: "Non-Veg",
      price: "₹180/meal",
      imageUrl: "https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=300&fit=crop",
      rating: 4.8,
      cuisine: "Mughlai",
      distance: "1.0 km",
      address: "Ranital, Jabalpur",
      timing: "11:30 AM - 2:30 PM",
      contact: "+91 98765 43211",
    ),
    TiffinModel(
      name: "Healthy Veg Bowl",
      type: "Veg",
      price: "₹90/meal",
      imageUrl: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop",
      rating: 4.3,
      cuisine: "Continental",
      distance: "1.5 km",
      address: "Vijay Nagar, Jabalpur",
      timing: "10:00 AM - 1:00 PM",
      contact: "+91 98765 43212",
    ),
    TiffinModel(
      name: "South Indian Delight",
      type: "Veg",
      price: "₹100/meal",
      imageUrl: "https://images.unsplash.com/photo-1633945274405-b6c80a12c5b1?w=400&h=300&fit=crop",
      rating: 4.7,
      cuisine: "South Indian",
      distance: "0.8 km",
      address: "Garha, Jabalpur",
      timing: "11:00 AM - 3:00 PM",
      contact: "+91 98765 43213",
    ),
    TiffinModel(
      name: "Egg Special Tiffin",
      type: "Egg",
      price: "₹85/meal",
      imageUrl: "https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400&h=300&fit=crop",
      rating: 4.2,
      cuisine: "Fusion",
      distance: "2.0 km",
      address: "Madan Mahal, Jabalpur",
      timing: "12:30 PM - 2:30 PM",
      contact: "+91 98765 43214",
    ),
    TiffinModel(
      name: "Jain Bhojan",
      type: "Jain",
      price: "₹110/meal",
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop",
      rating: 4.5,
      cuisine: "Rajasthani",
      distance: "2.5 km",
      address: "Civil Lines, Jabalpur",
      timing: "12:00 PM - 2:00 PM",
      contact: "+91 98765 43215",
    ),
    TiffinModel(
      name: "Mughlai Non-Veg",
      type: "Non-Veg",
      price: "₹200/meal",
      imageUrl: "https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=300&fit=crop",
      rating: 4.9,
      cuisine: "Mughlai",
      distance: "3.0 km",
      address: "Adhartal, Jabalpur",
      timing: "11:30 AM - 3:00 PM",
      contact: "+91 98765 43216",
    ),
    TiffinModel(
      name: "Pure Veg Thali",
      type: "Veg",
      price: "₹95/meal",
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop",
      rating: 4.4,
      cuisine: "Gujarati",
      distance: "1.2 km",
      address: "Pachpedi, Jabalpur",
      timing: "12:00 PM - 2:30 PM",
      contact: "+91 98765 43217",
    ),
  ];

  // Get filtered rooms based on selected type
  List<RoomModel> get _filteredRooms {
    if (_selectedRoomType == 'All') {
      return _allRooms;
    }
    return _allRooms.where((room) => room.type == _selectedRoomType).toList();
  }

  // Get filtered tiffins based on selected type
  List<TiffinModel> get _filteredTiffins {
    if (_selectedTiffinType == 'All') {
      return _allTiffins;
    }
    return _allTiffins.where((tiffin) => tiffin.type == _selectedTiffinType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.collageName),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: Colors.white),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // College Header Image with Gallery
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Main Image with Gallery Indicator
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        image: DecorationImage(
                          image: NetworkImage(_galleryImages[_selectedImageIndex]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Gallery Navigation Arrows
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 8,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = (_selectedImageIndex - 1 + _galleryImages.length) % _galleryImages.length;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 8,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = (_selectedImageIndex + 1) % _galleryImages.length;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Image Counter
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${_selectedImageIndex + 1}/${_galleryImages.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Gallery Indicator Dots
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _galleryImages.length,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _selectedImageIndex == index ? 20 : 8,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: _selectedImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Thumbnail Gallery
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  color: Colors.grey.shade50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _galleryImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedImageIndex == index
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              _galleryImages[index],
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 60,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // College Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.collageName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Jabalpur, Madhya Pradesh",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.home, "50+ Rooms", AppColors.primary),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.fastfood_outlined, "50+ Tiffin", Colors.green),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.location_on, "${5.6} Km", Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tabs: Room & Tiffin
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabDelegate(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Main Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabButton("Rooms", 0),
                        _buildTabButton("Tiffin", 1),
                      ],
                    ),
                    // Filter Chips for selected tab
                    _buildFilterChips(),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 10,),),
          // Content based on selected tab
          _selectedTab == 0
              ? _buildRoomGrid()
              : _buildTiffinGrid(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _selectedTab == 0
            ? _roomTypes.map((type) => _buildChip(type, _selectedRoomType == type, () {
          setState(() {
            _selectedRoomType = type;
          });
        })).toList()
            : _tiffinTypes.map((type) => _buildChip(type, _selectedTiffinType == type, () {
          setState(() {
            _selectedTiffinType = type;
          });
        })).toList(),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? AppColors.primary : Colors.grey.shade100,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Room Section
  SliverToBoxAdapter _buildRoomGrid() {
    final rooms = _filteredRooms;
    if (rooms.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No rooms found for "${_selectedRoomType}"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: rooms.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return _buildRoomCard(room);
        },
      ),
    );
  }

  Widget _buildRoomCard(RoomModel room) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomViewScreen(room: room),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.network(
                    room.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.bed_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Room Type Tag
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        room.type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Availability
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: room.isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        room.isAvailable ? "Available" : "Booked",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Rating
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            room.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    room.address,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.price,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            room.distance,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
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

  // Tiffin Section
  SliverToBoxAdapter _buildTiffinGrid() {
    final tiffins = _filteredTiffins;
    if (tiffins.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No tiffins found for "${_selectedTiffinType}"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: tiffins.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final tiffin = tiffins[index];
          return _buildTiffinCard(tiffin);
        },
      ),
    );
  }

  Widget _buildTiffinCard(TiffinModel tiffin) {
    return Card(
      color: Colors.white,
      elevation: 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Stack(
              children: [
                Image.network(
                  tiffin.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: const Icon(
                          Icons.food_bank_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
                // Tiffin Type Tag
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getTiffinColor(tiffin.type),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tiffin.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Rating
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          tiffin.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Distance
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          tiffin.distance,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tiffin.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tiffin.cuisine,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tiffin.price,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 10,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        tiffin.timing,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show tiffin details
                      _showTiffinDetails(tiffin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: const Size(double.infinity, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Order Now",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTiffinColor(String type) {
    switch (type) {
      case 'Veg':
        return Colors.green;
      case 'Non-Veg':
        return Colors.red;
      case 'Jain':
        return Colors.orange;
      case 'Egg':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  void _showTiffinDetails(TiffinModel tiffin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                tiffin.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.location_on_rounded, tiffin.address),
              _buildDetailRow(Icons.access_time_rounded, tiffin.timing),
              _buildDetailRow(Icons.phone_rounded, tiffin.contact),
              _buildDetailRow(Icons.food_bank_rounded, "${tiffin.cuisine} Cuisine"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${tiffin.name} ordered successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Order Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class RoomModel {
  final String name;
  final String type;
  final String price;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final String distance;
  final String address;

  RoomModel({
    required this.name,
    required this.type,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
    required this.distance,
    required this.address,
  });
}

class TiffinModel {
  final String name;
  final String type;
  final String price;
  final String imageUrl;
  final double rating;
  final String cuisine;
  final String distance;
  final String address;
  final String timing;
  final String contact;

  TiffinModel({
    required this.name,
    required this.type,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.cuisine,
    required this.distance,
    required this.address,
    required this.timing,
    required this.contact,
  });
}

// Custom SliverPersistentHeaderDelegate for sticky tabs
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 95;

  @override
  double get minExtent => 95;

  @override
  bool shouldRebuild(_StickyTabDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}