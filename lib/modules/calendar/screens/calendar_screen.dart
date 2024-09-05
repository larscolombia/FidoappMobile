import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/calendar/controllers/calendar_controller.dart';
import 'package:pawlly/modules/calendar/screens/pages/activity_list.dart';
import 'package:pawlly/modules/calendar/screens/pages/calendar.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/screens_demo/controller/user_default_test.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/styles/styles.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});
  final CalendarController calendarController = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
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
                        Calendar(),
                        SizedBox(height: 16),
                        ActivityListScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 25,
            right: 25,
            bottom: 30,
            child: MenuOfNavigation(), // Menú de navegación flotante
          ),
        ],
      ),
    );
  }
}
