import 'package:flutter/material.dart';
import 'package:sigaut_frontend/features/category/view/categories_screen.dart';
import 'package:sigaut_frontend/features/others/view/splash_screen.dart';
import 'package:sigaut_frontend/features/product/view/products_screen.dart';
import 'package:sigaut_frontend/features/sale/view/report_sale_screen.dart';
import 'package:sigaut_frontend/features/sale/view/sale_screen.dart';
import 'package:sigaut_frontend/features/user/view/login_screen.dart';
import 'package:sigaut_frontend/features/user/view/profile_screen.dart';
import 'package:sigaut_frontend/features/user/view/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/home';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 👇 Cambiamos la ruta inicial al splash
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (args) => const SplashScreen(),
        LoginScreen.routeName: (args) => const LoginScreen(),
        RegisterScreen.routeName: (args) => const RegisterScreen(),
        SaleScreen.routeName: (args) => const SaleScreen(),
        ProductsScreen.routeName: (args) => const ProductsScreen(),
        CategoriesScreen.routeName: (args) => const CategoriesScreen(),
        ProfileScreen.routeName: (args) => const ProfileScreen(),
        ReportSaleScreen.routeName: (args) => const ReportSaleScreen(),
      },
    );
  }
}
