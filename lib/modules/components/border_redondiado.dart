import 'package:flutter/material.dart';

class BorderRedondiado extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double? bottom;

  const BorderRedondiado({
    super.key,
    required this.top,
    this.left,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46), topRight: Radius.circular(46)),
        ),
      ),
    );
  }
}
