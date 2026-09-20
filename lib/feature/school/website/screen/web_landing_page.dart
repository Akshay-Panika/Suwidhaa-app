import 'package:flutter/material.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Hero Section ──────────────────────────────
        Container(
          width: double.infinity,
          height: 620, // ✅ 700 → 520
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE91E63),
                Color(0xFFFF4081),
                Color(0xFFEC407A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background overlay
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white24, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.only(
                  top: 50, // ✅ 80 → 50
                  left: 40, // ✅ 60 → 40
                  right: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Heading
                    const Text(
                      "Powerful kids Education\nWordPress Theme",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38, // ✅ 56 → 38
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16), // ✅ 24 → 16
                    // Subtitle
                    const Text(
                      "UltraHigh Performance, Intuitive Editor\nAnd Exclusive Features.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, // ✅ 22 → 16
                        color: Colors.white,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 36), // ✅ 60 → 36

                    // ── Screenshot Mockups ────────────────
                    SizedBox(
                      height: 280, // ✅ 380 → 280
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Left mockup
                          Positioned(
                            left: 20,
                            top: 25,
                            child: _MockupCard(
                              width: 220, // ✅ 320 → 220
                              height: 230, // ✅ 320 → 230
                              rotation: -0.05,
                              color: const Color(0xFFFFF3E0),
                            ),
                          ),

                          // Right mockup
                          Positioned(
                            right: 20,
                            top: 25,
                            child: _MockupCard(
                              width: 220,
                              height: 230,
                              rotation: 0.05,
                              color: const Color(0xFFFFEBEE),
                            ),
                          ),

                          // Center mockup
                          Positioned(
                            top: 0,
                            child: _MockupCard(
                              width: 360, // ✅ 480 → 360
                              height: 280, // ✅ 380 → 280
                              rotation: 0,
                              color: Colors.white,
                              isCenter: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Mockup Card Widget ──────────────────────────────────
class _MockupCard extends StatelessWidget {
  final double width;
  final double height;
  final double rotation;
  final Color color;
  final bool isCenter;

  const _MockupCard({
    required this.width,
    required this.height,
    required this.rotation,
    required this.color,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 30, // ✅ 40 → 30
              offset: const Offset(0, 15), // ✅ 20 → 15
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              // Fake browser top bar
              Container(
                height: 22, // ✅ 30 → 22
                color: const Color(0xFFE0E0E0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    _dot(const Color(0xFFFF5F57), 7),
                    const SizedBox(width: 4),
                    _dot(const Color(0xFFFFBD2E), 7),
                    const SizedBox(width: 4),
                    _dot(const Color(0xFF28C840), 7),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  color: color,
                  padding: const EdgeInsets.all(14), // ✅ 20 → 14
                  child: isCenter
                      ? _centerMockupContent()
                      : _sideMockupContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color c, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );

  // Center mockup content
  Widget _centerMockupContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _letter("K", const Color(0xFF2196F3)),
            _letter("I", const Color(0xFF9C27B0)),
            _letter("D", const Color(0xFFFF9800)),
            _letter("S", const Color(0xFFF44336)),
          ],
        ),
        const SizedBox(height: 10), // ✅ 16 → 10
        const Text(
          "A Perfect Place To Explore Your\nKid's Talent",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11, // ✅ 14 → 11
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3D7C),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8), // ✅ 12 → 8
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            "Learn More",
            style: TextStyle(
              color: Colors.white,
              fontSize: 9, // ✅ 11 → 9
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 14), // ✅ 20 → 14
        // Stat row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statItem("20+", "Years"),
            _statItem("1000+", "Students"),
            _statItem("100+", "Teachers"),
            _statItem("500+", "Awards"),
          ],
        ),
      ],
    );
  }

  Widget _letter(String char, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2), // ✅ 3 → 2
      child: Text(
        char,
        style: TextStyle(
          fontSize: 32, // ✅ 48 → 32
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Container(
          width: 20, // ✅ 28 → 20
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, size: 11, color: Color(0xFFE91E63)),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 9, // ✅ 11 → 9
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3D7C),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 7, color: Colors.black54), // ✅ 8 → 7
        ),
      ],
    );
  }

  // Side mockup content
  Widget _sideMockupContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 55, // ✅ 80 → 55
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              "20%\nFlat Off\nOn Registration",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10, // ✅ 14 → 10
                height: 1.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10), // ✅ 16 → 10
        Container(height: 6, width: 80, color: Colors.grey[300]),
        const SizedBox(height: 6),
        Container(height: 6, width: 120, color: Colors.grey[200]),
        const SizedBox(height: 6),
        Container(height: 6, width: 100, color: Colors.grey[200]),
        const Spacer(),
        Row(
          children: [
            Container(
              width: 28, // ✅ 40 → 28
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE91E63),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 6, width: 55, color: Colors.grey[400]),
                const SizedBox(height: 4),
                Container(height: 5, width: 40, color: Colors.grey[300]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}