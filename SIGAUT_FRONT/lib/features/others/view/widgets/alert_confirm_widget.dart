import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/show_custom_dialog_widget.dart';

Future<bool> confirmAlert(BuildContext context, {required String title, bool showCancel = true, String? textContent}) async {
  final bool? isConfirm = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.primary)),
        child: ShowCustomDialogWidget(
          title: title,
          showActionCancel: showCancel,
          actionOk: () {
            Navigator.of(context).pop(true);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              textContent ?? '',
              maxLines: 5,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bold16.copyWith(
                  color: Theme.of(context).colorScheme.primeroText),
            ),
          ),
        ),
      );
    },
  );

  return isConfirm ?? false;
}
