import 'package:flutter/material.dart';
import 'admin_orders_screen.dart';
import 'admin_restaurant_list_screen.dart';


/// ADMIN DASHBOARD'

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Divider(),

            /// MANAGE MENU
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("Manage Menu"),
              subtitle: const Text("Add / view menu items"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminRestaurantListScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            /// UPDATE ORDER STATUS
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text("Update Order Status"),
              subtitle: const Text("Change order lifecycle"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminOrdersScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
