import 'package:diosample/models/loginresp/loginresp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class UserService {
  static const String _userKey = 'user_data';
  final logger = Logger();

  /// Save user session data locally
  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String jsonString = userToJson(user);
      await prefs.setString(_userKey, jsonString);

      logger.d("User saved successfully");
      logger.d("Access Token: ${user.access}");
      logger.d("Refresh Token: ${user.refresh}");
    } catch (e) {
      logger.e("Error saving user: $e");
    }
  }

  /// Retrieve user data
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userKey);

      if (jsonString == null) {
        logger.w("No user data found in storage");
        return null;
      }

      User user = userFromJson(jsonString);
      logger.d("User retrieved successfully");
      return user;
    } catch (e) {
      logger.e("Error retrieving user: $e");
      return null;
    }
  }

  /// Check if a user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_userKey);
    } catch (e) {
      logger.e("Error checking login status: $e");
      return false;
    }
  }

  /// Remove user session (logout)
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      logger.d("User data cleared successfully");
    } catch (e) {
      logger.e("Error clearing user: $e");
    }
  }

  /// Get access token directly
  Future<String?> getAccessToken() async {
    try {
      final user = await getUser();

      if (user == null) {
        logger.w("Cannot get access token - user is null");
        return null;
      }

      if (user.access == null || user.access!.isEmpty) {
        logger.w("Access token is null or empty");
        return null;
      }

      logger.d("Access token retrieved: ${user.access}");
      return user.access;
    } catch (e) {
      logger.e("Error getting access token: $e");
      return null;
    }
  }

  /// Get refresh token directly
  Future<String?> getRefreshToken() async {
    try {
      final user = await getUser();

      if (user == null) {
        logger.w("Cannot get refresh token - user is null");
        return null;
      }

      if (user.refresh == null || user.refresh!.isEmpty) {
        logger.w("Refresh token is null or empty");
        return null;
      }

      logger.d("Refresh token retrieved: ${user.refresh}");
      return user.refresh;
    } catch (e) {
      logger.e("Error getting refresh token: $e");
      return null;
    }
  }
}
