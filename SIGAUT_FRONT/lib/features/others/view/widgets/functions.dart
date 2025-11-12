import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/top_menu_widget.dart';

enum AlertTypeMessage { error, success, warning, info, ask }

void onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

loadingWidget(BuildContext context, {String? info, bool barrierDismissible = false}) {
  showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: barrierDismissible,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF1A5ED7),
              ),
              if (info != null) ...[
                const SizedBox(
                  height: 16,
                ),
                Text(
                  info,
                  style: CustomTextStyle.semiBold18.copyWith(
                      color: Theme.of(context).colorScheme.cuartoText),
                )
              ]
            ],
          ),
        ),
      );
    },
  );
}

showSnackBar(BuildContext context, String message, {type = AlertTypeMessage.success, duration = const Duration(seconds: 5), IconData? icon}) {
  onWidgetDidBuild(() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.medium14.copyWith(
                      color: type == AlertTypeMessage.warning
                          ? const Color(0xFF664d03)
                          : Theme.of(context).colorScheme.cuartoText,
                    ),
                  ),
                ),
              ),
              Icon(
                icon ??
                    (type == AlertTypeMessage.error ? Icons.error : type == AlertTypeMessage.warning ? Icons.warning : Icons.check),
                color: type == AlertTypeMessage.warning
                    ? Theme.of(context).colorScheme.octavoIcon
                    : Theme.of(context).colorScheme.novenoIcon,
              ),
            ],
          ),
          backgroundColor: type == AlertTypeMessage.error
              ? Theme.of(context).colorScheme.error
              : type == AlertTypeMessage.warning
              ? const Color(0xFFFFF3CD)
              : Theme.of(context).colorScheme.success,
        ),
      );
  });
}

Widget get customSizeHeight => const SizedBox(
  height: 16,
);

Widget get customWidth => const SizedBox(
  width: 16,
);

Widget get customMediumSizeHeight => const SizedBox(
  height: 8,
);

void goBack(BuildContext context, String routeName) {
  Navigator.popAndPushNamed(context, routeName);
}

void showTopMenu(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 500),
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, _, __) {
      return TopMenuWidget();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: Curves.easeIn,
        ).drive(Tween<Offset>(
          begin: const Offset(0, -1.0),
          end: Offset.zero,
        )),
        child: child,
      );
    },
  );
}

String getDioErrorMessage(DioException e) {
  try {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['data'] ?? e.response?.data['message'] ?? 'Error desconocido';
    }
    return e.message ?? 'Error desconocido';
  } catch (_) {
    return 'Error desconocido';
  }
}
