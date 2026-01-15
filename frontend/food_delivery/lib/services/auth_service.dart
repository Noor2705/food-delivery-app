import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  /// LOGIN USER
  /// Returns true ONLY if backend returns HTTP 200
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/auth/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // LOGIN SUCCESS
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("role", data["user"]["role"]);
        await prefs.setString("userId", data["user"]["id"]);

        return true;
      }

      // WRONG CREDENTIALS OR ERROR
      return false;
    } catch (e) {
      // NETWORK / SERVER ERROR
      print("Login error: $e");
      return false;
    }
  }

  /// REGISTER USER
  static Future<bool> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/auth/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  /// GET SAVED JWT TOKEN
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// GET USER ROLE
  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  /// LOGOUT USER
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
