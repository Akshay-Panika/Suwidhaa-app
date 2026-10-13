import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';

import '../../../../core/utils/app_color.dart';
import '../controller/it_service_controller.dart';
import '../model/it_service_model.dart';

class ItServiceDetailsScreen extends StatefulWidget {
  final int serviceId;

  const ItServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<ItServiceDetailsScreen> createState() => _ItServiceDetailsScreenState();
}

class _ItServiceDetailsScreenState extends State<ItServiceDetailsScreen> {
  final _scrollController = ScrollController();

  bool _isFavorite = false;
  bool _isLoading = false;
  bool _isFetching = true;
  String? _fetchError;

  ItServiceData? _service;

  final List<Map<String, dynamic>> _projectFeatures = [
    {
      'icon': Icons.code_rounded,
      'label': 'Custom Development',
      'color': AppColors.itServices
    },
    {
      'icon': Icons.verified_rounded,
      'label': 'Quality Assurance',
      'color': AppColors.success
    },
    {
      'icon': Icons.timeline_rounded,
      'label': 'Timely Delivery',
      'color': AppColors.primary
    },
    {
      'icon': Icons.support_agent_rounded,
      'label': '24/7 Support',
      'color': AppColors.school
    },
    {
      'icon': Icons.source_rounded,
      'label': 'Source Code',
      'color': AppColors.ott
    },
    {
      'icon': Icons.security_rounded,
      'label': 'Data Security',
      'color': AppColors.ngo
    },
    {
      'icon': Icons.sync_rounded,
      'label': 'Regular Updates',
      'color': AppColors.accent
    },
    {
      'icon': Icons.people_rounded,
      'label': 'Dedicated Team',
      'color': AppColors.ecommerce
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchService();
  }

  Future<void> _fetchService() async {
    setState(() {
      _isFetching = true;
      _fetchError = null;
    });

    try {
      final ctrl = Get.find<ItServiceController>();
      final fresh = await ctrl.getServiceById(widget.serviceId);

      if (!mounted) return;

      if (fresh == null) {
        setState(() {
          _isFetching = false;
          _fetchError = 'Service not found';
        });
        return;
      }

      setState(() {
        _service = fresh;
        _isFetching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFetching = false;
        _fetchError = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ===== SEND ENQUIRY HANDLER =====
  Future<void> _onSendEnquiryPressed() async {
    FocusScope.of(context).unfocus();

    final service = _service;
    if (service == null) return;

    setState(() => _isLoading = true);

    final ctrl = Get.find<ItServiceController>();
    final ok = await ctrl.createBooking(service.id);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      // ✅ Flip the local flag so the UI reflects "Booked"
      setState(() {
        _service = _service?.copyWith(isBooked: true);
      });
      _showEnquirySuccessDialog();
    } else {
      // ❌ Show error
      final msg = ctrl.errorMessage.value.isEmpty
          ? 'Failed to create booking'
          : ctrl.errorMessage.value;
      FlutterToast.error(msg);
    }
  }


  // ===== ENQUIRY SUCCESS DIALOG =====
  void _showEnquirySuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Enquiry Sent!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Thank you! Our team will contact you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.itServices,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Great!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ===== LOADING STATE =====
    if (_isFetching) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.itServices,
          title: const Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          leading: _buildCircleIconButton(
            color: Colors.white,
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.itServices),
        ),
      );
    }

    // ===== ERROR STATE =====
    if (_fetchError != null || _service == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.itServices,
          title: const Text(
            'Error',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          leading: _buildCircleIconButton(
            color: Colors.white,
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  _fetchError ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.itServices,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final service = _service!;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(),
      appBar: AppBar(
        backgroundColor: AppColors.itServices,
        title: Text(
          service.title
              .replaceAll(RegExp(r'["""\u201C\u201D]'), '')
              .trim(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            letterSpacing: -0.2,
          ),
        ),
        leading: _buildCircleIconButton(
          color: Colors.white,
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HERO IMAGE =====
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    service.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.background,
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        size: 60,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.5, 1.0],
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                  if (service.category != null)
                    Positioned(
                      left: 16,
                      bottom: 20,
                      child: _buildHeroChip(
                        service.category!.name,
                        service.category!.image,
                      ),
                    ),
                  // 🆕 Booked ribbon — top-right
                  if (service.isBooked)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Booked',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ===== MAIN CONTENT =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title
                        .replaceAll(RegExp(r'["""\u201C\u201D]'), '')
                        .trim(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${service.price}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.itServices,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (service.oldPrice.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '₹${service.oldPrice}',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _quickStat(
                            Icons.timer_outlined, 'Timeline', '1-2 wks'),
                        _divider(),
                        _quickStat(Icons.star_rounded, 'Rating', '4.9'),
                        _divider(),
                        _quickStat(
                            Icons.verified_rounded, 'Projects', '250+'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  _sectionTitle('About this service',
                      icon: Icons.description_outlined),
                  const SizedBox(height: 12),
                  Text(
                    service.description.isEmpty
                        ? 'No description available.'
                        : service.description,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.textSecondary,
                      height: 1.7,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (service.techStack.isNotEmpty) ...[
                    _sectionTitle('Technology Stack',
                        icon: Icons.memory_rounded),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: service.techStack.map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.itServices.withOpacity(0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.itServices,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tech,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                  ],

                  _sectionTitle('What\'s included',
                      icon: Icons.auto_awesome),
                  const SizedBox(height: 6),
                  const Text(
                    'Everything you get with this project',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _projectFeatures.length,
                    itemBuilder: (context, index) {
                      final feature = _projectFeatures[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: feature['color'].withOpacity(0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: feature['color'].withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                feature['icon'],
                                size: 20,
                                color: feature['color'],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature['label'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMain,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== CIRCLE ICON BUTTON =====
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.textMain,
  }) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: color),
      ),
    );
  }

  // ===== HERO CATEGORY CHIP =====
  Widget _buildHeroChip(String name, String image) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image.isNotEmpty)
            ClipOval(
              child: Image.network(
                image,
                width: 18,
                height: 18,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (image.isNotEmpty) const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ===== FIXED BOTTOM CTA BAR =====
  Widget _buildBottomBar() {
    final isBooked = _service?.isBooked ?? false;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isBooked || _isLoading || _service == null)
                ? null
                : _onSendEnquiryPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.itServices,
              foregroundColor: AppColors.white,
              disabledBackgroundColor:
              AppColors.itServices.withOpacity(0.4),
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBooked
                      ? Icons.check_circle_rounded
                      : Icons.send_rounded,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isBooked ? 'Already Booked' : 'Send Enquiry',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== SECTION TITLE =====
  Widget _sectionTitle(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.itServices.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.itServices),
          ),
          const SizedBox(width: 10),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textMain,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ===== QUICK STAT =====
  Widget _quickStat(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.itServices),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.textSecondary.withOpacity(0.15),
    );
  }
}