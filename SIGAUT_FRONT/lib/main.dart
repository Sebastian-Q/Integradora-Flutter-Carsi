import 'package:flutter/material.dart';
import 'package:sigaut_frontend/features/category/view/categories_screen.dart';
import 'package:sigaut_frontend/features/others/view/splash_screen.dart';
import 'package:sigaut_frontend/views/screen/employees_screen.dart';
import 'package:sigaut_frontend/views/screen/login_screen.dart';
import 'package:sigaut_frontend/views/screen/products_screen.dart';
import 'package:sigaut_frontend/views/screen/profile_screen.dart';
import 'package:sigaut_frontend/views/screen/report_sale_screen.dart';
import 'package:sigaut_frontend/views/screen/sale_screen.dart';

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
      initialRoute: SplashScreen.routeName,
      routes: {
        LoginScreen.routeName: (args) => const LoginScreen(),
        SaleScreen.routeName: (args) => const SaleScreen(),
        ProfileScreen.routeName: (args) => const ProfileScreen(),
        ProductsScreen.routeName: (args) => const ProductsScreen(),
        CategoriesScreen.routeName: (args) => const CategoriesScreen(),
        EmployeesScreen.routeName: (args) => const EmployeesScreen(),
        ReportSaleScreen.routeName: (args) => const ReportSaleScreen(),
      },
    );
  }
}
