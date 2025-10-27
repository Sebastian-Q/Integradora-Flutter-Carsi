import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';

class CustomSvgWidget extends StatelessWidget {
  final String svgPath;
  final double height;
  final double? width;
  final Color? color;

  final BoxFit? fit;

  const CustomSvgWidget(
      {super.key,
        required this.svgPath,
        this.height = 48,
        this.width = 48,
        this.color,
        this.fit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      allowDrawingOutsideViewBox: true,
      colorFilter: ColorFilter.mode(
          color == null ? Theme.of(context).colorScheme.terceroIcon : color!,
          BlendMode.srcIn),
    );
  }
}
