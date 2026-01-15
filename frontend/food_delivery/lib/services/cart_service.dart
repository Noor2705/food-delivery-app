import '../models/cart_item.dart';

class CartService {
  static final List<CartItem> _cartItems = [];

  // Get cart items
  static List<CartItem> getCartItems() {
    return _cartItems;
  }

  // Add item to cart
  static void addToCart(String name, double price) {
    final index =
    _cartItems.indexWhere((item) => item.name == name);

    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(
        CartItem(name: name, price: price),
      );
    }
  }

  // Remove item
  static void removeFromCart(CartItem item) {
    _cartItems.remove(item);
  }

  // Increase quantity
  static void increaseQty(CartItem item) {
    item.quantity++;
  }

  // Decrease quantity
  static void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    }
  }

  // Get total price
  static double getTotal() {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Clear cart
  static void clearCart() {
    _cartItems.clear();
  }

  static int getTotalItems() {
    return _cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

}
