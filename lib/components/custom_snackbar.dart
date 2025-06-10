import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

import '../modules/components/style.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      titleText: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Lato',
          ),
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: isError ? Styles.iconColorBack : Colors.green,
          child: Icon(
            isError
                ? EvaIcons.alertTriangleOutline
                : EvaIcons.checkmarkCircle2Outline,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      messageText: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            height: 1.3,
            fontFamily: 'Lato',
          ),
          overflow: TextOverflow.visible,
          maxLines: 3,
        ),
      ),
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
