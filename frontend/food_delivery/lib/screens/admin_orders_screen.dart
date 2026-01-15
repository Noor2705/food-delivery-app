import 'package:flutter/material.dart';
import '../services/order_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<List<dynamic>> ordersFuture;

  final List<String> statusOptions = [
    "PLACED",
    "PREPARING",
    "OUT_FOR_DELIVERY",
    "DELIVERED",
  ];

  @override
  void initState() {
    super.initState();
    ordersFuture = OrderService.getAllOrders();
  }

  void refreshOrders() {
    setState(() {
      ordersFuture = OrderService.getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Orders")),
      body: FutureBuilder<List<dynamic>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders available"));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ORDER ID
                      Text(
                        "Order ID: ${order["_id"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// TOTAL
                      Text(
                        "Total: ₹ ${order["total"]}",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 6),

                      /// STATUS DROPDOWN
                      Row(
                        children: [
                          const Text(
                            "Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<String>(
                            value: order["status"],
                            items: const [
                              DropdownMenuItem(
                                value: "PLACED",
                                child: Text("PLACED"),
                              ),
                              DropdownMenuItem(
                                value: "OUT_FOR_DELIVERY",
                                child: Text("OUT FOR DELIVERY"),
                              ),
                              DropdownMenuItem(
                                value: "DELIVERED",
                                child: Text("DELIVERED"),
                              ),
                            ],
                            onChanged: (value) async {
                              if (value != null) {
                                await OrderService.updateOrderStatus(
                                  order["_id"],
                                  value,
                                );
                                setState(() {
                                  order["status"] = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const Divider(),

                      /// 🔥 ITEMS LIST (THIS IS WHAT WAS MISSING)
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
                            "- ${item["name"]} × ${item["quantity"]}",
                            style: const TextStyle(fontSize: 13),
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
