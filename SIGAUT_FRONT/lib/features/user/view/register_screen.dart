import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/others/view/widgets/navigation_helper.dart';
import 'package:sigaut_frontend/features/sale/view/sale_screen.dart';
import 'package:sigaut_frontend/features/user/view/login_screen.dart';
import 'package:sigaut_frontend/features/user/view/widgets/register_form_widget.dart';
import 'package:sigaut_frontend/features/user/viewModel/user_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/auth/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  UserBloc userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: userBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }
          if (state is SuccessfulState) {
            showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
            Future.delayed(const Duration(milliseconds: 500), () {
              NavigationHelper.navigateReplacement(context, const SaleScreen());
              //Navigator.pushNamed(context, SaleScreen.routeName);
            });
          }
          if (state is MessageState) {
            showSnackBar(context, state.message.toString(), type: state.typeMessage);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.segundoBackground,
          body: Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryBackground),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.primaryBackground,
                  leading: IconButton(
                    onPressed: () {
                      NavigationHelper.navigateReplacement(context, const LoginScreen());
                      //Navigator.pop(context, LoginScreen.routeName);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.primeroIcon,
                      size: 32,
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.55,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 50, 20, 40),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Abarrotes UTEZ", style: CustomTextStyle.bold32.copyWith(color: Theme.of(context).colorScheme.quinaryBackground),),
                              const SizedBox(height: 20),
                              Image.asset(
                                "assets/images/new_logo.png",
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.segundoBackground,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 5,
                            width: 70,
                            decoration: const BoxDecoration(
                                color: Color(0xFFCBD4E1),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                          child: BlocProvider.value(
                            value: userBloc,
                            child: const RegisterFormWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
