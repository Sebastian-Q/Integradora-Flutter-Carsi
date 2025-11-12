import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/core/utils/validate_config.dart';

class FormInputWidget extends StatefulWidget {
  final String title;
  final bool required;

  final TextEditingController? fieldController;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final Function? onSave;
  final Function? onChange;
  final Function? onTap;
  final List<ValidateConfig>? exceptions;
  final TextInputType? inputType;
  final Widget? icon; // Icons.person
  final Widget? iconSuffix; // Icons.clear
  final TextAlign? textAlign;
  final Function? onTapOutside;
  final bool obscureText;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? customTextStyle;
  final double? topPadding;
  final double? bottomPadding;
  final FocusNode? focusNode;


  const FormInputWidget(
      {super.key,
        required this.title,
        this.required = false,
        this.fieldController,
        this.maxLength,
        this.onSave,
        this.onChange,
        this.onTap,
        this.exceptions,
        this.maxLines = 1,
        this.inputType = TextInputType.text,
        this.icon,
        this.autofocus = false,
        this.readOnly = false,
        this.enabled = true,
        this.textAlign = TextAlign.left,
        this.iconSuffix,
        this.obscureText = false,
        this.textInputAction = TextInputAction.none,
        this.inputFormatters,
        this.onTapOutside,
        this.initialValue,
        this.customTextStyle,
        this.topPadding,
        this.bottomPadding,
        this.focusNode});

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, widget.topPadding ?? 16, 16, widget.bottomPadding ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 5),
            child: RichText(
              text: TextSpan(
                  text: widget.title,
                  style: CustomTextStyle.semiBold12.copyWith(color: Theme.of(context).colorScheme.primeroText),
                  children: [
                    if(widget.required)...{
                      TextSpan(
                          text: " *",
                          style: CustomTextStyle.semiBold12.copyWith(color: Theme.of(context).colorScheme.segundoText)
                      )
                    }
                  ]
              ),
            ),
          ),
          TextFormField(
            initialValue: widget.initialValue,
            focusNode: widget.focusNode,
            onTapOutside: (val){
              FocusManager.instance.primaryFocus?.unfocus();
              Function? localOnTapOutside = widget.onTapOutside;
              if (localOnTapOutside != null) localOnTapOutside();
            },
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: widget.textInputAction,
            controller: widget.fieldController,
            autofocus: widget.autofocus,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            textAlign: widget.textAlign!,
            scrollPadding: const EdgeInsets.all(8.0),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              suffixIcon: Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: widget.iconSuffix ??
                    Visibility(
                      visible: canClear,
                      child: InkWell(
                        onTap: () {
                          widget.fieldController?.clear();
                          Function? localOnchange = widget.onChange;
                          if (localOnchange != null) localOnchange(null);
                        },
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.quinaryIcon,
                        ),
                      ),
                    ),
              ),
              prefixIcon: widget.icon,
            ),
            style: widget.customTextStyle ??
                CustomTextStyle.bold16.copyWith(
                    color: Theme.of(context).colorScheme.primaryInputColor),
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.inputType,
            onSaved: (val) {
              Function? localOnSave = widget.onSave;
              if (localOnSave != null) localOnSave(val);
            },
            onChanged: (val) {
              Function? localOnchange = widget.onChange;
              if (localOnchange != null) localOnchange(val);
            },
            onTap: widget.onTap as void Function()? ?? () {},
            validator: (val) {
              List<ValidateConfig>? localExceptions = widget.exceptions;
              if (localExceptions != null) {
                return ValidateConfig.validate(val, localExceptions);
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  bool get canClear => widget.readOnly == false && widget.enabled == true;
}
