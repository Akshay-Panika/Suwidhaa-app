import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_urls.dart';
import '../model/library_book_model.dart';

class LibraryRepository {
  final Dio _dio = ApiClient.dio;

  /// GET /library/list/
  Future<List<LibraryBookModel>> getBooks({
    String? className,
    String? subject,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiUrls.libraryList,
      queryParameters: {
        if (className != null && className != "All") 'class': className,
        if (subject != null && subject != "All") 'subject': subject,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );

    final data = response.data;
    if (data['success'] == true) {
      final list = (data['data'] as List)
          .map((e) => LibraryBookModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    }
    throw Exception(data['message'] ?? 'Failed to load books');
  }

  /// GET /library/<id>/
  Future<LibraryBookModel> getBookById(int id) async {
    final response = await _dio.get(ApiUrls.libraryDetail(id));
    final data = response.data;
    if (data['success'] == true) {
      return LibraryBookModel.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to load book');
  }

  /// POST /library/create/
  Future<LibraryBookModel> createBook({
    required String author,
    required String bookClass,
    required String subject,
    required int quantity,
    File? frontImage,
    File? backImage,
  }) async {
    final formData = FormData.fromMap({
      'author': author,
      'book_class': bookClass,
      'subject': subject,
      'quantity': quantity,
      if (frontImage != null)
        'front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: frontImage.path.split('/').last,
        ),
      if (backImage != null)
        'back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: backImage.path.split('/').last,
        ),
    });

    final response = await _dio.post(
      ApiUrls.libraryCreate,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;
    if (data['success'] == true) {
      return LibraryBookModel.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to create book');
  }

  /// PUT /library/<id>/
  Future<LibraryBookModel> updateBook({
    required int id,
    required String author,
    required String bookClass,
    required String subject,
    required int quantity,
    File? frontImage,
    File? backImage,
  }) async {
    final formData = FormData.fromMap({
      'author': author,
      'book_class': bookClass,
      'subject': subject,
      'quantity': quantity,
      if (frontImage != null)
        'front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: frontImage.path.split('/').last,
        ),
      if (backImage != null)
        'back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: backImage.path.split('/').last,
        ),
    });

    final response = await _dio.put(
      ApiUrls.libraryDetail(id),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;
    if (data['success'] == true) {
      return LibraryBookModel.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to update book');
  }

  /// DELETE /library/<id>/
  Future<bool> deleteBook(int id) async {
    final response = await _dio.delete(ApiUrls.libraryDetail(id));
    final data = response.data;
    return data['success'] == true;
  }
}