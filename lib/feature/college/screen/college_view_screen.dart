import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/college/screen/room_view_screen.dart';
import 'package:untitled/feature/college/screen/tiffin_view_screen.dart';
import 'dart:math' as math;
import '../../../core/utils/app_color.dart';
import '../../../core/widget/contact_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/college_booking_controller.dart';
import '../controller/college_controller.dart';
import '../controller/room_controller.dart';
import '../controller/tiffin_controller.dart';
import '../model/college_model.dart';
import '../model/room_model.dart';
import '../model/tiffin_model.dart';

class CollegeViewScreen extends StatefulWidget {
  final String collegeId;
  final String collegeName;

  const CollegeViewScreen({
    super.key,
    required this.collegeId,
    required this.collegeName,
  });

  @override
  State<CollegeViewScreen> createState() => _CollegeViewScreenState();
}

class _CollegeViewScreenState extends State<CollegeViewScreen> {
  int _selectedTab = 0; // 0 = Room, 1 = Tiffin
  String _selectedRoomType = 'All';
  String _selectedTiffinType = 'All';
  int _selectedImageIndex = 0;

  final AuthController authController = Get.find<AuthController>();
  final RoomController _roomController = Get.find<RoomController>();
  final TiffinController _tiffinController = Get.find<TiffinController>();
  final CollegeController _collegeController = Get.find<CollegeController>();
  final CollegeBookingController _bookingController =
  Get.find<CollegeBookingController>();

  bool _isBooking = false;
  College? _college;
  bool _isCollegeLoading = true;
  String _collegeError = '';

  final List<String> _roomTypes = [
    'All',
    'Single Room',
    '1bhk',
    '2bhk',
    '3bhk',
    'pg',
  ];

  final List<String> _tiffinTypes = ['All', 'Veg', 'Non-Veg', 'Both'];

  // ==================== DISTANCE CALCULATION ====================

