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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d("Request: ${options.method} Url: ${options.path}");
          logger.d("Headers: ${options.headers}");
          logger.d("Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d("Response: ${response.statusCode}");
          logger.d("Response Body: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("Error: ${e.message}");
          logger.e("Error Response: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
  }

  Future<User?> login({required String email, required String password}) async {
    final url = "$baseurl/login";
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

      logger.d("Login Response Full: ${response.data}");

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      logger.e("Login Error: $e");
    }
    return null;
  }

  Future<Productsall?> getproductsall() async {
    final url = "$baseurl/products-all/";

    // Get token first and log it
    String? token = await userService.getAccessToken();
    logger.d("Retrieved Token: $token");

    if (token == null || token.isEmpty) {
      logger.e("No access token found!");
      return null;
    }

    final header = {
      "accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await dio.get(url, options: Options(headers: header));

      logger.d("Products Response Status: ${response.statusCode}");
      logger.d("Products Response Body: ${response.data}");

      if (response.statusCode == 200) {
        var productslist = Productsall.fromJson(response.data);
        logger.d("Products Count: ${productslist.data?.length ?? 0}");
        return productslist;
      }
    } catch (e) {
      logger.e("Get Products Error: $e");
      if (e is DioException) {
        logger.e("Status Code: ${e.response?.statusCode}");
        logger.e("Response Data: ${e.response?.data}");
      }
    }
    return null;
  }
}
