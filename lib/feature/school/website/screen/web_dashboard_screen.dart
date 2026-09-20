import 'package:flutter/material.dart';
import 'package:untitled/feature/school/website/screen/web_landing_page.dart';

class WebDashboardScreen extends StatelessWidget {
  const WebDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Navbar ──────────────────────────────────────
          SliverAppBar(
            toolbarHeight: 90,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Row(
                  children: [
                    // Logo
                    _LogoWidget(),
                    const Spacer(),
                    // Nav Links
                    _navLink("DEMOS"),
                    _navLink("PAGE LAYOUTS"),
                    _navLink("FEATURES"),
                    _navLink("ONLINE DOCUMENTATION"),
                    const SizedBox(width: 40),
                    // Buy Now Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Landing Page Content ────────────────────────
          const SliverToBoxAdapter(child: WebLandingPage()),
        ],
      ),
    );
  }

  Widget _navLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Logo Widget ─────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Rainbow arc icon
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Rainbow arcs
              Positioned(
                top: 0,
                child: Container(
                  width: 44,
                  height: 22,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF5252),
                        Color(0xFFFFB74D),
                        Color(0xFF4CAF50),
                        Color(0xFF2196F3),
                        Color(0xFF9C27B0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              // Star decorations
              const Positioned(
                top: 2,
                right: 4,
                child: Icon(Icons.star, size: 8, color: Color(0xFFFFD54F)),
              ),
              const Positioned(
                top: 6,
                left: 6,
                child: Icon(Icons.star, size: 6, color: Color(0xFFFFD54F)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "KiDS",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A3D7C),
                height: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3D7C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Cool Theme",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}