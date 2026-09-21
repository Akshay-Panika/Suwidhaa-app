// lib/feature/college/screen/room_view_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/contact_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/college_booking_controller.dart';
import '../controller/room_controller.dart';
import '../model/college_booking_model.dart';
import '../model/room_model.dart';

class RoomViewScreen extends StatefulWidget {
  final int roomId;
  final int collegeId;
  final String distance;

  const RoomViewScreen({
    super.key,
    required this.roomId,
    required this.collegeId, required this.distance,
  });

  @override
  State<RoomViewScreen> createState() => _RoomViewScreenState();
}

class _RoomViewScreenState extends State<RoomViewScreen> {
  int _selectedImageIndex = 0;

  // ✅ Controllers
  final CollegeBookingController _bookingController =
  Get.find<CollegeBookingController>();
  final AuthController authController = Get.find<AuthController>();
  final RoomController _roomController = Get.find<RoomController>();

  bool _isBooking = false;

  // ✅ Room state — fresh fetch ke baad set hoga
  Room? _room;
  bool _isLoadingRoom = true;
  String _roomError = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchRoom();
    });
  }

  // ✅ Room fetch karo user-wise
  Future<void> _fetchRoom() async {
    setState(() {
      _isLoadingRoom = true;
      _roomError = '';
    });

    try {
      final userId = authController.getUserId > 0
          ? authController.getUserId.toString()
          : null;

      print('🔍 Fetching room: ${widget.roomId}, userId: $userId');

      // ✅ Nayi API use karo
      final room = await _roomController.fetchRoomByIdWithUserId(
        roomId: widget.roomId,
        userId: userId,
      );

      if (room != null && mounted) {
        setState(() {
          _room = room;
          _isLoadingRoom = false;
        });

        print('✅ Room loaded: id=${room.id}, booking=${room.booking}');
      } else {
        if (mounted) {
          setState(() {
            _roomError = 'Room not found';
            _isLoadingRoom = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _roomError = e.toString();
          _isLoadingRoom = false;
        });
      }
      print('❌ Error fetching room: $e');
    }
  }

  // ==================== GALLERY ====================

  List<String> get _galleryImages {
    if (_room!.roomImages.isNotEmpty) {
      return _room!.roomImages.map((image) => image.url).toList();
    }
    return [
      "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&h=500&fit=crop",
      "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&h=500&fit=crop",
    ];
  }

  String get _shareMessage {
    final buffer = StringBuffer();
    buffer.writeln('🏠 *${_room!.title}*');
    buffer.writeln();
    buffer.writeln('📍 *Location:* ${_room!.address}');
    if (_room!.nearCollege != null && _room!.nearCollege!.isNotEmpty) {
      buffer.writeln('🏫 *Near:* ${_room!.nearCollege}');
    }
    buffer.writeln('💰 *Price:* ${_room!.formattedPrice}');
    buffer.writeln('🏷️ *Room Type:* ${_room!.roomTypeDisplay}');
    buffer.writeln('📊 *Status:* ${_room!.availabilityStatus}');

    if (_room!.amenityCount > 0) {
      buffer.writeln();
      buffer.writeln('✅ *Amenities:*');
      for (var amenity in _room!.amenities) {
        buffer.writeln('   • $amenity');
      }
    }

    if (_room!.hasContact) {
      buffer.writeln();
      buffer.writeln('📞 *Contact:* ${_room!.contactDisplay}');
    }

    buffer.writeln();
    buffer.writeln('📝 *Description:*');
    buffer.writeln(_room!.description.isNotEmpty
        ? _room!.description
        : 'This ${_room!.roomTypeDisplay} room is located in a prime location with easy access to college and local amenities.');

    buffer.writeln();
    buffer.writeln('🔗 *Shared from Suwidhaa App*');

    return buffer.toString();
  }

  // ==================== BOOKING API CALL ====================

  Future<void> _bookRoomWithCollege() async {
    setState(() => _isBooking = true);

    try {
      final BookingRoom bookingRoom = BookingRoom(
        roomId: _room!.id,
        roomName: _room!.title,
        roomType: _room!.roomTypeDisplay,
        roomAmount: _room!.price,
      );

      final String message = 'Hi Suwidhaa:\n'
          'Name: ${authController.getUserName}\n'
          'Phone: ${authController.getUserPhone}\n'
          'I am interested in this room:\n'
          'Room: ${_room!.title}\n'
          'Type: ${_room!.roomTypeDisplay}\n'
          'Price: ${_room!.formattedPrice}';

      final bool success = await _bookingController.bookCollege(
        collegeId: widget.collegeId,
        message: message,
        room: bookingRoom,
      );

      if (!mounted) return;

      setState(() => _isBooking = false);

      if (success) {
        print('✅ Room booking success');

        // ✅ Fresh room data fetch karo
        await _fetchRoom();

        // ✅ Room list bhi refresh karo
        final userId = authController.getUserId > 0
            ? authController.getUserId.toString()
            : null;

        await _roomController.fetchAllRooms(
          userId: userId,
          nearCollege: _room!.nearCollege,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isBooking = false);
      print('❌ _bookRoomWithCollege error: $e');
    }
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    // ✅ Loading
    if (_isLoadingRoom) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: CollegeColors.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Error
    if (_roomError.isNotEmpty || _room == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: CollegeColors.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text(
            'Room',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(_roomError.isNotEmpty ? _roomError : 'Room not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CollegeColors.primary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Success
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: CollegeColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          _room!.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareRoomDetails,
            icon: const Icon(Icons.share_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Image Gallery ----
                  Stack(
                    children: [
                      Image.network(
                        _galleryImages[_selectedImageIndex],
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 280,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 280,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.bed_rounded,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
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
                      // Arrows
                      if (_galleryImages.length > 1) ...[
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
                                      _galleryImages.length) %
                                      _galleryImages.length;
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
                                  _selectedImageIndex =
                                      (_selectedImageIndex + 1) %
                                          _galleryImages.length;
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
                      // Counter
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
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
                      // Status Badge
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _room!.booking
                                ? Colors.green
                                : _room!.isBooking
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            _room!.booking
                                ? 'Booked'
                                : _room!.isBooking
                                ? 'Unavailable'
                                : 'Available',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      // Room Type
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: CollegeColors.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            _room!.roomTypeDisplay,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      // Dots
                      if (_galleryImages.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _galleryImages.length,
                                  (index) => Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 4),
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

                  // ---- Thumbnail Gallery ----
                  if (_galleryImages.length > 1)
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
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
                              width: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedImageIndex == index
                                      ? CollegeColors.primary
                                      : Colors.transparent,
                                  width: 1.8,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  _galleryImages[index],
                                  width: 60,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 20,
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

                  // ---- Details Container ----
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _room!.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                                      child: Text(
                                        widget.distance,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded,
                                          size: 14,
                                          color: Colors.grey.shade600),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          _room!.address,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_room!.nearCollege != null &&
                                      _room!.nearCollege!.isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(Icons.school_rounded,
                                            size: 12,
                                            color: CollegeColors.primary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Near: ${_room!.nearCollege}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: CollegeColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _room!.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: CollegeColors.primary,
                                  ),
                                ),
                                Text(
                                  "Per Month",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Amenities
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text(
                          "Amenities",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildAllAmenitiesGrid(),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Contact Info
                        if (_room!.hasContact) ...[
                          const Text(
                            "Contact Information",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.phone_rounded,
                                    color: CollegeColors.primary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _room!.contactDisplay,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ContactHelper.call(_room!.contactNumber!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CollegeColors.secondary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    minimumSize: const Size(0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Call",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    ContactHelper.whatsapp(
                                      _room!.contactNumber!,
                                      "Hi, I'm interested in ${_room!.title}",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CollegeColors.secondary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    minimumSize: const Size(0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "WhatsApp",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                        ],

                        // Description
                        const Text(
                          "About this Room",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _room!.description.isNotEmpty
                              ? _room!.description
                              : "This ${_room!.roomTypeDisplay} room is located in a prime location with easy access to college and local amenities. The room is well-furnished and maintained with all modern facilities.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- Bottom Book Now Button ----
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (!_room!.booking &&
                        !_room!.isBooking &&
                        !_isBooking)
                        ? () => _showBookingDialog(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      (_room!.booking || _room!.isBooking || _isBooking)
                          ? Colors.grey
                          : CollegeColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isBooking
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                    )
                        : Text(
                      _room!.booking
                          ? "Booked"
                          : _room!.isBooking
                          ? "Unavailable"
                          : "Book Now - ${_room!.formattedPrice}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "✓ Free cancellation • ✓ Secure booking",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== AMENITIES GRID ====================

  Widget _buildAllAmenitiesGrid() {
    final allAmenities = [
      {'key': 'wifi', 'label': 'WiFi', 'icon': Icons.wifi},
      {'key': 'ac', 'label': 'AC', 'icon': Icons.ac_unit},
      {'key': 'parking', 'label': 'Parking', 'icon': Icons.local_parking},
      {'key': 'security', 'label': 'Security', 'icon': Icons.security},
      {
        'key': 'laundry',
        'label': 'Laundry',
        'icon': Icons.local_laundry_service
      },
      {'key': 'water', 'label': 'Water', 'icon': Icons.water_drop},
    ];

    final availableAmenities =
    _room!.amenities.map((e) => e.toLowerCase()).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allAmenities.map((amenity) {
        final isAvailable = availableAmenities.contains(amenity['key']);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isAvailable
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isAvailable ? Colors.green : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                amenity['icon'] as IconData,
                size: 14,
                color: isAvailable ? Colors.green : Colors.grey.shade400,
              ),
              const SizedBox(width: 4),
              Text(
                amenity['label'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: isAvailable
                      ? Colors.green.shade700
                      : Colors.grey.shade500,
                  fontWeight:
                  isAvailable ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isAvailable) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==================== SHARE ====================

  void _shareRoomDetails() {
    final String message = _shareMessage;

    if (_room!.hasContact) {
      ContactHelper.whatsapp(_room!.contactNumber!, message);
    } else {
      ContactHelper.whatsapp('', message);
    }
  }

  // ==================== BOOKING DIALOG ====================

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Confirm Booking",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _room!.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rent",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          _room!.formattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CollegeColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Room Type",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          _room!.roomTypeDisplay,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _room!.formattedPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _bookRoomWithCollege();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CollegeColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}