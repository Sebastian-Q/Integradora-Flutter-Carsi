import 'package:flutter/material.dart';
import 'package:sigaut_frontend/features/sale/view/sale_screen.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/user/view/login_screen.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    UserModel user = await userRepository.getLocalUser();

    // Simulamos un pequeño delay visual
    await Future.delayed(const Duration(seconds: 1));

    if (user.username.isNotEmpty) {
      // Hay un usuario guardado → ir a la pantalla principal
      Navigator.pushReplacementNamed(context, SaleScreen.routeName);
    } else {
      // No hay usuario → ir al login
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Abarrotes UTEZ",
              style: CustomTextStyle.bold32.copyWith(color: Theme.of(context).colorScheme.quinaryBackground),
            ),
            const SizedBox(height: 8,),
            Container(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
