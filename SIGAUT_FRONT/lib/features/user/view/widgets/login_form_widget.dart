import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/core/utils/validate_config.dart';
import 'package:sigaut_frontend/features/others/view/widgets/button_general_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/form_input_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/others/view/widgets/show_custom_dialog_widget.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
import 'package:sigaut_frontend/features/user/view/register_screen.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  UserRepository userRepository = UserRepository();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormInputWidget(
                title: "Username",
                required: true,
                fieldController: usernameController,
                textAlign: TextAlign.center,
                iconSuffix: const Icon(Icons.perm_identity_outlined),
                exceptions: [ValidateConfig.required()],
              ),
              FormInputWidget(
                title: "Password",
                required: true,
                obscureText: !_isPasswordVisible,
                fieldController: passwordController,
                textAlign: TextAlign.center,
                iconSuffix: IconButton(
                  icon: _isPasswordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                exceptions: [ValidateConfig.required()],
              ),
              const SizedBox(
                height: 8
              ),
              GestureDetector(
                onTap: () => _showRecoverPassword(),
                child: Text(
                  "¿Olvido la contraseña?",
                  style: CustomTextStyle.semiBold12.copyWith(color: Theme.of(context).colorScheme.segundoText),
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              ButtonGeneralWidget(
                width: MediaQuery.of(context).size.width,
                height: 50,
                onPressed: _submitForm,
                backgroundColor: Theme.of(context).colorScheme.primaryBgButton,
                child: Text(
                  "Iniciar Sesión",
                  style: CustomTextStyle.semiBold16.copyWith(
                    color: Theme.of(context).colorScheme.primaryBtnText,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.pushNamed(context, RegisterScreen.routeName)
                },
                child: RichText(
                  text: TextSpan(
                      text: "¿No tienes una cuenta?",
                      style: CustomTextStyle.semiBold14.copyWith(
                          color: Theme.of(context).colorScheme.segundoText),
                      children: [
                        TextSpan(
                          text: " Registrate",
                          style: CustomTextStyle.semiBold14.copyWith(
                              color: Theme.of(context).colorScheme.quintoText),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      loadingWidget(context);
      String response = await userRepository.login(username: usernameController.text, password: passwordController.text);
      Navigator.pop(context);
      if (response == "exito") {
        //Navigator.pushNamed(context, SaleScreen.routeName); // TODO: Descomentar cuando esté la pantalla de ventas
      } else {
        showSnackBar(context, response, type: AlertTypeMessage.error);
      }
    }
  }

  void _showRecoverPassword()  {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.primary)),
          child: ShowCustomDialogWidget(
            title: "Recuperar Contraseña",
            tittleActionOk: "Enviar correo",
            tittleCloseActionCancel: "Cancelar",
            icon: Icon(
              Icons.email_outlined,
              color: Theme.of(context).colorScheme.primeroIcon,
              size: 24,
            ),
            actionOk: () {},
            child: Form(
              key: _emailKey,
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customSizeHeight,
                    Text(
                      "Favor de introducir el correo electrónico vinculado con la cuenta, para enviar un correo de recuperación.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.quintoText,
                      ),
                    ),
                    FormInputWidget(
                      title: "Correo electrónico",
                      fieldController: emailController,
                      exceptions: [
                        ValidateConfig.email(),
                        ValidateConfig.required()
                      ],
                    ),
                    customSizeHeight,
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
