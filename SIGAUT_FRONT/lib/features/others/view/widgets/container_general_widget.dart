import 'package:flutter/material.dart';
import 'package:sigaut_frontend/core/theme/custom_color_scheme.dart';
import 'package:sigaut_frontend/core/theme/custom_text_style.dart';
import 'package:sigaut_frontend/features/others/view/widgets/functions.dart';

class ContainerGeneralWidget extends StatefulWidget {
  final Widget body;
  final Function refreshFunction;
  final String titleHeader;
  final String? routeNameBack;
  final Function? addFunction;
  final Function? deleteSearchFunction;
  final Function? searchFunction;
  final String? titleSearch;
  final List<Widget> otherActions;
  final bool centerBody;

  const ContainerGeneralWidget({
    super.key,
    required this.body,
    required this.refreshFunction,
    required this.titleHeader,
    this.routeNameBack,
    this.addFunction,
    this.deleteSearchFunction,
    this.searchFunction,
    this.titleSearch,
    this.otherActions = const [],
    this.centerBody = false,
  });

  @override
  State<ContainerGeneralWidget> createState() => _ContainerGeneralWidgetState();
}

class _ContainerGeneralWidgetState extends State<ContainerGeneralWidget> {
  ScrollController scrollController = ScrollController();
  bool showBtnGoTop = false;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      //scroll listener
      double showOffset =
      10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showOffset) {
        if (showBtnGoTop) return;
        showBtnGoTop = true;
        setState(() {
          //update state
        });
      } else {
        if (!showBtnGoTop) return;
        showBtnGoTop = false;
        setState(() {
          //update state
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.cuartoBackground,
      resizeToAvoidBottomInset: false,
      extendBody: false,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: showBtnGoTop ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16 * 2.5),
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              scrollController.animateTo(
                //go to top of scroll
                  0, //scroll offset to go
                  duration: const Duration(milliseconds: 500),
                  //duration of scroll
                  curve: Curves.fastOutSlowIn //scroll type
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primaryBgButton,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primaryBackground,
                expandedHeight: widget.titleSearch != null ? 150.0 : 70.0,
                title: Text(
                  widget.titleHeader,
                  style: CustomTextStyle.semiBold18.copyWith(
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
                    color: Theme.of(context).colorScheme.primeroIcon,
                    size: 32,
                  ),
                ),
                actions: [
                  if (widget.addFunction != null) ...{
                    InkWell(
                      onTap: () => widget.addFunction!.call(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primeroIcon,
                            size: 32,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              "Registrar",
                              style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.cuartoText),
                            ),
                          )
                        ],
                      ),
                    ),
                  },
                  ...widget.otherActions,
                ],
                flexibleSpace: widget.titleSearch != null ? FlexibleSpaceBar(
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.cuartoBackground,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                            suffixIcon: textEditingController.text != ""
                                ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    textEditingController.clear();
                                    widget.searchFunction?.call();
                                  });
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).colorScheme.quinaryIcon,
                                  size: 32,
                                ))
                                : null,
                            hintText: widget.titleSearch,
                            hintStyle: CustomTextStyle.regular16.copyWith(color: Theme.of(context).colorScheme.primeroText),
                          ),
                          onSubmitted: (value) => widget.searchFunction?.call(value),
                          onChanged: (value) {
                            setState(() {
                              widget.searchFunction?.call(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ) : null,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: EdgeInsets.only(bottom: 16, top: 16),
                  color: Theme.of(context).colorScheme.segundoBackground,
                  child: widget.centerBody ? widget.body : SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: widget.body,
                  ),
                ),
              ),
            ],
        ),
        onRefresh: () async {
          await widget.refreshFunction();
        },
      ),
    );
  }
}
