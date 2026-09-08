// lib/feature/college/controllers/room_controller.dart
import 'package:get/get.dart';
import '../../../core/widget/flutter_toast.dart';
import '../model/room_model.dart';
import '../repository/room_repository.dart';

class RoomController extends GetxController {
  final RoomRepository _repository = RoomRepository();

  // Observable variables
  final RxList<Room> rooms = <Room>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Room?> selectedRoom = Rx<Room?>(null);
  final RxString selectedFilter = 'All'.obs;

  // Available room types for filter
  final List<String> roomTypes = [
    'All',
    '1bhk',
    '2bhk',
    '3bhk',
    'pg',
    'single room',
  ];

  // Get filtered rooms based on selected type
  List<Room> get filteredRooms {
    if (selectedFilter.value == 'All') {
      return rooms;
    }
    return rooms
        .where((room) =>
    room.roomType?.toLowerCase() == selectedFilter.value.toLowerCase())
        .toList();
  }

  // Get available rooms
  List<Room> get availableRooms {
    return rooms.where((room) => !room.isBooking).toList();
  }

  // Get booked rooms
  List<Room> get bookedRooms {
    return rooms.where((room) => room.isBooking).toList();
  }

  @override
  void onInit() {
    super.onInit();
    if (rooms.isEmpty) {
      fetchRooms();
    }
  }

  /// Fetch all rooms
  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getRooms();

      if (response.success) {
        rooms.value = response.data;
        print('✅ All rooms loaded: ${rooms.length}');
      } else {
        errorMessage.value = 'Failed to load rooms';
        FlutterToast.error('Failed to load rooms');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch rooms by college name - Filter using near_college
  Future<void> fetchRoomsByCollege(String collegeName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 Fetching rooms for college: $collegeName');

      // Get all rooms from API
      final response = await _repository.getRooms();

      if (response.success) {
        // Filter rooms where near_college matches the college name (case insensitive)
        final filteredRooms = response.data.where((room) {
          if (room.nearCollege == null || room.nearCollege!.isEmpty) {
            return false;
          }
          // Match near_college with college name (case insensitive)
          return room.nearCollege!.toLowerCase() == collegeName.toLowerCase();
        }).toList();

        rooms.value = filteredRooms;
        print('✅ Rooms filtered by near_college: ${rooms.length}');
      } else {
        errorMessage.value = 'Failed to load rooms';
        FlutterToast.error('Failed to load rooms');
      }
    } catch (e) {
      print('❌ Error fetching rooms: $e');
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch room by ID
  Future<void> fetchRoomById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final room = await _repository.getRoomById(id);
      selectedRoom.value = room;
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch rooms by type
  Future<void> fetchRoomsByType(String roomType) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getRoomsByType(roomType);

      if (response.success) {
        rooms.value = response.data;
      } else {
        errorMessage.value = 'Failed to load rooms';
        FlutterToast.error('Failed to load rooms');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      FlutterToast.error('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Refresh rooms
  Future<void> refreshRooms() async {
    await fetchRooms();
  }

  /// Clear selected room
  void clearSelectedRoom() {
    selectedRoom.value = null;
  }
}