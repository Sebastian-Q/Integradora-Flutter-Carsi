import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigaut_frontend/features/sale/viewModel/sale_bloc.dart';
import 'package:sigaut_frontend/features/product/model/product_model.dart';
import 'package:sigaut_frontend/features/sale/model/sale_model.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/button_general_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/others/view/widgets/top_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SaleScreen extends StatefulWidget {
  static const routeName = "/sale";
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  SaleBloc saleBloc = SaleBloc();
  TextEditingController searchController = TextEditingController();
  UserRepository userRepository = UserRepository();
  UserModel user = UserModel();

  /// Venta
  bool payCash = false;
  double total = 0;
  double acount = 0;
  List<ProductModel> listProducts = [];

  /// Scanner
  bool scannerEnabled = false;
  final MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await userRepository.getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: saleBloc,
      listener: (context, state) {
        if (state is StartLoadingState) loadingWidget(context, info: state.message);
        if (state is EndLoadingState) Navigator.pop(context);
        if (state is MessageState) showSnackBar(context, state.message.toString(), type: state.typeMessage);
        if (state is SuccessfulState) {
          setState(() => listProducts = []);
          showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
        }
        if (state is AddProductSaleState) {
          ProductModel existingProduct = listProducts.firstWhere(
                (product) => product.barCode == state.productModel.barCode,
            orElse: () => ProductModel(),
          );

          if (existingProduct.barCode != "") {
            setState(() => existingProduct.accountSale++);
          } else {
            setState(() => listProducts.add(state.productModel));
            showSnackBar(context, "Producto Agregado", type: AlertTypeMessage.success);
          }
          totalSale();
        }
      },
      child: saleWidget(),
    );
  }

  Widget saleWidget() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.segundoBackground,
        body: Column(
          children: [
            // 🔹 ENCABEZADO CON INPUT DE BARRA
            SizedBox(
              height: scannerEnabled ? 180 : 150,
              child: TopWidget(
                titleHeader: "Venta",
                expandedHeight: scannerEnabled ? 180 : 150,
                searchWidget: FlexibleSpaceBar(
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
                      child: scannerEnabled ? Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: MobileScanner(
                                controller: cameraController,
                                onDetect: (capture) {
                                  if (_isScanning) return;
                                  _isScanning = true; // evita múltiples lecturas rápidas

                                  final List<Barcode> barcodes = capture.barcodes;
                                  if (barcodes.isNotEmpty) {
                                    final code = barcodes.first.rawValue ?? "";
                                    debugPrint("Código detectado: $code");

                                    if (code.isNotEmpty) {
                                      saleBloc.add(AddProductSaleEvent(codeBar: code));
                                      searchController.text = code;
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        setState(() {
                                          scannerEnabled = false; // cierra cámara al leer
                                          _isScanning = false;
                                        });
                                      });
                                    } else {
                                      _isScanning = false;
                                    }
                                  }
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                onPressed: () {
                                  setState(() => scannerEnabled = false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ) : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.segundoBackground,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          style: CustomTextStyle.bold16.copyWith(
                            color: Theme.of(context).colorScheme.primaryInputColor,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/svg/barcode.svg',
                                height: 32,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.terceroIcon,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  scannerEnabled = !scannerEnabled; // 👈 activa/desactiva la cámara
                                });
                              },
                            ),
                            hintText: "Código de Barras",
                            hintStyle: CustomTextStyle.regular16.copyWith(
                              color: Theme.of(context).colorScheme.primeroText,
                            ),
                          ),
                          onSubmitted: (value) {
                            saleBloc.add(AddProductSaleEvent(codeBar: value));
                            searchController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 LISTA DE PRODUCTOS
            Expanded(
              child: listProducts.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Agregar productos a la venta",
                    style: CustomTextStyle.semiBold18.copyWith(
                      color: Theme.of(context).colorScheme.primeroText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(
                    "assets/images/sale_products.png",
                    height: 200,
                    width: 200,
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: listProducts.length,
                itemBuilder: (context, index) {
                  final product = listProducts[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name, style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.quintoText)),
                                Text("CB: ${product.barCode}", style: CustomTextStyle.semiBold14.copyWith(color: Theme.of(context).colorScheme.quintoText)),
                                Text("\$${product.price.toStringAsFixed(2)}", style: CustomTextStyle.semiBold14.copyWith(color: Theme.of(context).colorScheme.novenoText)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (product.accountSale == 1) {
                                        listProducts.removeAt(index);
                                      } else {
                                        product.accountSale--;
                                      }
                                      totalSale();
                                    });
                                  },
                                  child: _buildCircleButton(Icons.remove),
                                ),
                                Container(
                                  constraints: const BoxConstraints(minWidth: 30),
                                  child: Text("${product.accountSale}",
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.quintoText)),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      product.accountSale++;
                                      totalSale();
                                    });
                                  },
                                  child: _buildCircleButton(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 BOTÓN DE COBRAR (como ya lo tienes)
            if (listProducts.isNotEmpty) _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cuartoBackground,
        borderRadius: const BorderRadius.all(Radius.circular(95)),
        border: Border.all(color: const Color(0xFF94A3B8), width: 1),
        boxShadow: const [BoxShadow(color: Color(0x26FFFFFF), blurRadius: 4.0, offset: Offset(0.0, 0.75))],
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.segundoIcon),
    );
  }

  Widget _bottomBar() {
    return AnimatedSize(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 0),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 0, bottom: 8, right: 16, left: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Theme.of(context).colorScheme.cuartoBackground,
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), offset: Offset(0, -2), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: const EdgeInsets.only(left: 16),
              thumbIcon: thumbIcon,
              activeColor: Theme.of(context).colorScheme.secondaryBgButton,
              title: Text("¿Pago con tarjeta?",
                  style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.primeroText)),
              value: payCash,
              onChanged: (bool value) => setState(() => payCash = value),
            ),
            _infoRow("Productos", "$acount"),
            _infoRow("Total a pagar", "\$ ${total.toStringAsFixed(2)}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonGeneralWidget(
                  radius: const BorderRadius.all(Radius.circular(10)),
                  margin: EdgeInsets.zero,
                  height: 52,
                  backgroundColor: Theme.of(context).colorScheme.secondaryBgButton,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outlined, size: 24, color: Theme.of(context).colorScheme.primeroIcon),
                      Text("Cancelar", style: CustomTextStyle.regular10.copyWith(color: Theme.of(context).colorScheme.cuartoText)),
                    ],
                  ),
                  onPressed: () => setState(() => listProducts = []),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ButtonGeneralWidget(
                    backgroundColor: Theme.of(context).colorScheme.senaryBgButton,
                    height: 52,
                    margin: EdgeInsets.zero,
                    radius: const BorderRadius.all(Radius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Cobrar", style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.cuartoText)),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 24, color: Theme.of(context).colorScheme.primeroIcon),
                      ],
                    ),
                    onPressed: () {
                      SaleModel saleModel = SaleModel()
                        ..total = total
                        ..amountSale = acount
                        ..payMethod = payCash ? "Tarjeta" : "Efectivo"
                        ..employee = user.username
                        ..dateSale = DateTime.now()
                        ..productList = listProducts
                        ..idUser = user.id;

                      debugPrint("SALEMODE: ${saleModel.toSaveMap()}");
                      saleBloc.add(SaveSaleEvent(saleModel: saleModel));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.octavoText)),
        Text(value, style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.quintoText)),
      ]),
    );
  }

  void totalSale() {
    acount = 0;
    total = 0;
    for (var p in listProducts) {
      acount += p.accountSale;
      total += (p.accountSale * p.price);
    }
  }

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>((states) => states.contains(MaterialState.selected) ? const Icon(Icons.check) : const Icon(Icons.close));
}
