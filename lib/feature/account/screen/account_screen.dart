import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController authController = Get.find<AuthController>();

  String _getInitials() {
    final name = authController.getUserName.trim();
    if (name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return (parts[0][0] + parts[1][0]).toUpperCase();
      }
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }
    // Fallback: last 2 digits of phone
    final phone = authController.getUserPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.length >= 2) {
      return phone.substring(phone.length - 2);
    }
    return 'U';
  }

  String _getDisplayName() {
    final name = authController.getUserName.trim();
    return name.isEmpty ? 'Suwidhaa User' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildProfileHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// General Settings
                  _buildSection(
                    title: "Account",
                    children: [
                      _buildTile(
                        Icons.person_outline_rounded,
                        "Edit Profile",
                        onTap: () => null,
                      ),
                      _buildTile(
                        Icons.receipt_long_rounded,
                        "My Bookings",
                        onTap: () {
                          // TODO: navigate to bookings
                        },
                      ),
                    ],
                  ),

                  /// Support & Legal
                  _buildSection(
                    title: "Support & Legal",
                    children: [
                      _buildTile(
                        Icons.help_outline_rounded,
                        "Help Center",
                        onTap: () {},
                      ),
                      _buildTile(
                        Icons.shield_rounded,
                        "Privacy Policy",
                        onTap: () {},
                      ),
                      _buildTile(
                        Icons.description_outlined,
                        "Terms of Service",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Logout
                  _buildLogoutButton(),

                  const SizedBox(height: 12),

                  /// Delete Account
                  _buildDeleteButton(context),

                  const SizedBox(height: 24),

                  /// App version (Fixed: removed unnecessary Obx)
                  Text(
                    'Suwidhaa • v1.0.0',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PROFILE HEADER ====================
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 26, right: 26, top: 26, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Obx(
                          () => Text(
                        _getInitials(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                        () => Text(
                      _getDisplayName(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                        () => Text(
                      authController.getUserPhone.isEmpty
                          ? '+91 —'
                          : authController.getUserPhone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Active",
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Color(0xFF6366F1),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION ====================
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // ==================== TILE ====================
  Widget _buildTile(
      IconData icon,
      String title, {
        String? trailing,
        Color? color,
        VoidCallback? onTap,
        bool isDestructive = false,
      }) {
    final Color tileColor =
    isDestructive ? Colors.red : (color ?? const Color(0xFF6366F1));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: tileColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: tileColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? Colors.red
                          : const Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing,
                    style: TextStyle(
                      color: tileColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                if (trailing == null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey[400],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== LOGOUT BUTTON ====================
  Widget _buildLogoutButton() {
    return Obx(() {
      final loading = authController.isLoading.value;
      return _buildActionButton(
        icon: Icons.logout_rounded,
        label: 'Logout',
        onTap: loading ? null : () => _showLogoutDialog(),
      );
    });
  }

  // ==================== DELETE BUTTON ====================
  Widget _buildDeleteButton(BuildContext context) {
    return Obx(() {
      final loading = authController.isLoading.value;
      return _buildActionButton(
        icon: Icons.delete_outline_rounded,
        label: 'Delete Account',
        onTap: loading ? null : () => _showDeleteDialog(context),
        isDestructive: true,
      );
    });
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isDestructive ? Colors.red : Colors.red,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                authController.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Account'),
          content: const Text(
            'This will permanently delete your account and all associated data. This action cannot be undone.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                authController.deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}