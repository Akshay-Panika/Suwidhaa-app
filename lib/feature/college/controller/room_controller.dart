// lib/feature/college/controllers/room_controller.dart

import 'package:get/get.dart';

import '../../../core/widget/flutter_toast.dart';
import '../model/room_model.dart';
import '../repository/room_repository.dart';

class RoomController extends GetxController {
  final RoomRepository _repository = RoomRepository();

  final RxList<Room> rooms = <Room>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Room?> selectedRoom = Rx<Room?>(null);
  final RxString selectedFilter = 'All'.obs;

  final List<String> roomTypes = [
    'All',
    '1bhk',
    '2bhk',
    '3bhk',
    'pg',
    'single room',
  ];

  List<Room> get filteredRooms {
    if (selectedFilter.value.toLowerCase() == 'all') {
      return rooms;
    }

    return rooms.where((room) {
      return room.roomType?.toLowerCase() ==
          selectedFilter.value.toLowerCase();
    }).toList();
  }

  List<Room> get availableRooms {
    return rooms.where((room) => !room.isBooking).toList();
  }

  List<Room> get bookedRooms {
    return rooms.where((room) => room.isBooking).toList();
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchAllRooms({
    String? userId,
    String? nearCollege,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching all rooms — user_id: $userId, near_college: $nearCollege');

      final response = await _repository.getAllRooms(
        userId: userId,
        nearCollege: nearCollege,
      );

      if (response.success) {
        rooms.assignAll(response.data);
        print('✅ All rooms loaded: ${rooms.length}');
      } else {
        errorMessage.value = 'Failed to load rooms';
        FlutterToast.error('Failed to load rooms');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching all rooms: $e');
      FlutterToast.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchRoomsByUserId(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching owner rooms for user_id: $userId');

      final response = await _repository.getRoomsByUserId(userId);

      if (response.success) {
        rooms.assignAll(response.data);
        print('✅ Owner rooms loaded: ${rooms.length}');
      } else {
        errorMessage.value = 'Failed to load user rooms';
        FlutterToast.error('Failed to load user rooms');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching user rooms: $e');
      FlutterToast.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<Room?> fetchRoomByIdWithUserId({
    required int roomId,
    String? userId,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';


      final response = await _repository.getRoomByIdWithUserId(
        roomId: roomId,
        userId: userId,
      );

      if (response.success && response.data != null) {
        selectedRoom.value = response.data;

        return response.data;
      } else {
        errorMessage.value = 'Room not found';
        print('❌ Room not found: $roomId');
        return null;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching room: $e');
      FlutterToast.error(e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoomById(int id, {String? userId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final room = await _repository.getRoomById(id, userId: userId);
      selectedRoom.value = room;

      print('✅ Room loaded: ${room.id}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching room: $e');
      FlutterToast.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchRoomsByCollege(
      String collegeName, {
        String? userId,
      }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _repository.getAllRooms(
        userId: userId,
        nearCollege: collegeName,
      );

      if (response.success) {
        rooms.assignAll(response.data);
        print('✅ College rooms loaded: ${rooms.length}');
      } else {
        errorMessage.value = 'Failed to load rooms';
        FlutterToast.error('Failed to load rooms');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching college rooms: $e');
      FlutterToast.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CREATE ROOM (updated — owner refetch)
  // ============================================================

  Future<bool> createRoom({
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
    required String latitude,
    required String longitude,
    required String roomType,
    String? contactNumber,
    bool wifi = false,
    bool ac = false,
    bool parking = false,
    bool security = false,
    bool laundry = false,
    bool water = false,
    String? nearCollege,
    List<String>? imagePaths,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.createRoom(
        userId: userId,
        title: title,
        description: description,
        address: address,
        price: price,
        latitude:latitude,
        longitude: longitude,
        roomType: roomType,
        contactNumber: contactNumber,
        wifi: wifi,
        ac: ac,
        parking: parking,
        security: security,
        laundry: laundry,
        water: water,
        nearCollege: nearCollege,
        imagePaths: imagePaths,
      );

      if (response.success) {
        FlutterToast.success(
          response.message.isNotEmpty
              ? response.message
              : 'Room created successfully',
        );

        // ✅ Owner ke rooms refetch karo
        await fetchRoomsByUserId(userId);

        if (response.data != null) {
          selectedRoom.value = response.data;
        }

        return true;
      }

      errorMessage.value = response.message.isNotEmpty
          ? response.message
          : 'Failed to create room';

      FlutterToast.error(errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error creating room: $e');
      FlutterToast.error(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<bool> updateRoom({
    required int roomId,
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
    required String latitude,
    required String longitude,
    required String roomType,
    String? contactNumber,
    bool wifi = false,
    bool ac = false,
    bool parking = false,
    bool security = false,
    bool laundry = false,
    bool water = false,
    String? nearCollege,
    List<String>? imagePaths,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.updateRoom(
        roomId: roomId,
        userId: userId,
        title: title,
        description: description,
        address: address,
        price: price,
        latitude: latitude,
        longitude: longitude,
        roomType: roomType,
        contactNumber: contactNumber,
        wifi: wifi,
        ac: ac,
        parking: parking,
        security: security,
        laundry: laundry,
        water: water,
        nearCollege: nearCollege,
        imagePaths: imagePaths,
      );

      if (response.success) {
        FlutterToast.success(
          response.message.isNotEmpty
              ? response.message
              : 'Room updated successfully',
        );

        await fetchRoomsByUserId(userId);

        if (response.data != null) {
          selectedRoom.value = response.data;
        } else {
          await fetchRoomById(roomId, userId: userId);
        }

        return true;
      }

      errorMessage.value = response.message.isNotEmpty
          ? response.message
          : 'Failed to update room';

      FlutterToast.error(errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error updating room: $e');
      FlutterToast.error(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteRoom(int roomId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _repository.deleteRoom(roomId);

      if (success) {
        rooms.removeWhere((room) => room.id == roomId);

        if (selectedRoom.value?.id == roomId) {
          selectedRoom.value = null;
        }

        FlutterToast.success('Room deleted successfully');
        return true;
      }

      errorMessage.value = 'Failed to delete room';
      FlutterToast.error(errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error deleting room: $e');
      FlutterToast.error(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SET FILTER / CLEAR / REFRESH
  // ============================================================

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> refreshRooms() async {
    // Nothing — screen se call karo
  }

  void clearSelectedRoom() {
    selectedRoom.value = null;
  }

  void clearError() {
    errorMessage.value = '';
  }
}