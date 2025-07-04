import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'body_widget.dart';

class AppScaffold extends StatelessWidget {
  final bool hideAppBar;
  //
  final Widget? leadingWidget;
  final Widget? appBarTitle;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool automaticallyImplyLeading;
  final double? appBarelevation;
  final String? appBartitleText;
  final Color? appBarbackgroundColor;
  final double? appBarheight;
  //
  final Widget body;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  //
  final Widget? bottomNavBar;
  final Widget? fabWidget;
  final bool hasLeadingWidget;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomPadding;
  final PreferredSizeWidget? appBarWidget;

  const AppScaffold({
    super.key,
    this.hideAppBar = false,
    //
    this.leadingWidget,
    this.appBarTitle,
    this.actions,
    this.appBarelevation = 0,
    this.appBartitleText,
    this.appBarbackgroundColor,
    this.isCenterTitle = false,
    this.hasLeadingWidget = true,
    this.automaticallyImplyLeading = false,
    this.appBarheight,
    //
    required this.body,
    this.isLoading,
    //
    this.bottomNavBar,
    this.fabWidget,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
    this.appBarWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      appBar: hideAppBar
          ? null
          : PreferredSize(
              preferredSize: Size(Get.width, appBarheight ?? 66),
              child: AppBar(
                elevation: appBarelevation,
                automaticallyImplyLeading: automaticallyImplyLeading,
                backgroundColor: appBarbackgroundColor ?? Colors.white,
                centerTitle: isCenterTitle,
                titleSpacing: 2,
                title: appBarTitle ??
                    Text(
                      appBartitleText ?? "",
                      style: primaryTextStyle(size: 16),
                    ).paddingLeft(hasLeadingWidget ? 0 : 16),
                actions: actions,
                leading:
                    leadingWidget ?? (hasLeadingWidget ? backButton() : null),
              ).paddingTop(10),
            ),
      backgroundColor: scaffoldBackgroundColor ?? Colors.white,
      body: Body(
        isLoading: isLoading ?? false.obs,
        child: body,
      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: fabWidget,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

Widget backButton({Object? result}) {
  return IconButton(
    onPressed: () {
      Get.back(result: result);
    },
    icon: const Icon(Icons.arrow_back_ios_new_outlined,
        color: Colors.grey, size: 20),
  );
}
