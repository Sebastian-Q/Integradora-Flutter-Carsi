import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/user/view/widgets/login_form_widget.dart';
class LoginScreen extends StatefulWidget {
  static const routeName = '/auth/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.quinaryBackground,
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryBackground
          ),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Text("Abarrotes UTEZ", style: CustomTextStyle.bold32.copyWith(color: Theme.of(context).colorScheme.quinaryBackground),),
                    const SizedBox(height: 16,),
                    Expanded(
                      child: Image.asset(
                        "assets/images/new_logo.png",
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container (
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                      ),
                      child: const LoginFormWidget(),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
