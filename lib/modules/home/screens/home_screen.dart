import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/calendar/activity_list.dart';
import 'package:pawlly/modules/home/screens/calendar/calendar.dart';
import 'package:pawlly/modules/home/screens/explore/entretaiment_blogs.dart';
import 'package:pawlly/modules/home/screens/explore/explore_input.dart';
import 'package:pawlly/modules/home/screens/explore/training_programs.dart';
import 'package:pawlly/modules/home/screens/pages/profile_dogs.dart';
import 'package:pawlly/modules/home/screens/pages/training.dart';
import 'package:pawlly/modules/home/screens/pages/utilities.dart';
import 'package:pawlly/modules/home/screens/training/commands.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/screens_demo/controller/user_default_test.dart';
import 'package:pawlly/modules/home/screens/pages/explorar_container.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/pages/resources.dart';
import 'package:pawlly/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final UserDefaultTest userController = Get.put(UserDefaultTest());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderNotification(),
                  Container(
                    padding: Styles.paddingAll,
                    child: Obx(() {
                      // Cambiar el contenido basado en el selectedIndex
                      switch (homeController.selectedIndex.value) {
                        case 0:
                          return _buildCase1Content();
                        case 1:
                          return _buildCase2Content();
                        case 2:
                          return _buildCase3Content();
                        case 3:
                          return _buildCase4Content();
                        default:
                          return _buildCase1Content();
                      }
                    }),
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
                Container(
                  height: 135,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.3),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
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

  // Funciones que devuelven el contenido basado en el selectedIndex

  Widget _buildCase1Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ProfilesDogs(),
        SizedBox(height: 16),
        Resources(),
        SizedBox(height: 16),
        Explore(),
        SizedBox(height: 16),
        Utilities(),
        SizedBox(height: 16),
        Training(),
      ],
    );
  }

  Widget _buildCase2Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Calendar(),
        SizedBox(height: 16),
        ActivityListScreen(),
      ],
    );
  }

  Widget _buildCase3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ProfilesDogs(),
        SizedBox(height: 16),
        Training(),
        SizedBox(height: 16),
        Commands(),
      ],
    );
  }

  Widget _buildCase4Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        ProfilesDogs(),
        SizedBox(height: 16),
        Resources(),
        SizedBox(height: 16),
        ExploreInput(),
        SizedBox(height: 16),
        Training(),
        SizedBox(height: 16),
        EntertainmentBlogs(),
        SizedBox(height: 16),
        TrainingPrograms(),
        SizedBox(height: 20),
      ],
    );
  }
}
