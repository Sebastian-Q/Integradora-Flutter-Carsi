import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/features/sale/viewModel/sale_bloc.dart';
import 'package:sigaut_frontend/features/sale/model/sale_model.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/container_general_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/form_input_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';
import 'package:sigaut_frontend/features/others/view/widgets/show_custom_dialog_widget.dart';
import 'package:intl/intl.dart';

class ReportSaleScreen extends StatefulWidget {
  static const routeName = "/report/sale";

  const ReportSaleScreen({super.key});

  @override
  State<ReportSaleScreen> createState() => _ReportSaleScreenState();
}

class _ReportSaleScreenState extends State<ReportSaleScreen> {
  SaleBloc saleBloc = SaleBloc();
  List<SaleModel> listSales = [];
  bool loading = false;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saleBloc.add(AllSalesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener(
        bloc: saleBloc,
        listener: (context, state) {
          if (state is StartLoadingState) {
            loadingWidget(context, info: state.message);
          }
          if (state is EndLoadingState) {
            Navigator.pop(context);
          }

          if (state is AllSalesState) {
            setState(() {
              listSales = state.listSales;
              loading = true;
            });
          }
        },
        child: ContainerGeneralWidget(
          titleHeader: "Reporte de ventas",
          body: body,
          centerBody: listSales.isEmpty,
          refreshFunction: () {
            saleBloc.add(AllSalesEvent());
          },
          /*otherActions: [
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
                        child: ShowCustomDialogWidget(
                            title: "Filtro de ventas",
                            actionCancel: () {
                              startDateController.text = "";
                              endDateController.text = "";
                              Navigator.pop(context);
                              saleBloc.add(AllSalesEvent());
                            },
                            actionOk: () {
                              Navigator.pop(context);
                              saleBloc.add(AllSalesEvent(startDate: startDateController.text, endDate: endDateController.text));
                            },
                            tittleActionOk: 'Aplicar filtros',
                            tittleCloseActionCancel: "Borrar filtros",
                            showActionCancel: true,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: FormInputWidget(
                                          title: "Fecha Inicio",
                                          fieldController: startDateController,
                                        )
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: FormInputWidget(
                                          title: "Fecha Fin",
                                          fieldController: endDateController,
                                        )
                                    ),
                                  ],
                                ),
                                customSizeHeight
                              ],
                            )
                        )
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                size: 32,
                color: Colors.white,
              ),
            )
          ],*/
        ),
      ),
    );
  }

  Widget get body {
    if (listSales.isNotEmpty) {
      return Column(
        children: List.generate(listSales.length, (index) {
          final report = listSales[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.quintoBackground,
                border: Border.all(color: Theme.of(context).colorScheme.primeroBorder, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Venta de Productos",
                        style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.septimoText),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Folio - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: "${report.id}",
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Fecha - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: DateFormat('dd/MM/yyyy').format(report.dateSale),
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Vendido por - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: report.employee,
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Pago - ",
                                style: CustomTextStyle.medium10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                children: [
                                  TextSpan(
                                    text: report.payMethod,
                                    style: CustomTextStyle.bold10.copyWith(color: Theme.of(context).colorScheme.septimoText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Monto",
                              style: CustomTextStyle.medium12.copyWith(color: Theme.of(context).colorScheme.septimoText),
                            ),
                            Text(
                              "\$${report.total}",
                              style: CustomTextStyle.semiBold14.copyWith(color: Theme.of(context).colorScheme.septimoText),
                            )
                          ],
                        ),
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
        "No hay reportes de ventas registrados",
        textAlign: TextAlign.center,
        style: CustomTextStyle.bold32.copyWith(
          color: Theme.of(context).colorScheme.segundoText,
        ),
      ),
    );
  }
}
