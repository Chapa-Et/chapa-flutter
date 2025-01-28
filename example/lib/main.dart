import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/provider/cart_provider.dart';
import 'package:shopping_cart_app/screens/cart_screen.dart';
import 'package:shopping_cart_app/screens/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.green,
          ),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.green,
          ),
          routes: {
            '/checkoutPage': (context) => const CartScreen(),
            '/': (context) => ProductList()
          },
        );
      }),
    );
  }
}
