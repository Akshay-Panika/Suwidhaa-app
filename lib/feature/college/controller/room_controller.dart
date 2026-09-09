// lib/feature/college/controllers/room_controller.dart

import 'package:get/get.dart';

import '../../../core/widget/flutter_toast.dart';
import '../model/room_model.dart';
import '../repository/room_repository.dart';

class RoomController extends GetxController {
  final RoomRepository _repository = RoomRepository();

  // ============================================================
  // OBSERVABLE VARIABLES
  // ============================================================

  final RxList<Room> rooms = <Room>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final Rx<Room?> selectedRoom = Rx<Room?>(null);

  final RxString selectedFilter = 'All'.obs;

  // ============================================================
  // ROOM TYPES
  // ============================================================

  final List<String> roomTypes = [
    'All',
    '1bhk',
    '2bhk',
    '3bhk',
    'pg',
    'single room',
  ];

  // ============================================================
  // FILTERED ROOMS
  // ============================================================

  List<Room> get filteredRooms {
    if (selectedFilter.value.toLowerCase() == 'all') {
      return rooms;
    }

    return rooms.where((room) {
      return room.roomType?.toLowerCase() ==
          selectedFilter.value.toLowerCase();
    }).toList();
  }

  // ============================================================
  // AVAILABLE ROOMS
  // ============================================================

  List<Room> get availableRooms {
    return rooms.where((room) {
      return !room.isBooking;
    }).toList();
  }

  // ============================================================
  // BOOKED ROOMS
  // ============================================================

  List<Room> get bookedRooms {
    return rooms.where((room) {
      return room.isBooking;
    }).toList();
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    if (rooms.isEmpty) {
      fetchRooms();
    }
  }

  // ============================================================
  // GET ALL ROOMS
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/list/
  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getRooms();

      if (response.success) {
        rooms.assignAll(response.data);

        print(
          '✅ All rooms loaded: ${rooms.length}',
        );
      } else {
        errorMessage.value = 'Failed to load rooms';

        FlutterToast.error(
          'Failed to load rooms',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error fetching rooms: $e',
      );

      FlutterToast.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // GET ROOMS BY USER ID
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/list/?user_id=9
  Future<void> fetchRoomsByUserId(
      String userId,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print(
        '🔍 Fetching rooms for user_id: $userId',
      );

      final response =
      await _repository.getRoomsByUserId(userId);

      if (response.success) {
        rooms.assignAll(response.data);

        print(
          '✅ User rooms loaded: ${rooms.length}',
        );
      } else {
        errorMessage.value =
        'Failed to load user rooms';

        FlutterToast.error(
          'Failed to load user rooms',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error fetching user rooms: $e',
      );

      FlutterToast.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // GET ROOM BY ID
  // ============================================================

  /// GET
  /// /api/v1/college/rooms/{room_id}/
  Future<void> fetchRoomById(
      int id,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final room =
      await _repository.getRoomById(id);

      selectedRoom.value = room;

      print(
        '✅ Room loaded: ${room.id}',
      );
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error fetching room: $e',
      );

      FlutterToast.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // GET ROOMS BY COLLEGE
  // ============================================================

  /// Filter using near_college
  Future<void> fetchRoomsByCollege(
      String collegeName,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print(
        '🔍 Fetching rooms for college: $collegeName',
      );

      final response =
      await _repository.getRooms();

      if (response.success) {
        final filtered = response.data.where((room) {
          if (room.nearCollege == null ||
              room.nearCollege!.isEmpty) {
            return false;
          }

          return room.nearCollege!
              .toLowerCase()
              .trim() ==
              collegeName.toLowerCase().trim();
        }).toList();

        rooms.assignAll(filtered);

        print(
          '✅ College rooms loaded: ${rooms.length}',
        );
      } else {
        errorMessage.value =
        'Failed to load rooms';

        FlutterToast.error(
          'Failed to load rooms',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error fetching college rooms: $e',
      );

      FlutterToast.error(
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CREATE ROOM
  // ============================================================

  /// POST
  /// /api/v1/college/rooms/create/
  Future<bool> createRoom({
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
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

      final response =
      await _repository.createRoom(
        userId: userId,
        title: title,
        description: description,
        address: address,
        price: price,
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

        // Refresh list
        await fetchRooms();

        // Select created room if available
        if (response.data != null) {
          selectedRoom.value = response.data;
        }

        print(
          '✅ Room created successfully',
        );

        return true;
      }

      errorMessage.value =
      response.message.isNotEmpty
          ? response.message
          : 'Failed to create room';

      FlutterToast.error(
        errorMessage.value,
      );

      return false;
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error creating room: $e',
      );

      FlutterToast.error(
        e.toString(),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE ROOM
  // ============================================================

  /// PUT
  /// /api/v1/college/rooms/{room_id}/
  Future<bool> updateRoom({
    required int roomId,
    required String userId,
    required String title,
    required String description,
    required String address,
    required String price,
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

      final response =
      await _repository.updateRoom(
        roomId: roomId,
        userId: userId,
        title: title,
        description: description,
        address: address,
        price: price,
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

        // Refresh list
        await fetchRooms();

        // Update selected room
        if (response.data != null) {
          selectedRoom.value = response.data;
        } else {
          await fetchRoomById(roomId);
        }

        print(
          '✅ Room updated successfully: $roomId',
        );

        return true;
      }

      errorMessage.value =
      response.message.isNotEmpty
          ? response.message
          : 'Failed to update room';

      FlutterToast.error(
        errorMessage.value,
      );

      return false;
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error updating room: $e',
      );

      FlutterToast.error(
        e.toString(),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // DELETE ROOM
  // ============================================================

  /// DELETE
  /// /api/v1/college/rooms/{room_id}/
  Future<bool> deleteRoom(
      int roomId,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success =
      await _repository.deleteRoom(roomId);

      if (success) {
        // Remove room from local list
        rooms.removeWhere(
              (room) => room.id == roomId,
        );

        // Clear selected room
        if (selectedRoom.value?.id == roomId) {
          selectedRoom.value = null;
        }

        FlutterToast.success(
          'Room deleted successfully',
        );

        print(
          '✅ Room deleted successfully: $roomId',
        );

        return true;
      }

      errorMessage.value =
      'Failed to delete room';

      FlutterToast.error(
        errorMessage.value,
      );

      return false;
    } catch (e) {
      errorMessage.value = e.toString();

      print(
        '❌ Error deleting room: $e',
      );

      FlutterToast.error(
        e.toString(),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SET FILTER
  // ============================================================

  void setFilter(
      String filter,
      ) {
    selectedFilter.value = filter;
  }

  // ============================================================
  // REFRESH ROOMS
  // ============================================================

  Future<void> refreshRooms() async {
    await fetchRooms();
  }

  // ============================================================
  // CLEAR SELECTED ROOM
  // ============================================================

  void clearSelectedRoom() {
    selectedRoom.value = null;
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void clearError() {
    errorMessage.value = '';
  }
}