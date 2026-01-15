import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import 'admin_menu_list_screen.dart';

class AdminRestaurantListScreen extends StatefulWidget {
  const AdminRestaurantListScreen({super.key});

  @override
  State<AdminRestaurantListScreen> createState() =>
      _AdminRestaurantListScreenState();
}

class _AdminRestaurantListScreenState
    extends State<AdminRestaurantListScreen> {
  late Future<List<dynamic>> restaurantsFuture;

  @override
  void initState() {
    super.initState();
    restaurantsFuture = RestaurantService.getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Restaurants")),
      body: FutureBuilder<List<dynamic>>(
        future: restaurantsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final restaurants = snapshot.data!;

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];

              return ListTile(
                title: Text(restaurant["name"]),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminMenuListScreen(
                        restaurantId: restaurant["_id"],
                        restaurantName: restaurant["name"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
