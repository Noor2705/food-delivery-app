import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RestaurantService {
  /// GET ALL RESTAURANTS
  static Future<List<dynamic>> getRestaurants() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/restaurants"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["restaurants"];
    } else {
      return [];
    }
  }

  /// GET MENU BY RESTAURANT ID
  static Future<List<dynamic>> getMenu(String restaurantId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/restaurants/$restaurantId/menus"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["menus"];
    } else {
      return [];
    }
  }

  ///GET ALL MENU ITEMS (FOR CUSTOMER SEARCH)
  static Future<List<dynamic>> getAllMenus() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/restaurants/menus/all"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["menus"];
    } else {
      return [];
    }
  }

}
