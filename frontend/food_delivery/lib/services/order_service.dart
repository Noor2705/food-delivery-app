import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class OrderService {
  /* ===========================
     PLACE ORDER (CUSTOMER)
     =========================== */
  static Future<String?> placeOrder(
      List<Map<String, dynamic>> items,
      double total,
      ) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        print("JWT token is null");
        return null;
      }

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/orders"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "items": items,
          "total": total,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data["order"]["_id"]; // ✅ REAL MongoDB ObjectId
      } else {
        print("Place order failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Place order error: $e");
      return null;
    }
  }

  /* ===========================
     GET ORDER HISTORY (CUSTOMER)
     =========================== */
  static Future<List<dynamic>> getOrderHistory() async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        print("JWT token is null");
        return [];
      }

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/orders/history"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["orders"] ?? [];
      } else {
        print("Order history failed: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Order history error: $e");
      return [];
    }
  }

  /* ===========================
     ADMIN: GET ALL ORDERS
     =========================== */
  static Future<List<dynamic>> getAllOrders() async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        print("JWT token is null");
        return [];
      }

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/admin/orders"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["orders"] ?? [];
      } else {
        print("Get all orders failed: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Get all orders error: $e");
      return [];
    }
  }

  /* ===========================
     ADMIN: UPDATE ORDER STATUS
     =========================== */
  static Future<bool> updateOrderStatus(
      String orderId,
      String status,
      ) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        print("JWT token is null");
        return false;
      }

      final response = await http.put(
        Uri.parse("${ApiConfig.baseUrl}/admin/orders/$orderId/status"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Update status failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Update order status error: $e");
      return false;
    }
  }
}
