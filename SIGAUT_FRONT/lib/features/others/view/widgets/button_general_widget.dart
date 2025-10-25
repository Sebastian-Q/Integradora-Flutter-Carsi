import 'package:flutter/material.dart';

class ButtonGeneralWidget extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Gradient? gradient;
  final BorderRadius radius;
  final VoidCallback? onPressed;
  final BoxBorder border;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool loading;

  const ButtonGeneralWidget({
    super.key,
    required this.child,
    this.width,
    this.height = 40.0,
    this.backgroundColor,
    this.highlightColor,
    this.splashColor,
    this.gradient,
    this.radius = const BorderRadius.all(Radius.circular(30)),
    this.border = const Border.fromBorderSide(
      BorderSide(
        color: Color(0x00000000),
        width: 0,
        style: BorderStyle.solid,
      ),
    ),
    this.padding = const EdgeInsets.only(left: 6, right: 6),
    this.margin = const EdgeInsets.all(6),
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        gradient: gradient,
        borderRadius: radius,
        border: border,
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              highlightColor:
              highlightColor ?? Theme.of(context).highlightColor,
              splashColor: splashColor ?? Theme.of(context).splashColor,
              onTap: onPressed,
              child: Padding(
                padding: padding,
                child: Center(
                  child: child,
                ),
              ),
            ),
          ),
          /*
            if (loading)
            Align(
              alignment: Alignment.center,
              child: loadingWidget(context),
            ),
             */
        ],
      ),
    );
  }
}
