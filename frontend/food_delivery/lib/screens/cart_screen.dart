import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../services/order_service.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = CartService.getCartItems();

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return ListTile(
                  title: Text(item.name),
                  subtitle:
                  Text("₹ ${item.price} x ${item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            CartService.decreaseQty(item);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            CartService.increaseQty(item);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            CartService.removeFromCart(item);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Total: ₹ ${CartService.getTotal()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cartItems =
                      CartService.getCartItems();

                      if (cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Cart is empty")),
                        );
                        return;
                      }

                      // Convert cart items to API format
                      final orderItems = cartItems.map((item) {
                        return {
                          "name": item.name,
                          "price": item.price,
                          "quantity": item.quantity,
                        };
                      }).toList();

                      final total = CartService.getTotal();

                      // 🔥 PLACE ORDER & GET REAL ORDER ID
                      final String? orderId =
                      await OrderService.placeOrder(
                        orderItems,
                        total,
                      );

                      if (orderId != null) {
                        CartService.clearCart();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              orderId: orderId, // ✅ REAL MongoDB ID
                              amount: total,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                              Text("Failed to place order")),
                        );
                      }
                    },
                    child: const Text("Place Order"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
