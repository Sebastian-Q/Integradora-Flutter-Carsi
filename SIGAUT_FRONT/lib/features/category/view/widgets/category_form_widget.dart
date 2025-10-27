import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigaut_frontend/features/category/viewModel/category_bloc.dart';
import 'package:sigaut_frontend/features/category/model/category_model.dart';
import 'package:sigaut_frontend/features/user/model/user_model.dart';
import 'package:sigaut_frontend/features/user/repository/user_repository.dart';
import 'package:sigaut_frontend/core/utils/validate_config.dart';
import 'package:sigaut_frontend/features/others/view/widgets/form_input_widget.dart';
import 'package:sigaut_frontend/features/others/view/widgets/show_custom_dialog_widget.dart';

class CategoryFormWidget extends StatefulWidget {
  final String title;
  final CategoryModel?  categoryModel;
  const CategoryFormWidget({super.key, required this.title, this.categoryModel});

  @override
  State<CategoryFormWidget> createState() => _CategoryFormWidgetState();
}

class _CategoryFormWidgetState extends State<CategoryFormWidget> {
  late CategoryBloc categoryBloc;
  CategoryModel categoryModel = CategoryModel();
  UserRepository userRepository = UserRepository();

  final _formCategoryKey = GlobalKey<FormState>();
  late TextEditingController claveController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    categoryBloc = context.read<CategoryBloc>();
    if (widget.categoryModel != null) {
      categoryModel = widget.categoryModel!;
    }
    claveController = TextEditingController(text: categoryModel.clave);
    nameController = TextEditingController(text: categoryModel.name);
    descriptionController = TextEditingController(text: categoryModel.description);
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
        key: _formCategoryKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormInputWidget(
                  topPadding: 8,
                  title: "Clave",
                  required: true,
                  fieldController: claveController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    categoryModel.clave = claveController.text;
                  },
                  exceptions: [
                    ValidateConfig.required()
                  ],
                ),
                FormInputWidget(
                  topPadding: 8,
                  title: "Nombre",
                  required: true,
                  fieldController: nameController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    categoryModel.name = nameController.text;
                  },
                  exceptions: [
                    ValidateConfig.required()
                  ],
                ),
                FormInputWidget(
                  bottomPadding: 8,
                  title: "Descripción",
                  fieldController: descriptionController,
                  textAlign: TextAlign.center,
                  onSave: (value) {
                    categoryModel.description = descriptionController.text;
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
    if (_formCategoryKey.currentState!.validate()) {
      _formCategoryKey.currentState!.save();
      UserModel user = await userRepository.getLocalUser();
      categoryModel.idUser = user.id;
      if (categoryModel.id == 0) {
        categoryBloc.add(SaveCategoryEvent(categoryModel: categoryModel));
      } else {
        categoryBloc.add(EditCategoryEvent(categoryModel: categoryModel));
      }
    }
  }
}
