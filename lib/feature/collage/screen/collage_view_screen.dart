// Complete updated file with fix

// lib/feature/college/screen/collage_view_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/collage/screen/room_view_screen.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/contact_helper.dart';
import '../controller/room_controller.dart';
import '../controller/tiffin_controller.dart';
import '../model/college_model.dart';
import '../model/room_model.dart';
import '../model/tiffin_model.dart';

class CollageViewScreen extends StatefulWidget {
  final College college;
  const CollageViewScreen({super.key, required this.college});

  @override
  State<CollageViewScreen> createState() => _CollageViewScreenState();
}

class _CollageViewScreenState extends State<CollageViewScreen> {
  int _selectedTab = 0; // 0 for Room, 1 for Tiffin
  String _selectedRoomType = 'All';
  String _selectedTiffinType = 'All';
  int _selectedImageIndex = 0;

  final RoomController _roomController = Get.find<RoomController>();
  final TiffinController _tiffinController = Get.find<TiffinController>();

  // Get gallery images from college
  List<String> get _galleryImages {
    if (widget.college.images.isNotEmpty) {
      return widget.college.images.map((image) => image.url).toList();
    }
    // Fallback images if no images available
    return [
      "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=800&h=500&fit=crop",
      "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=800&h=500&fit=crop",
    ];
  }

  // Room type filters
  final List<String> _roomTypes = ['All', 'Single Room', '1bhk', '2bhk', '3bhk', 'pg'];

  // Tiffin type filters
  final List<String> _tiffinTypes = ['All', 'Veg', 'Non-Veg', 'Both'];

  // Get filtered rooms based on selected type
  List<Room> get _filteredRooms {
    if (_selectedRoomType == 'All') {
      return _roomController.filteredRooms;
    }
    return _roomController.filteredRooms
        .where((room) =>
    room.roomType?.toLowerCase() == _selectedRoomType.toLowerCase())
        .toList();
  }

  // Get filtered tiffins based on selected type
  List<Tiffin> get _filteredTiffins {
    if (_selectedTiffinType == 'All') {
      return _tiffinController.filteredTiffins;
    }

    if (_selectedTiffinType == 'Veg') {
      return _tiffinController.filteredTiffins
          .where((tiffin) => tiffin.isVegOnly)
          .toList();
    } else if (_selectedTiffinType == 'Non-Veg') {
      return _tiffinController.filteredTiffins
          .where((tiffin) => tiffin.isNonVegOnly)
          .toList();
    } else if (_selectedTiffinType == 'Both') {
      return _tiffinController.filteredTiffins
          .where((tiffin) => tiffin.isBothVegNonVeg)
          .toList();
    }

    return _tiffinController.filteredTiffins;
  }

