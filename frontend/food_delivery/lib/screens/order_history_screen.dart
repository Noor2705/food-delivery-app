import 'package:flutter/material.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<dynamic>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = OrderService.getOrderHistory();
  }

  ///Status tracking UI
  Widget buildStatusChip(String status) {
    Color color;

    switch (status) {
      case "PREPARING":
        color = Colors.orange;
        break;
      case "OUT_FOR_DELIVERY":
        color = Colors.blue;
        break;
      case "DELIVERED":
        color = Colors.green;
        break;
      default:
        color = Colors.grey; // PLACED
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                ordersFuture = OrderService.getOrderHistory();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading orders"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Order ID
                      Text(
                        "Order ID: ${order["_id"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// Status tracking
                      Row(
                        children: [
                          const Text(
                            "Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          buildStatusChip(order["status"]),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Total
                      Text(
                        "Total Amount: ₹ ${order["total"]}",
                        style: const TextStyle(fontSize: 15),
                      ),

                      const Divider(),

                      /// Items
                      const Text(
                        "Items:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 4),

                      ...order["items"].map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "• ${item["name"]} × ${item["quantity"]}",
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
