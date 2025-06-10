import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'loader_widget.dart';

class Body extends StatelessWidget {
  final Widget child;
  final RxBool isLoading;

  const Body({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          Obx(() => const LoaderWidget().center().visible(isLoading.value)),
        ],
      ),
    );
  }
}