  @override
  void initState() {
    super.initState();
    // Fetch rooms by college name
    _roomController.fetchRoomsByCollege(widget.college.name);
    // Fetch tiffins by college name
    _tiffinController.fetchTiffinsByCollege(widget.college.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.college.name),
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

        ],
      ),
      body: Obx(() {
        final bool isLoading = (_roomController.isLoading.value && _roomController.rooms.isEmpty) &&
            (_tiffinController.isLoading.value && _tiffinController.tiffins.isEmpty);

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
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
                            onError: (exception, stackTrace) {
                              // Handle image load error silently
                            },
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
                      // Gallery Navigation Arrows (only if more than 1 image)
                      if (_galleryImages.length > 1) ...[
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
                      ],
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
                  // Thumbnail Gallery (only if more than 1 image)
                  if (_galleryImages.length > 1)
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
                      widget.college.name,
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
                        Expanded(
                          child: Text(
                            widget.college.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                            Icons.home,
                            "${_roomController.rooms.length} Rooms",
                            AppColors.primary
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            Icons.fastfood_outlined,
                            "${_tiffinController.tiffins.length} Tiffin",
                            Colors.green
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                            Icons.category_rounded,
                            widget.college.category ?? 'General',
                            Colors.blue
                        ),
                      ],
                    ),
                    if (widget.college.website.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => ContactHelper.openWebsite(widget.college.website),
                            child: Text(
                              widget.college.website,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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

    // Show loading if rooms are being fetched
    if (_roomController.isLoading.value && rooms.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      );
    }

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
                  _selectedRoomType == 'All'
                      ? 'No rooms available near ${widget.college.name}'
                      : 'No rooms found for "$_selectedRoomType"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
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
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return _buildRoomCard(room);
        },
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    // Get first image URL
    String imageUrl = room.roomImages.isNotEmpty
        ? room.roomImages.first.url
        : 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop';

    // Generate rating from ID (since API doesn't have rating)
    double rating = (room.id % 5) + 1.0 + (room.id % 10) / 10;
    if (rating > 5.0) rating = 5.0;

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
                    imageUrl,
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
                        room.roomTypeDisplay,
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
                        color: room.availabilityColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        room.availabilityStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
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
                    room.title,
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
                        room.formattedPrice,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      if (room.amenityCount > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 12,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${room.amenityCount} amenities',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Amenities preview
                  if (room.amenityCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: room.amenities.take(2).map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 7,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tiffin Section - Updated with API data
  SliverToBoxAdapter _buildTiffinGrid() {
    final tiffins = _filteredTiffins;

    // Show loading if tiffins are being fetched
    if (_tiffinController.isLoading.value && tiffins.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      );
    }

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
                  _selectedTiffinType == 'All'
                      ? 'No tiffins available near ${widget.college.name}'
                      : 'No tiffins found for "$_selectedTiffinType"',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
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
        padding: const EdgeInsets.all(8),
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

  Widget _buildTiffinCard(Tiffin tiffin) {
    // Get first image URL
    String imageUrl = tiffin.hasImages
        ? tiffin.firstImageUrl
        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop';

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
                  imageUrl,
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
                      color: _getTiffinTypeColor(tiffin),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tiffin.tiffinType,
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
                          tiffin.ratingValue.toStringAsFixed(1),
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
                // Availability
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: tiffin.availabilityColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tiffin.availabilityStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
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
                  tiffin.title,
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
                  tiffin.description.isNotEmpty
                      ? tiffin.description
                      : 'Delicious tiffin service',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tiffin.formattedPrice,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: tiffin.isBooking ? null : () {
                      _showTiffinDetails(tiffin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tiffin.isBooking ? Colors.grey : AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: const Size(double.infinity, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      tiffin.isBooking ? "Booked" : "Order Now",
                      style: const TextStyle(
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

  Color _getTiffinTypeColor(Tiffin tiffin) {
    if (tiffin.isBothVegNonVeg) {
      return Colors.purple;
    } else if (tiffin.isVegOnly) {
      return Colors.green;
    } else if (tiffin.isNonVegOnly) {
      return Colors.red;
    }
    return Colors.blue;
  }

  void _showTiffinDetails(Tiffin tiffin) {
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
                tiffin.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTiffinTypeColor(tiffin).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tiffin.tiffinType,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTiffinTypeColor(tiffin),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.price_change_rounded, tiffin.formattedPrice),
              if (tiffin.nearCollege != null && tiffin.nearCollege!.isNotEmpty)
                _buildDetailRow(Icons.school_rounded, 'Near: ${tiffin.nearCollege}'),
              if (tiffin.hasContact)
                _buildDetailRow(Icons.phone_rounded, tiffin.contactDisplay),
              _buildDetailRow(Icons.info_outline_rounded,
                  tiffin.description.isEmpty ? 'Delicious tiffin service available' : tiffin.description),
              const SizedBox(height: 20),
              if (tiffin.hasContact) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => ContactHelper.call(tiffin.contactNumber!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.call, color: Colors.white, size: 18),
                        label: const Text(
                          'Call',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => ContactHelper.whatsapp(
                          tiffin.contactNumber!,
                          'Hi, I want to order ${tiffin.title}',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.message, color: Colors.white, size: 18),
                        label: const Text(
                          'WhatsApp',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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