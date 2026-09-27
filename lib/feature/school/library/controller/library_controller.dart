import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import '../model/library_book_model.dart';
import '../repository/library_repository.dart';

class LibraryController extends GetxController {
  final LibraryRepository _repo = LibraryRepository();

  // ==================== STATE ====================
  final RxList<LibraryBookModel> books = <LibraryBookModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Filters (UI labels)
  final RxString classFilter = "All".obs;      // "All" | "Class 10" | ...
  final RxString subjectFilter = "All".obs;    // "All" | "Maths" | ...
  final RxString searchQuery = ''.obs;

  // ==================== FETCH ====================
  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      error.value = '';

      // ✅ Normalize for backend
      String? classParam;
      if (classFilter.value != "All") {
        classParam = classFilter.value.replaceAll("Class ", "").trim();
      }

      String? subjectParam;
      if (subjectFilter.value != "All") {
        subjectParam = subjectFilter.value.trim();
      }

      final list = await _repo.getBooks(
        className: classParam,
        subject: subjectParam,
        search: searchQuery.value,
      );
      books.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== FETCH BY ID ====================
  Future<LibraryBookModel?> fetchBookById(int id) async {
    try {
      return await _repo.getBookById(id);
    } catch (e) {
      FlutterToast.error("Error ${e.toString()}",);
      return null;
    }
  }

  // ==================== CREATE ====================
  Future<bool> addBook({
    required String author,
    required String bookClass,
    required String subject,
    required int quantity,
    File? frontImage,
    File? backImage,
  }) async {
    try {
      final book = await _repo.createBook(
        author: author,
        bookClass: bookClass,
        subject: subject,
        quantity: quantity,
        frontImage: frontImage,
        backImage: backImage,
      );
      books.insert(0, book);
      return true;
    } catch (e) {
      FlutterToast.error("Error ${e.toString()}",);
      return false;
    }
  }

  // ==================== UPDATE ====================
  Future<bool> updateBook({
    required int id,
    required String author,
    required String bookClass,
    required String subject,
    required int quantity,
    File? frontImage,
    File? backImage,
  }) async {
    try {
      final updated = await _repo.updateBook(
        id: id,
        author: author,
        bookClass: bookClass,
        subject: subject,
        quantity: quantity,
        frontImage: frontImage,
        backImage: backImage,
      );
      final i = books.indexWhere((b) => b.id == id);
      if (i != -1) books[i] = updated;
      return true;
    } catch (e) {
      FlutterToast.error("Error ${e.toString()}",);
      return false;
    }
  }

  // ==================== DELETE ====================
  Future<bool> deleteBook(int id) async {
    try {
      final ok = await _repo.deleteBook(id);
      if (ok) books.removeWhere((b) => b.id == id);
      return ok;
    } catch (e) {
      FlutterToast.error("Error ${e.toString()}",);
      return false;
    }
  }

  // ==================== FILTERS ====================
  void setClassFilter(String v) {
    classFilter.value = v;
    fetchBooks();
  }

  void setSubjectFilter(String v) {
    subjectFilter.value = v;
    fetchBooks();
  }

  void setSearch(String v) {
    searchQuery.value = v;
    fetchBooks();
  }

  void clearFilters() {
    classFilter.value = "All";
    subjectFilter.value = "All";
    searchQuery.value = "";
    fetchBooks();
  }
}