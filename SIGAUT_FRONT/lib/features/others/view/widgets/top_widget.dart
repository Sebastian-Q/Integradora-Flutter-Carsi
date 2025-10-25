import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

class TopWidget extends StatefulWidget {
  final bool extendedBody;
  final Widget? searchWidget;
  final String titleHeader;
  final double expandedHeight;

  const TopWidget({
    super.key,
    this.extendedBody = false,
    this.searchWidget,
    required this.titleHeader,
    this.expandedHeight = 150.0,
  });

  @override
  State<TopWidget> createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryBackground,
          expandedHeight: widget.expandedHeight,
          title: Text(
            widget.titleHeader,
            style: CustomTextStyle.semiBold26.copyWith(
                color: Theme.of(context).colorScheme.cuartoText),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (!mounted) return;
              showTopMenu(context);
            },
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Theme.of(context).colorScheme.primeroIcon,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          flexibleSpace: widget.searchWidget,
        ),
      ],
    );
  }
}