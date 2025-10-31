import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/category/view/categories_screen.dart';
import 'package:sigaut_frontend/features/user/view/login_screen.dart';
import 'package:sigaut_frontend/features/user/view/profile_screen.dart';

class TopMenuWidget extends StatefulWidget {
  const TopMenuWidget({super.key});

  @override
  State<TopMenuWidget> createState() => _TopMenuWidgetState();
}

class _TopMenuWidgetState extends State<TopMenuWidget> {
  UserRepository userRepository = UserRepository();
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await userRepository.getLocalUser();
    debugPrint("USER: ${user.toMap()}");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryBackground,
              title: Container(
                padding: const EdgeInsets.all(15),
                child: Text("Menú", style: CustomTextStyle.semiBold26.copyWith(color: Theme.of(context).colorScheme.cuartoText),),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/svg/arrow_back.svg',
                        height: 32,
                        fit: BoxFit.contain,
                        allowDrawingOutsideViewBox: true,
                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primeroIcon, BlendMode.srcIn),
                      ),
                      onPressed: () => Navigator.pop(context))
              ),
            ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9, maxWidth: 500),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryBackground,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white
                        ),
                        child: Column(
                          children: [
                            option(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, ProfileScreen.routeName);
                              },
                              title: "Perfil",
                              icon: Icon(
                                  Icons.account_circle_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.cuartoIcon
                              ),
                            ),
                            option(
                              onTap: () {
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, SaleScreen.routeName);
                              },
                              title: "Vender",
                              icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.cuartoIcon
                              ),
                            ),
                            option(
                                onTap: (){
                                  Navigator.pop(context);
                                  //Navigator.pushNamed(context, ProductsScreen.routeName);
                                },
                                title: "Productos",
                                image: "assets/images/svg/products.svg"
                            ),
                            option(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, CategoriesScreen.routeName);
                              },
                              title: "Categoria",
                              icon: Icon(
                                  Icons.category_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.cuartoIcon
                              ),
                            ),

                            option(
                              onTap: () {
                                Navigator.pop(context);
                                //Navigator.pushNamed(context, ReportSaleScreen.routeName);
                              },
                              title: "Reportes",
                              icon: Icon(
                                  Icons.monetization_on_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.cuartoIcon
                              ),
                            ),

                            option(
                              onTap: () {
                                Navigator.pop(context);
                                userRepository.deleteLocalUser();
                                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                              },
                              title: "Cerrar sesión",
                              icon: Icon(
                                  Icons.logout_outlined,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.cuartoIcon
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                              child: Container(height: 2, color: const Color(0xFFC5D4E8),),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 30,
                width: 70,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryBackground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset("assets/images/svg/arrow_up.svg",
                        height: 26, width: 17, fit: BoxFit.scaleDown),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget option({required Function onTap, String? image, Icon? icon, required String title}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Container(height: 2, color: const Color(0xFFC5D4E8),),
        ),
        InkWell(
          onTap: () {
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.cuartoBackground,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: image != null ? SvgPicture.asset(
                      image,
                      height: 24,
                      color: Theme.of(context).colorScheme.cuartoIcon
                  ) : icon,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Text(title, style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.quintoText)),
                ),
                Spacer(),
                const Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Icon(Icons.arrow_forward_ios_outlined, size: 18,)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
