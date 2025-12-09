import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/core/utils/validate_config.dart';
import 'package:sigaut_frontend/features/category/model/category_model.dart';
import 'package:sigaut_frontend/features/category/repository/category_repository.dart';
import 'package:sigaut_frontend/features/others/view/widgets/form_input_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/show_custom_dialog_widget.dart';
import 'package:sigaut_frontend/features/product/model/product_model.dart';
import 'package:sigaut_frontend/features/product/viewModel/product_bloc.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';

class ProductFormWidget extends StatefulWidget {
  final String title;
  final ProductModel? productModel;

  const ProductFormWidget({super.key, required this.title, this.productModel});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late ProductBloc productBloc;
  ProductModel productModel = ProductModel();
  UserRepository userRepository = UserRepository();

  final _formProductKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController codeBarController;
  late TextEditingController stockController;
  late TextEditingController countMinController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  late TextEditingController categoryController;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    productBloc = context.read<ProductBloc>();
    if (widget.productModel != null) {
      productModel = widget.productModel!;
      selectedCategory = productModel.category;
    }
    nameController = TextEditingController(text: productModel.name);
    codeBarController = TextEditingController(text: productModel.barCode);
    stockController = TextEditingController(text: "${productModel.stock != 0 ? productModel.stock  : ""}");
    countMinController = TextEditingController(text: "${productModel.quantityMinima  != 0 ? productModel.quantityMinima  : ""}");
    priceController = TextEditingController(text: "${productModel.price != 0 ? productModel.price  : ""}");
    descriptionController = TextEditingController(text: productModel.description);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCustomDialogWidget(
      title: widget.title,
      actionOk: () {
        _submitForm();
      },
      child: Form(
        key: _formProductKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormInputWidget(
                  topPadding: 8,
                  title: "Nombre",
                  required: true,
                  fieldController: nameController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.name = nameController.text;
                  },
                  exceptions: [
                    ValidateConfig.required()
                  ],
                ),
                FormInputWidget(
                  title: "Codigo de Barras",
                  required: true,
                  fieldController: codeBarController,
                  textAlign: TextAlign.center,
                  inputType: TextInputType.number,
                  onSave: (value) {
                    productModel.barCode = codeBarController.text;
                  },
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.whiteSpaces(),
                    ValidateConfig.minLength(13),
                    ValidateConfig.maxLength(13),
                  ],
                ),
                FormInputWidget(
                  title: "Stock",
                  required: true,
                  fieldController: stockController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.stock = double.parse(stockController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  title: "Cantidad Minima",
                  required: true,
                  fieldController: countMinController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.quantityMinima = double.parse(countMinController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),
                FormInputWidget(
                  title: "Precio",
                  required: true,
                  bottomPadding: 8,
                  fieldController: priceController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.price = double.parse(priceController.text);
                  },
                  inputType: TextInputType.number,
                  exceptions: [
                    ValidateConfig.required(),
                    ValidateConfig.numbers(),
                    ValidateConfig.decimalPrecision(),
                    ValidateConfig.whiteSpaces()
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: FutureBuilder<List<CategoryModel>>(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error al cargar categorías');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No hay categorías disponibles');
                      }

                      final categories = snapshot.data!;

                      return DropdownButtonFormField<CategoryModel>(
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        value: selectedCategory,
                        items: categories.map((cat) {
                          return DropdownMenuItem<CategoryModel>(
                            value: cat,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            productModel.category = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) return 'Seleccione una categoría';
                          return null;
                        },
                      );
                    },
                  ),
                ),
                FormInputWidget(
                  bottomPadding: 8,
                  title: "Descripción",
                  fieldController: descriptionController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    productModel.description = descriptionController.text;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formProductKey.currentState!.validate()) {
      _formProductKey.currentState!.save();
      UserModel user = await userRepository.getLocalUser();
      productModel.idUser = user.id;
      if (productModel.id == 0) {
        productBloc.add(SaveProductEvent(productModel: productModel));
      } else {
        productBloc.add(EditProductEvent(productModel: productModel));
      }
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    CategoryRepository categoryRepository = CategoryRepository();
    try {
      List<CategoryModel> listCategories = await categoryRepository.allCategories();
      return listCategories;
    } catch (e) {
      debugPrint("ERROR: $e");
      throw Exception('Error al obtener los datos');
    }
  }
}
