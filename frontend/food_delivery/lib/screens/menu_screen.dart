import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const MenuScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<dynamic>> menuFuture;

  @override
  void initState() {
    super.initState();
    menuFuture = RestaurantService.getMenu(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading menu"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items found"));
          }

          final menuItems = snapshot.data!;

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    item["itemName"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "₹ ${item["price"]}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      CartService.addToCart(
                        item["itemName"],
                        double.parse(item["price"].toString()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "${item["itemName"]} added to cart"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text("Add"),
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
