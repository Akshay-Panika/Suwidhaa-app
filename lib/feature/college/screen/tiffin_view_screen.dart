// lib/feature/college/screen/tiffin_view_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/contact_helper.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/college_booking_controller.dart';
import '../controller/tiffin_controller.dart';   // ✅ ADD
import '../model/college_booking_model.dart';
import '../model/tiffin_model.dart';

class TiffinViewScreen extends StatefulWidget {
  final int tiffinId;
  final int collegeId;

  const TiffinViewScreen({
    super.key,
    required this.tiffinId,
    required this.collegeId,
  });

  @override
  State<TiffinViewScreen> createState() => _TiffinViewScreenState();
}

class _TiffinViewScreenState extends State<TiffinViewScreen> {
  int _selectedImageIndex = 0;

  final CollegeBookingController _bookingController =
  Get.find<CollegeBookingController>();
  final AuthController authController = Get.find<AuthController>();
  final TiffinController _tiffinController = Get.find<TiffinController>();   // ✅ ADD

  bool _isBooking = false;

  // ✅ Local tiffin state
  Tiffin? _tiffin;
  bool _isLoadingTiffin = true;
  String _tiffinError = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchTiffin();
    });
  }

  // ✅ Tiffin fetch — user-wise booking ke saath
  Future<void> _fetchTiffin() async {
    setState(() {
      _isLoadingTiffin = true;
      _tiffinError = '';
    });

    try {
      final userId = authController.getUserId > 0
          ? authController.getUserId.toString()
          : null;

      print('🔍 Fetching tiffin: ${widget.tiffinId}, userId: $userId');

      final tiffin = await _tiffinController.fetchTiffinByIdWithUserId(
        tiffinId: widget.tiffinId,
        userId: userId,
      );

      if (tiffin != null && mounted) {
        setState(() {
          _tiffin = tiffin;
          _isLoadingTiffin = false;
        });

        print('✅ Tiffin loaded: id=${tiffin.id}, booking=${tiffin.booking}');
      } else {
        if (mounted) {
          setState(() {
            _tiffinError = 'Tiffin not found';
            _isLoadingTiffin = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tiffinError = e.toString();
          _isLoadingTiffin = false;
        });
      }
      print('❌ Error fetching tiffin: $e');
    }
  }

  // ==================== GALLERY ====================

  List<String> get _galleryImages {
    if (_tiffin!.tiffinImages.isNotEmpty) {
      return _tiffin!.tiffinImages.map((image) => image.url).toList();
    }
    return [
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&h=500&fit=crop',
    ];
  }

  String get _shareMessage {
    final buffer = StringBuffer();
    buffer.writeln('🍱 *${_tiffin!.title}*');
    buffer.writeln();
    buffer.writeln('💰 *Price:* ${_tiffin!.formattedPrice}');
    buffer.writeln('🏷️ *Type:* ${_tiffin!.tiffinType}');
    buffer.writeln('📊 *Status:* ${_tiffin!.availabilityStatus}');
    if (_tiffin!.nearCollege != null && _tiffin!.nearCollege!.isNotEmpty) {
      buffer.writeln('🏫 *Near:* ${_tiffin!.nearCollege}');
    }
    if (_tiffin!.hasContact) {
      buffer.writeln();
      buffer.writeln('📞 *Contact:* ${_tiffin!.contactDisplay}');
    }
    buffer.writeln();
    buffer.writeln('📝 *Description:*');
    buffer.writeln(_tiffin!.description.isNotEmpty
        ? _tiffin!.description
        : 'Delicious tiffin service available');
    buffer.writeln();
    buffer.writeln('🔗 *Shared from Suwidhaa App*');
    return buffer.toString();
  }

  // ==================== BOOKING ====================

  Future<void> _onTiffinEnquiryTap() async {
    setState(() => _isBooking = true);

    try {
      final BookingTiffin bookingTiffin = BookingTiffin(
        tiffinId: _tiffin!.id,
        tiffinName: _tiffin!.title,
        tiffinType: _tiffin!.tiffinType,
        tiffinAmount: _tiffin!.price,
      );

      final String message = 'Hi Suwidhaa:\n'
          'Name: ${authController.getUserName}\n'
          'Phone: ${authController.getUserPhone}\n'
          'I am interested in this tiffin:\n'
          'Tiffin: ${_tiffin!.title}\n'
          'Type: ${_tiffin!.tiffinType}\n'
          'Price: ${_tiffin!.formattedPrice}';

      final bool success = await _bookingController.bookCollege(
        collegeId: widget.collegeId,
        message: message,
        tiffin: bookingTiffin,
      );

      if (!mounted) return;
      setState(() => _isBooking = false);

      if (success) {
        print('✅ Tiffin enquiry success');

        // ✅ Fresh data fetch karo — booking: true hoga
        await _fetchTiffin();
      }
    } catch (e) {
      if (mounted) setState(() => _isBooking = false);
      print('❌ _onTiffinEnquiryTap error: $e');
    }
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    // ---- Loading ----
    if (_isLoadingTiffin) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
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

    // ---- Error ----
    if (_tiffinError.isNotEmpty || _tiffin == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text(
            'Tiffin',
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
              Text(_tiffinError.isNotEmpty ? _tiffinError : 'Tiffin not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTiffin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ---- Success ----
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          _tiffin!.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareTiffinDetails,
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
                  // ---- Image ----
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
                              Icons.food_bank_rounded,
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
                      // Tiffin Type badge
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getTiffinTypeColor(_tiffin!),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            _tiffin!.tiffinType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      // Status badge — booking priority
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: _tiffin!.booking
                                ? Colors.green
                                : _tiffin!.isBooking
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            _tiffin!.booking
                                ? 'Booked'
                                : _tiffin!.isBooking
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
                    ],
                  ),

                  // ---- Details ----
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _tiffin!.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _tiffin!.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
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

                        // Near college
                        if (_tiffin!.nearCollege != null &&
                            _tiffin!.nearCollege!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.school_rounded,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Near: ${_tiffin!.nearCollege}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        // Contact
                        if (_tiffin!.hasContact) ...[
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.phone_rounded,
                                    color: AppColors.primary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _tiffin!.contactDisplay,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ContactHelper.call(_tiffin!.contactNumber!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    minimumSize: const Size(0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                                      _tiffin!.contactNumber!,
                                      "Hi, I'm interested in ${_tiffin!.title}",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    minimumSize: const Size(0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                        ],

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Description
                        const Text(
                          "About this Tiffin",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _tiffin!.description.isNotEmpty
                              ? _tiffin!.description
                              : "Delicious tiffin service available with fresh home-cooked meals.",
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

          // ---- Bottom Enquiry Button ----
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (!_tiffin!.booking &&
                        !_tiffin!.isBooking &&
                        !_isBooking)
                        ? _onTiffinEnquiryTap
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      (_tiffin!.booking || _tiffin!.isBooking || _isBooking)
                          ? Colors.grey
                          : AppColors.primary,
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
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text(
                      _tiffin!.booking
                          ? "Booked"
                          : _tiffin!.isBooking
                          ? "Unavailable"
                          : "Tiffin Enquiry",
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

  Color _getTiffinTypeColor(Tiffin tiffin) {
    if (tiffin.isBothVegNonVeg) return Colors.purple;
    if (tiffin.isVegOnly) return Colors.green;
    if (tiffin.isNonVegOnly) return Colors.red;
    return Colors.blue;
  }

  void _shareTiffinDetails() {
    final String message = _shareMessage;
    if (_tiffin!.hasContact) {
      ContactHelper.whatsapp(_tiffin!.contactNumber!, message);
    } else {
      ContactHelper.whatsapp('', message);
    }
  }
}