  /// Calculate distance between two coordinates in kilometers using Haversine formula
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  /// Format distance for display
  String _formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    } else if (distanceInKm < 10) {
      return '${distanceInKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceInKm.toStringAsFixed(0)} km';
    }
  }

  /// Calculate and format distance from college to a location
  String _getDistanceFromCollege(dynamic lat, dynamic lon) {
    if (_college == null || _college!.latitude == null || _college!.longitude == null || lat == null || lon == null) {
      return '';
    }

    final collegeLat = double.tryParse(_college!.latitude.toString());
    final collegeLon = double.tryParse(_college!.longitude.toString());
    final destLat = double.tryParse(lat.toString());
    final destLon = double.tryParse(lon.toString());

    if (collegeLat == null || collegeLon == null || destLat == null || destLon == null) {
      return '';
    }

    final distance = _calculateDistance(collegeLat, collegeLon, destLat, destLon,);

    return _formatDistance(distance);
  }


  List<Room> get _filteredRooms {
    if (_selectedRoomType == 'All') {
      return _roomController.filteredRooms;
    }
    return _roomController.filteredRooms
        .where((room) =>
    room.roomType?.toLowerCase() ==
        _selectedRoomType.toLowerCase())
        .toList();
  }

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

    _tiffinController.fetchTiffinsByCollege(widget.collegeName,);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. College details
      await _fetchCollegeDetails();

      // 2. User ID
      final userId = authController.getUserId > 0
          ? authController.getUserId.toString()
          : null;

      print('🔑 userId = $userId');   // ✅ DEBUG

      // 3. Rooms — user-wise booking ke saath
      await _roomController.fetchAllRooms(
        userId: userId,
        nearCollege: widget.collegeName,
      );

      if (mounted) setState(() {});
    });
  }


  Future<void> _fetchCollegeDetails() async {
    try {
      final id = int.tryParse(widget.collegeId);
      if (id == null) {
        if (mounted) {
          setState(() {
            _collegeError = 'Invalid college ID';
            _isCollegeLoading = false;
          });
        }
        return;
      }

      _collegeController.clearSelectedCollege();
      await _collegeController.fetchCollegeById(id);

      if (mounted) {
        setState(() {
          _college = _collegeController.selectedCollege.value;
          _isCollegeLoading = false;
          if (_college == null) {
            _collegeError = 'College not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _collegeError = e.toString();
          _isCollegeLoading = false;
        });
      }
    }
  }

  Future<void> _retryFetchCollege() async {
    setState(() {
      _isCollegeLoading = true;
      _collegeError = '';
      _college = null;
    });
    await _fetchCollegeDetails();
  }

  // ==================== HELPERS ====================

  String get _collegeWebsite => _college?.website ?? '';
  String get _collegeAddress => _college?.address ?? '';
  String get _collegeCategory => _college?.category ?? 'General';
  String? get _collegeContactNumber => _college?.contactNumber;
  String? get _collegeLogoUrl => _college?.logoUrl;
  List<CollegeImage> get _collegeImages => _college?.images ?? [];
  String get _collegeName => _college?.name ?? widget.collegeName;

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.collegeName),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        backgroundColor: CollegeColors.primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: const [],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isCollegeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_collegeError.isNotEmpty || _college == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _collegeError.isNotEmpty ? _collegeError : 'College not found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retryFetchCollege,
              style: ElevatedButton.styleFrom(
                backgroundColor: CollegeColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      final bool isLoading =
          (_roomController.isLoading.value && _roomController.rooms.isEmpty) &&
              (_tiffinController.isLoading.value &&
                  _tiffinController.tiffins.isEmpty);

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeaderGallery()),
                SliverToBoxAdapter(child: _buildCollegeInfo()),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabDelegate(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTabButton(
                                  "${_roomController.rooms.length} Rooms", 0),
                              _buildTabButton(
                                  "${_tiffinController.tiffins.length} Tiffin",
                                  1),
                            ],
                          ),
                          _buildFilterChips(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                _selectedTab == 0 ? _buildRoomGrid() : _buildTiffinGrid(),
              ],
            ),
          ),

          // ============ BOTTOM BAR ============
          SafeArea(
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (_college == null ||
                          _college!.booking ||
                          _isBooking)
                          ? null
                          : _onCollegeEnquiryTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _college!.booking
                              ? Colors.grey
                              : CollegeColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isBooking
                              ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                              : Text(
                            _college!.booking
                                ? "College Enquiry Booked"
                                : "College Enquiry",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        final phone = _college?.contactNumber;
                        if (phone != null && phone.isNotEmpty) {
                          ContactHelper.call(phone);
                        }
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // ==================== COLLEGE ENQUIRY (only college) ====================

  Future<void> _onCollegeEnquiryTap() async {
    setState(() => _isBooking = true);

    try {
      final success = await _bookingController.bookCollege(
        collegeId: _college!.id,
        message: 'Hi Suwidhaa:\n'
            'Name: ${authController.getUserName}\n'
            'Phone: ${authController.getUserPhone}\n'
            'I am interested in admission to this college - ${_college!.name}',
        // ✅ No room, no tiffin — sirf college enquiry
      );

      if (!mounted) return;

      if (success) {
        await _collegeController.fetchCollegeById(_college!.id);
        if (mounted) {
          setState(() {
            _college = _collegeController.selectedCollege.value;
            _isBooking = false;
          });
        }
      } else {
        setState(() => _isBooking = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isBooking = false);
      print('❌ _onCollegeEnquiryTap error: $e');
    }
  }

  // ==================== HEADER GALLERY ====================

  Widget _buildHeaderGallery() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: NetworkImage(
                    _collegeImages.isNotEmpty
                        ? _collegeImages[_selectedImageIndex].url
                        : 'https://via.placeholder.com/400x300?text=No+Image',
                  ),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
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
            if (_collegeImages.length > 1) ...[
              Positioned(
                top: 0,
                bottom: 0,
                left: 8,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = (_selectedImageIndex -
                            1 +
                            _collegeImages.length) %
                            _collegeImages.length;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 28),
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
                        _selectedImageIndex = (_selectedImageIndex + 1) %
                            _collegeImages.length;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ],
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${_selectedImageIndex + 1}/${_collegeImages.isNotEmpty ? _collegeImages.length : 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _collegeImages.length,
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
            Positioned(
              left: 10,
              bottom: 0,
              child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CollegeColors.border, width: 0.3),
                  image: DecorationImage(
                    image: NetworkImage(
                      _collegeLogoUrl != null && _collegeLogoUrl!.isNotEmpty
                          ? _collegeLogoUrl!
                          : 'https://via.placeholder.com/100x100?text=Logo',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_collegeImages.length > 1)
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            color: Colors.grey.shade50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _collegeImages.length,
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
                            ? CollegeColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        _collegeImages[index].url,
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
    );
  }

  // ==================== COLLEGE INFO ====================

  Widget _buildCollegeInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _collegeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.category_rounded,
                _collegeCategory,
                CollegeColors.secondary,
              ),
            ],
          ),
          if (_collegeWebsite.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.language_rounded,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        ContactHelper.openWebsite(_collegeWebsite),
                    child: Text(
                      _collegeWebsite,
                      style: TextStyle(
                        fontSize: 14,
                        color: CollegeColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _collegeAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== FILTER CHIPS ====================

  Widget _buildFilterChips() {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _selectedTab == 0
            ? _roomTypes
            .map((type) =>
            _buildChip(type, _selectedRoomType == type, () {
              setState(() {
                _selectedRoomType = type;
              });
            }))
            .toList()
            : _tiffinTypes
            .map((type) =>
            _buildChip(type, _selectedTiffinType == type, () {
              setState(() {
                _selectedTiffinType = type;
              });
            }))
            .toList(),
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
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? CollegeColors.primary : Colors.grey.shade100,
            border: Border.all(
              color: isSelected ? CollegeColors.primary : CollegeColors.border,
              width: 0.3,
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
        borderRadius: BorderRadius.circular(10),
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
                color: isSelected ? CollegeColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                isSelected ? CollegeColors.primary : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== ROOM GRID ====================

  SliverToBoxAdapter _buildRoomGrid() {
    final rooms = _filteredRooms;

    if (_roomController.isLoading.value && rooms.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
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
                      ? 'No rooms available near $_collegeName'
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
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final room = rooms[index];
          return _buildRoomCard(room);
        },
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    String imageUrl = room.roomImages.isNotEmpty
        ? room.roomImages.first.url
        : 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400&h=300&fit=crop';

    // ✅ Distance calculation from college to room
    final String distanceText = _getDistanceFromCollege(
      room.latitude,
      room.longitude,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomViewScreen(
              roomId: room.id,
              collegeId: int.tryParse(widget.collegeId) ?? 0,
              distance: distanceText,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.fill,
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
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
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
                  // ✅ Distance badge on image (bottom-left)
                  if (distanceText.isNotEmpty)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.near_me_rounded,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              distanceText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
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
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (room.roomTypeDisplay != '')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: CollegeColors.primary.withOpacity(0.9),
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
                      Text(
                        room.formattedPrice,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: CollegeColors.primary,
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

  // ==================== TIFFIN GRID ====================

  SliverToBoxAdapter _buildTiffinGrid() {
    final tiffins = _filteredTiffins;

    if (_tiffinController.isLoading.value && tiffins.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
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
                      ? 'No tiffins available near $_collegeName'
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
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final tiffin = tiffins[index];
          return _buildTiffinCard(tiffin);
        },
      ),
    );
  }

  Widget _buildTiffinCard(Tiffin tiffin) {
    String imageUrl = tiffin.hasImages
        ? tiffin.firstImageUrl
        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=300&fit=crop';

    // ✅ Distance calculation from college to tiffin
    final String distanceText = _getDistanceFromCollege(
      tiffin.latitude,
      tiffin.longitude,
    );

    return Card(
      color: Colors.white,
      elevation: 0.3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TiffinViewScreen(
                tiffinId: tiffin.id,
                collegeId: int.tryParse(widget.collegeId) ?? 0,
                distance: distanceText,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
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
                          child: const Center(
                            child: Icon(
                              Icons.food_bank_rounded,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
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
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
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
                    // ✅ Distance badge on image (bottom-left)
                    if (distanceText.isNotEmpty)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.near_me_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                distanceText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
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
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tiffin.formattedPrice,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: CollegeColors.primary,
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

  Color _getTiffinTypeColor(Tiffin tiffin) {
    if (tiffin.isBothVegNonVeg) return Colors.purple;
    if (tiffin.isVegOnly) return Colors.green;
    if (tiffin.isNonVegOnly) return Colors.red;
    return Colors.blue;
  }
}

// Custom SliverPersistentHeaderDelegate for sticky tabs
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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