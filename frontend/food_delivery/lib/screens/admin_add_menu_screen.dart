import 'package:flutter/material.dart';
import '../services/admin_menu_service.dart';

class AdminAddMenuScreen extends StatefulWidget {
  final String restaurantId;

  const AdminAddMenuScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<AdminAddMenuScreen> createState() => _AdminAddMenuScreenState();
}

class _AdminAddMenuScreenState extends State<AdminAddMenuScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Menu Item")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Add Menu"),
              onPressed: () async {
                final success = await AdminMenuService.addMenuItem(
                  widget.restaurantId,
                  nameController.text,
                  double.parse(priceController.text),
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Menu item added")),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
