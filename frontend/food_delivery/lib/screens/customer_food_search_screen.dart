import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../services/cart_service.dart';

class CustomerFoodSearchScreen extends StatefulWidget {
  const CustomerFoodSearchScreen({super.key});

  @override
  State<CustomerFoodSearchScreen> createState() =>
      _CustomerFoodSearchScreenState();
}

class _CustomerFoodSearchScreenState
    extends State<CustomerFoodSearchScreen> {
  List<dynamic> allMenus = [];
  List<dynamic> filteredMenus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  Future<void> loadMenus() async {
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
      appBar: AppBar(title: const Text("Search Food")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: searchFood,
              decoration: InputDecoration(
                hintText: "Search food items...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          /// FOOD LIST
          Expanded(
            child: filteredMenus.isEmpty
                ? const Center(child: Text("No food found"))
                : ListView.builder(
              itemCount: filteredMenus.length,
              itemBuilder: (context, index) {
                final item = filteredMenus[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item["itemName"]),
                    subtitle: Text(
                      "₹ ${item["price"]} • ${item["restaurantId"]["name"]}",
                    ),
                    trailing: ElevatedButton(
                      child: const Text("Add"),
                      onPressed: () {
                        CartService.addToCart(
                          item["itemName"],
                          double.parse(
                              item["price"].toString()),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
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
