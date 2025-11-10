import 'dart:io';

import 'package:dio/dio.dart';
import 'package:diosample/models/loginresp/loginresp.dart';
import 'package:diosample/models/productsallresp/productsallresp.dart';
import 'package:diosample/service/usersevice.dart';
import 'package:logger/logger.dart';

class Apiservice {
  final String baseurl = "https://freeapi.luminartechnohub.com";
  final logger = Logger();
  final dio = Dio();
  UserService userService = UserService();

  Apiservice() {
    // Configure Dio with base options
    dio.options.baseUrl = baseurl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d("Request: ${options.method} ${options.uri}");
          logger.d("Headers: ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d("Response: ${response.statusCode}");
          logger.d("Response Body: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("Error: ${e.message}");
          logger.e("Status Code: ${e.response?.statusCode}");
          logger.e("Error Response: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
  }

  Future<User?> login({required String email, required String password}) async {
    final url = "/login";
    final header = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };
    final body = {"email": email, "password": password};

    try {
      final response = await dio.post(
        url,
        data: body,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      logger.e("Login Error: $e");
    }
    return null;
  }

  Future<Productsall?> getproductsall() async {
    final url = "/products-all/";

    String? token = await userService.getAccessToken();
    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return null;
    }

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return Productsall.fromJson(response.data);
      }
    } catch (e) {
      logger.e("Get All Products Error: $e");
    }
    return null;
  }

  Future<Productsall?> myproduct() async {
    final url = "/my-products/";

    String? token = await userService.getAccessToken();
    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return null;
    }

    try {
      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return Productsall.fromJson(response.data);
      }
    } catch (e) {
      logger.e("Get My Products Error: $e");
    }
    return null;
  }

  Future<bool> addproduct({
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    File? image,
  }) async {
    final url = "/product-create/";

    String? token = await userService.getAccessToken();
    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return false;
    }

    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.d("Product added successfully!");
        return true;
      }
      return false;
    } catch (e) {
      logger.e("Error adding product: $e");
      return false;
    }
  }

  Future<bool> updateproduct({
    required String id,
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    File? image,
  }) async {
    final url = "/product-update/$id/";

    String? token = await userService.getAccessToken();
    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return false;
    }

    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        if (image != null)
          "image": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await dio.put(
        url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        logger.d("Product updated successfully!");
        return true;
      }
      return false;
    } catch (e) {
      logger.e("Error updating product: $e");
      return false;
    }
  }

  Future<bool> productdelete(int productId) async {
    final url = "/product-delete/$productId/";

    String? token = await userService.getAccessToken();
    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return false;
    }

    try {
      final response = await dio.delete(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        logger.d("Product deleted successfully!");
        return true;
      }
      return false;
    } catch (e) {
      logger.e("Delete Product Error: $e");
      return false;
    }
  }
}
