import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../services/admin_menu_service.dart';
import 'admin_add_menu_screen.dart';

class AdminMenuListScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const AdminMenuListScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<AdminMenuListScreen> createState() => _AdminMenuListScreenState();
}

class _AdminMenuListScreenState extends State<AdminMenuListScreen> {
  late Future<List<dynamic>> menuFuture;

  @override
  void initState() {
    super.initState();
    refreshMenu();
  }

  void refreshMenu() {
    setState(() {
      menuFuture = RestaurantService.getMenu(widget.restaurantId);
    });
  }

  Future<void> deleteMenuItem(String menuId) async {
    final success = await AdminMenuService.deleteMenuItem(menuId);

    if (success) {
      refreshMenu();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu item deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete menu item")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu – ${widget.restaurantName}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminAddMenuScreen(
                    restaurantId: widget.restaurantId,
                  ),
                ),
              );
              refreshMenu();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items"));
          }

          final menuItems = snapshot.data!;

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    item["itemName"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("₹ ${item["price"]}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Menu Item"),
                          content: const Text(
                              "Are you sure you want to delete this item?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await deleteMenuItem(item["_id"]);
                      }
                    },
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
