import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/alert_confirm_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/container_general_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/product/model/product_model.dart';
import 'package:sigaut_frontend/features/product/view/widgets/product_form_widget.dart';
import 'package:sigaut_frontend/features/product/viewModel/product_bloc.dart';


class ProductsScreen extends StatefulWidget {
  static const routeName = "/productos";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc productBloc = ProductBloc();
  List<ProductModel> listProducts = [];


  @override
  void initState() {
    super.initState();
    productBloc.add(AllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: productBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }

          if (state is SuccessfulState) {
            if(state.exitWidget) {
              Navigator.pop(context);
            }
            productBloc.add(AllProductsEvent());
            showSnackBar(context, state.message.toString(), type: AlertTypeMessage.success);
          }

          if (state is MessageState) {
            Navigator.pop(context);
            showSnackBar(context, state.message.toString(), type: state.typeMessage);
          }

          if (state is ErrorState) {
            confirmAlert(context, title: "Error", textContent: state.message, showCancel: false);
          }

          if (state is AllProductsState) {
            setState(() {
              listProducts = state.listProducts;
            });
          }
        },
        child: ContainerGeneralWidget(
          titleHeader: "Productos",
          titleSearch: "Codigo barras / Nombre",
          body: body,
          refreshFunction: () {
            productBloc.add(AllProductsEvent());
          },
          addFunction: addProduct,
        ),
      ),
    );
  }

  Widget get body {
    if (listProducts.isNotEmpty) {
      return Column(
        children: List.generate(listProducts.length, (index) {
          final product = listProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorBorder(product.stock, product.quantityMinima), width: 2),
                color: Theme.of(context).colorScheme.quinaryBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.terceroText),
                            ),
                            Text("\$${product.price}", style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.terceroText),),
                          ],
                        ),
                        customMediumSizeHeight,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "CB: ${product.barCode}",
                              style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                            Text(
                              "Stock: ${product.stock}",
                              textAlign: TextAlign.end,
                              style: CustomTextStyle.semiBold16.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                          ],
                        ),
                        customMediumSizeHeight,
                        if(product.description != "")...{
                          Align(
                            alignment: AlignmentGeometry.centerLeft,
                            child: Text(
                              product.description,
                              style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.sextoText),
                            ),
                          )
                        },
                      ],
                    ),
                  ),

                  Container(
                    height: 2,
                    color: colorBorder(product.stock, product.quantityMinima),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return Dialog(
                                    elevation: 0,
                                    insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary)),
                                    child: BlocProvider.value(
                                      value: productBloc,
                                      child: ProductFormWidget(title: "Editar Producto", productModel: product,),
                                    )
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.sextoIcon,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            confirmAlert(context,
                                title: "Eliminar Producto",
                                textContent: '¿Deseas eliminar al producto: "${product.name}?"').then((value) {
                              if(value) {
                                productBloc.add(DeleteProductEvent(id: product.id));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.sextoIcon,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return Center(
      child: Text(
        "No hay productos registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(
          color: Theme.of(context).colorScheme.segundoText,
        ),
      ),
    );
  }

  Color colorBorder(double stock, double amountMin) {
    if (stock > amountMin) {
      return Theme.of(context).colorScheme.primeroBorder;
    }
    if (stock == amountMin) {
      return Theme.of(context).colorScheme.segundoBorder;
    }
    return Theme.of(context).colorScheme.terceroBorder;
  }

  void addProduct() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary)),
            child: BlocProvider.value(
              value: productBloc,
              child: const ProductFormWidget(title: "Registrar Producto",),
            )
        );
      },
    );
  }
}
