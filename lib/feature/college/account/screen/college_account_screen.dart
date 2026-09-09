import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_color.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/room_controller.dart';
import '../../controller/tiffin_controller.dart';
import '../../model/room_model.dart';
import '../../model/tiffin_model.dart';
import '../../screen/add_room_tiffin_senter_screen.dart';

class CollegeAccountScreen extends StatelessWidget {
  CollegeAccountScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final RoomController roomController = Get.put(RoomController());
  final TiffinController tiffinController = Get.put(TiffinController());

  late final int userId = authController.getUserId;
  late final String userName = authController.getUserName;
  late final String userPhone = authController.getUserPhone;

  @override
  Widget build(BuildContext context) {
    // Fetch data for logged-in user
    roomController.fetchRoomsByUserId(userId.toString());
    tiffinController.fetchTiffinsByUserId(userId.toString());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ============================================================
          // PROFILE HEADER
          // ============================================================
          _buildProfileHeader(),
          const SizedBox(height: 12),

          // ============================================================
          // TABS
          // ============================================================
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Obx(
                        () => TabBar(
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primary,
                      labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                      tabs: [
                        Tab(
                          text: '${roomController.rooms.length} Rooms',
                        ),
                        Tab(
                          text: '${tiffinController.tiffins.length} Tiffin',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRoomList(),
                        _buildTiffinList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================
  Widget _buildProfileHeader() {
    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userPhone,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    return Obx(() {
      if (roomController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (roomController.errorMessage.value.isNotEmpty &&
          roomController.rooms.isEmpty) {
        return _buildErrorWidget(
          message: 'Failed to load rooms',
          onRetry: () => roomController.fetchRoomsByUserId(userId.toString()),
        );
      }

      if (roomController.rooms.isEmpty) {
        return _buildEmptyWidget(
          icon: Icons.meeting_room_outlined,
          message: 'No Room Listings',
          subtitle: 'Tap the + button to add a room',
        );
      }

      return RefreshIndicator(
        onRefresh: () => roomController.fetchRoomsByUserId(userId.toString()),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: roomController.rooms.length,
          itemBuilder: (context, index) {
            final room = roomController.rooms[index];
            return _buildRoomCard(room);
          },
        ),
      );
    });
  }

  // ============================================================
  // ROOM CARD
  // ============================================================
  Widget _buildRoomCard(Room room) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Image
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: room.roomImages.isNotEmpty
                      ? Image.network(
                    room.roomImages.first.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.meeting_room,
                        color: AppColors.primary,
                        size: 30,
                      );
                    },
                  )
                      : const Icon(
                    Icons.meeting_room,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),

                // Room Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room.roomTypeDisplay,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        spacing: 3,
                        children: [
                          Icon(Icons.location_on,size: 14,color: Colors.green,),
                          Text(
                            room.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Availability
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: room.isBooking
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    room.availabilityStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: room.availabilityColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 18),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      room.formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 15,
                      ),
                    ),
                    if (room.hasContact)
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            room.contactDisplay,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const Spacer(),
                // Delete Button
                IconButton(
                  onPressed: () => _showDeleteConfirmation(
                    context: Get.context!,
                    title: 'Delete Room',
                    message: 'Are you sure you want to delete "${room.title}"?',
                    onConfirm: () => _deleteRoom(room.id),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                // Edit Button - Navigate to Edit Screen
                IconButton(
                  onPressed: () {
                    Get.to(
                          () => AddRoomTiffinCenterScreen(
                        roomData: room,
                        isEdit: true,
                      ),
                      transition: Transition.rightToLeft,
                    )?.then((value) {
                      if (value == true) {
                        // Refresh after edit
                        roomController.fetchRoomsByUserId(userId.toString());
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIFFIN LIST
  // ============================================================
  Widget _buildTiffinList() {
    return Obx(() {
      if (tiffinController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (tiffinController.errorMessage.value.isNotEmpty &&
          tiffinController.tiffins.isEmpty) {
        return _buildErrorWidget(
          message: 'Failed to load tiffins',
          onRetry: () => tiffinController.fetchTiffinsByUserId(userId.toString()),
        );
      }

      if (tiffinController.tiffins.isEmpty) {
        return _buildEmptyWidget(
          icon: Icons.restaurant,
          message: 'No Tiffin Services',
          subtitle: 'Tap the + button to add a tiffin service',
        );
      }

      return RefreshIndicator(
        onRefresh: () => tiffinController.fetchTiffinsByUserId(userId.toString()),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: tiffinController.tiffins.length,
          itemBuilder: (context, index) {
            final tiffin = tiffinController.tiffins[index];
            return _buildTiffinCard(tiffin);
          },
        ),
      );
    });
  }

  // ============================================================
  // TIFFIN CARD
  // ============================================================
  Widget _buildTiffinCard(Tiffin tiffin) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiffin Image
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: tiffin.hasImages
                      ? Image.network(
                    tiffin.firstImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        tiffin.typeIcon,
                        color: AppColors.primary,
                        size: 30,
                      );
                    },
                  )
                      : Icon(
                    tiffin.typeIcon,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),

                // Tiffin Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tiffin.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Tiffin Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tiffin.typeDisplay,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              tiffin.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                // Availability Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: tiffin.availabilityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tiffin.availabilityStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tiffin.availabilityColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tiffin.formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 15,
                      ),
                    ),
                    if (tiffin.hasContact)
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            tiffin.contactDisplay,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  children: [
                    // Rating
                    if (tiffin.ratingValue > 0)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          Text(
                            tiffin.ratingValue.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(width: 8),
                    // Delete Button
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(
                        context: Get.context!,
                        title: 'Delete Tiffin',
                        message: 'Are you sure you want to delete "${tiffin.title}"?',
                        onConfirm: () => _deleteTiffin(tiffin.id),
                      ),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    // Edit Button - Navigate to Edit Screen
                    IconButton(
                      onPressed: () {
                        Get.to(
                              () => AddRoomTiffinCenterScreen(
                            tiffinData: tiffin,
                            isEdit: true,
                          ),
                          transition: Transition.rightToLeft,
                        )?.then((value) {
                          if (value == true) {
                            // Refresh after edit
                            tiffinController.fetchTiffinsByUserId(userId.toString());
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DELETE FUNCTIONS
  // ============================================================

  void _deleteRoom(int roomId) {
    roomController.deleteRoom(roomId).then((success) {
      if (success) {
        // Refresh the list
        roomController.fetchRoomsByUserId(userId.toString());

      }
    });
  }

  void _deleteTiffin(int tiffinId) {
    tiffinController.deleteTiffin(tiffinId).then((success) {
      if (success) {
        // Refresh the list
        tiffinController.fetchTiffinsByUserId(userId.toString());
      }
    });
  }

  // ============================================================
  // DELETE CONFIRMATION DIALOG
  // ============================================================

  void _showDeleteConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HELPER WIDGETS
  // ============================================================
  Widget _buildEmptyWidget({
    required IconData icon,
    required String message,
    String? subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}