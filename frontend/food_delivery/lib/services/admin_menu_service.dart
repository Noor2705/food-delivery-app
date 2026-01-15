import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class AdminMenuService {

  /* =========================
     ADD MENU ITEM (ADMIN)
     POST /admin/menus
  ========================= */
  static Future<bool> addMenuItem(
      String restaurantId,
      String itemName,
      double price,
      ) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/admin/menus"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "restaurantId": restaurantId,
          "itemName": itemName,
          "price": price,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Add menu error: $e");
      return false;
    }
  }

  /* =========================
     DELETE MENU ITEM (ADMIN)
     DELETE /admin/menus/:id
  ========================= */
  static Future<bool> deleteMenuItem(String menuId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}/admin/menus/$menuId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Delete menu error: $e");
      return false;
    }
  }
}
