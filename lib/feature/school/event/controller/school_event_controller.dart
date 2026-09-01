import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/school_event_model.dart';
import '../repository/school_event_repository.dart';

class SchoolEventController extends GetxController {
  final SchoolEventRepository _repository = SchoolEventRepository();

  // Observable states
  final eventList = <SchoolEventModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedEvent = Rxn<SchoolEventModel>();
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  // Filter options
  final filters = <String>['All', 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  // Fetch all events
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getEventList();

      if (response.success) {
        eventList.assignAll(response.data);
      } else {
        errorMessage.value = 'Failed to load events';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Get event by ID
  Future<void> getEventById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final event = await _repository.getEventById(id);
      selectedEvent.value = event;
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Filter methods
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<SchoolEventModel> getFilteredEvents() {
    final query = searchQuery.value.toLowerCase().trim();
    final filter = selectedFilter.value;

    return eventList.where((event) {
      // Search filter
      if (query.isNotEmpty) {
        final title = event.title?.toLowerCase() ?? '';
        final description = event.description?.toLowerCase() ?? '';
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Status filter
      if (filter != 'All') {
        final status = event.status ?? '';
        if (status.toLowerCase() != filter.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Get status count
  Map<String, int> getStatusCounts() {
    final counts = <String, int>{};
    for (final event in eventList) {
      final status = event.status ?? 'Unknown';
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  // Search
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Refresh
  Future<void> refreshEvents() async {
    await fetchEvents();
  }

  // Clear selected event
  void clearSelectedEvent() {
    selectedEvent.value = null;
  }

  // Get status color
  Color getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}