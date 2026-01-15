import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../services/cart_service.dart';
import 'order_history_screen.dart';
import 'cart_screen.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<dynamic> allMenus = [];
  List<dynamic> filteredMenus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    final menus = await RestaurantService.getAllMenus();
    setState(() {
      allMenus = menus;
      filteredMenus = menus;
      isLoading = false;
    });
  }

  void searchFood(String query) {
    setState(() {
      filteredMenus = allMenus.where((item) {
        return item["itemName"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Food"),
        actions: [
          /// CART ICON WITH BADGE
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  ).then((_) {
                    // refresh badge when returning
                    setState(() {});
                  });
                },
              ),
              if (CartService.getTotalItems() > 0)
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    child: Text(
                      CartService.getTotalItems().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

            ],
          ),

          /// 🧾 ORDER HISTORY
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: searchFood,
              decoration: InputDecoration(
                hintText: "Search food items...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          ///  FOOD ITEMS LIST
          Expanded(
            child: filteredMenus.isEmpty
                ? const Center(child: Text("No food items found"))
                : ListView.builder(
              itemCount: filteredMenus.length,
              itemBuilder: (context, index) {
                final item = filteredMenus[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      item["itemName"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${item["restaurantId"]["name"]} • ₹ ${item["price"]}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          CartService.addToCart(
                            item["itemName"],
                            double.parse(
                                item["price"].toString()),
                          );
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${item["itemName"]} added to cart",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
