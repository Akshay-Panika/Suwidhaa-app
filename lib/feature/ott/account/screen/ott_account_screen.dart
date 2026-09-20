import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../auth/controller/auth_controller.dart';
import '../widget/my_watchlist_content_card.dart';

class OttAccountScreen extends StatefulWidget {
  const OttAccountScreen({super.key});

  @override
  State<OttAccountScreen> createState() => _OttAccountScreenState();
}

class _OttAccountScreenState extends State<OttAccountScreen> {
  final AuthController authController = Get.find<AuthController>();

  bool _isSetting = false;
  bool _parentalControls = false;

  late Timer _timer;
  int _totalSeconds = 2 * 3600 + 55 * 60 + 50;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalSeconds > 0) {
        setState(() {
          _totalSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Account',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody() {
    int hours = _totalSeconds ~/ 3600;
    int minutes = (_totalSeconds % 3600) ~/ 60;
    int seconds = _totalSeconds % 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 20,
        children: [
          _buildProfileCard(
            onPressed: () {
              setState(() {
                _isSetting = !_isSetting;
              });
            },
            icon: _isSetting ? Icons.close : Icons.settings,
          ),

          // Conditional UI: Settings List or Main Content
          _isSetting ? _buildSettingsView() : Column(
            spacing: 10,
            children: [
              Container(
                height: 170,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/ott/ott_subcri_img.png"), fit: BoxFit.fill)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Spacial Prise", style: TextStyle(color: Colors.white)),
                            Row(
                              spacing: 10,
                              children: const [
                                Text("₹ 199", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                Text("/1 Months", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const Text("Original Prise ₹ 499", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Countdown to the offer", style: TextStyle(color: Colors.white, fontSize: 12)),
                                Row(
                                  children: [
                                    Card(child: Padding(padding: const EdgeInsets.all(4), child: Text(_formatDigits(hours)))),
                                    Card(child: Padding(padding: const EdgeInsets.all(4), child: Text(_formatDigits(minutes)))),
                                    Card(child: Padding(padding: const EdgeInsets.all(4), child: Text(_formatDigits(seconds)))),
                                  ],
                                )
                              ],
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Text("Get", style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Container(color: Colors.red, height: 14, width: 3),
                  const Text(
                    'My Watchlist',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              MyWatchlistContentCard(),
              Row(
                spacing: 10,
                children: [
                  Container(color: Colors.red, height: 14, width: 3),
                  const Text(
                    'My Favorite',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              MyWatchlistContentCard(),
            ],
          )
        ],
      ),
    );
  }

  // Settings View Widget matching your reference image
  Widget _buildSettingsView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parental Controls Switch Tile
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Parental Controls', style: TextStyle(color: Colors.white, fontSize: 16)),
            value: _parentalControls,
            activeColor: Colors.red,
            onChanged: (val) {
              setState(() {
                _parentalControls = val;
              });
            },
          ),

          // Device Authorization Center
          _buildSettingItem(
            title: 'Device Authorization Center',
            onTap: () {},
          ),

          const SizedBox(height: 10),
          const Text('App', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),

          // Share App
          _buildSettingItem(
            title: 'Share App',
            onTap: () {},
          ),

          // App Language
          _buildSettingItem(
            title: 'App Language',
            trailingText: 'English',
            onTap: () {},
          ),

          // Download App for TV
          _buildSettingItem(
            title: 'Download App for TV',
            onTap: () {},
          ),

          // Clear Cache
          _buildSettingItem(
            title: 'Clear Cache',
            trailingText: '16.09MB',
            onTap: () {},
          ),

          // Version Update
          _buildSettingItem(
            title: 'Version Update',
            trailingText: '2.1.2(IndiaA)',
            onTap: () {},
          ),

          const SizedBox(height: 10),
          const Text('Support & About', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 5),

          // Contact Us
          _buildSettingItem(
            title: 'Contact Us',
            onTap: () {},
          ),

          // Help Center
          _buildSettingItem(
            title: 'Help Center',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Reusable List Tile for Settings
  Widget _buildSettingItem({required String title, String? trailingText, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
          if (trailingText != null) const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildProfileCard({required void Function()? onPressed, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/seed/user/200/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authController.getUserName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  authController.getUserPhone,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}