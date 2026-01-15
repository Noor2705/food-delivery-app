import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const LoginScreen(),
    );
  }
}
