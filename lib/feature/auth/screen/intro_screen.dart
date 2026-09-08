import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../../router/app_routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "title": "Welcome to Suwidhaa",
      "subtitle": "Your all-in-one college companion app",
      "description": "Get access to college services, accommodations, and entertainment all in one place.",
      "image": "https://images.unsplash.com/photo-1523050854058-8df90110c7f1?w=600&h=600&fit=crop",
      "color": Colors.blue,
    },
    {
      "title": "Find Your Perfect Stay",
      "subtitle": "Discover the best PG & rooms near your college",
      "description": "Browse through verified PG accommodations, compare prices, and book your stay with ease.",
      "image": "https://images.unsplash.com/photo-1554995207-c18c203602cb?w=600&h=600&fit=crop",
      "color": Colors.orange,
    },
    {
      "title": "College Community & More",
      "subtitle": "Connect, learn, and grow together",
      "description": "Join college events, find study groups, get updates, and enjoy entertainment with friends.",
      "image": "https://images.unsplash.com/photo-1524178232363-1fb2b075b655?w=600&h=600&fit=crop",
      "color": Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Logo and Skip
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        height: 40,width: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/logo/Suwidhaa.png')),
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 8),

                    ],
                  ),
                  // Skip Button
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.auth);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _currentPage == 2
                            ? AppColors.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentPage == 2 ? "Get Started" : "Skip",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _currentPage == 2
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: Container(
                color: Colors.white,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(_pages[index], index);
                  },
                ),
              ),
            ),

            // Bottom Section with Better UX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Dot Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Next/Get Started Button with Better UX
                  Row(
                    children: [
                      // Skip/Back Button (only show on page > 0)
                      if (_currentPage > 0)
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Row(
                                  spacing: 6,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      size: 22,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Back",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      if (_currentPage > 0) const SizedBox(width: 12),

                      // Next/Get Started Button
                      Expanded(
                        flex: _currentPage > 0 ? 2 : 1,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage == _pages.length - 1) {
                                Get.offAllNamed(AppRoutes.auth);
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _pages.length - 1
                                      ? "Get Started"
                                      : "Next",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: _currentPage == _pages.length - 1
                                      ? const Icon(
                                    Icons.check_circle_rounded,
                                    size: 20,
                                  )
                                      : const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildPageContent(Map<String, dynamic> pageData, int index) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:0, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Banner Image Container
          Expanded(
            child: Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  pageData['image'],
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: (pageData["color"] as Color).withOpacity(0.1),
                        // borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          color: pageData["color"],
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: (pageData["color"] as Color).withOpacity(0.1),
                        // borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        size: 60,
                        color: pageData["color"],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            pageData["title"],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle with colored container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: (pageData["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pageData["subtitle"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: pageData["color"],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            pageData["description"],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Feature Highlights (only on last page)
          if (_currentPage == 2)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildFeatureChip(Icons.event_rounded, "College Events"),
                _buildFeatureChip(Icons.group_rounded, "Study Groups"),
                _buildFeatureChip(Icons.music_note_rounded, "Entertainment"),
                _buildFeatureChip(Icons.emoji_events_rounded, "Competitions"),
              ],
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}