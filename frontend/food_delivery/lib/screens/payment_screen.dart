import 'dart:math';
import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import 'order_history_screen.dart';

class PaymentScreen extends StatelessWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  String generateTransactionId() {
    final rand = Random();
    return "TXN${rand.nextInt(99999999)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment, size: 80, color: Colors.green),
            const SizedBox(height: 20),

            const Text(
              "Amount to Pay",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            Text(
              "₹ $amount",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text("Pay Now"),
                onPressed: () async {
                  final txnId = generateTransactionId();

                  final success = await PaymentService.savePayment(
                    orderId,
                    txnId,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Payment Successful\nTransaction ID: $txnId",
                        ),
                      ),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                          (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Payment failed"),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
