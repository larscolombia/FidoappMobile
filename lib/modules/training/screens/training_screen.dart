import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/home/screens/pages/training.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/training/controllers/training_controller.dart';
import 'package:pawlly/modules/training/screens/pages/commands.dart';
import 'package:pawlly/screens_demo/controller/user_default_test.dart';
import 'package:pawlly/styles/styles.dart';

class TrainingScreen extends StatelessWidget {
  TrainingScreen({super.key});
  final TrainingController homeController = Get.put(TrainingController());

  @override
  Widget build(BuildContext context) {
    final UserDefaultTest userController = Get.put(UserDefaultTest());
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context)
                    .size
                    .height, // Ocupa al menos toda la pantalla
              ),
              padding: const EdgeInsets.only(
                  bottom: 100), // Ajuste para el espacio inferior
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderNotification(),
                  Container(
                    padding: Styles.paddingAll,
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        ProfilesDogs(),
                        SizedBox(height: 16),
                        Training(),
                        SizedBox(height: 16),
                        Commands(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                // Container que proporciona el fondo blanco con degradado
                Container(
                  height:
                      135, // Altura ajustada para cubrir el menú y el margen inferior
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white, // Fondo blanco
                        Colors.white
                            .withOpacity(0.5), // Degradado hacia transparente
                        Colors.white.withOpacity(0.3), // Transparente
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                // El MenuOfNavigation encima del fondo con degradado
                Positioned(
                  left: 25,
                  right: 25,
                  bottom: 30,
                  child: MenuOfNavigation(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
