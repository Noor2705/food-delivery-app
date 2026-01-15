import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class PaymentService {
  static Future<bool> savePayment(
      String orderId, String transactionId) async {
    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/payments"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "orderId": orderId,
          "transactionId": transactionId,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Payment error: $e");
      return false;
    }
  }
}
