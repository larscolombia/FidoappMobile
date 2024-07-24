import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/pages/prodile_dogs.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/screens_demo/controller/user_default_test.dart';
import 'package:pawlly/modules/home/screens/pages/explorar_container.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/utilidades.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  // Asegúrate de inicializar el controlador correctamente

  @override
  Widget build(BuildContext context) {
    final UserDefaultTest userController = Get.put(UserDefaultTest());
    return Scaffold(
      body: Scaffold(
        body: Column(
          children: [
            HeaderNotification(),
            ProfilesDogs(),
            Explore(),
            Utilidades(),
          ],
        ),
      ),
      bottomNavigationBar: MenuOfNavigation(),
    );
  }
}
