import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/button_general_widget.dart';

class ShowCustomDialogWidget extends StatelessWidget {
  final double? borderRadiusTopLeft;
  final double? borderRadiusTopRight;
  final String title;
  final Icon? icon;
  final bool showActionClose;
  final bool showActionCancel;
  final bool showActionOk;
  final Widget child;
  final String? tittleCloseActionCancel;
  final String? tittleActionOk;
  final Function actionOk;
  final Function? actionCancel;

  const ShowCustomDialogWidget({
    super.key,
    this.borderRadiusTopRight,
    this.borderRadiusTopLeft,
    required this.title,
    this.icon,
    this.showActionClose = true,
    this.showActionCancel = true,
    this.showActionOk = true,
    required this.child,
    this.tittleCloseActionCancel,
    this.tittleActionOk,
    required this.actionOk,
    this.actionCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: dimension,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadiusTopLeft ?? 10),
                  topRight: Radius.circular(borderRadiusTopRight ?? 10)),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryBackground,
            title: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.semiBold18.copyWith(color: Theme.of(context).colorScheme.cuartoText)),
            leading: IconButton(
              onPressed: () => {},
              icon: icon ??
                  SvgPicture.asset(
                    "assets/images/svg/edit.svg",
                    height: 24,
                  ),
            ),
            actions: [
              if (showActionClose)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.primeroIcon,
                        size: 24,
                      )
                  ),
                ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: child,
          ),
          if (showActionCancel || showActionOk)
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryBackground20,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showActionCancel)
                      Flexible(
                        child: ButtonGeneralWidget(
                            onPressed: () {
                              if(actionCancel != null) {
                                actionCancel!();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            backgroundColor: Theme.of(context).colorScheme.secondaryBgButton,
                            height: 48,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tittleCloseActionCancel ?? "Cancelar",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.semiBold16.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryBtnText),
                              ),
                            )),
                      ),
                    if (showActionOk)
                      Flexible(
                        child: ButtonGeneralWidget(
                            onPressed: () {
                              actionOk();
                            },
                            backgroundColor:
                            Theme.of(context).colorScheme.senaryBgButton,
                            height: 48,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                tittleActionOk ?? "Continuar",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.semiBold16.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryBtnText),
                              ),
                            )),
                      )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
