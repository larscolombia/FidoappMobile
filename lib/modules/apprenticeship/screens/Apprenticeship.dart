import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_text_custom.dart';
import 'package:pawlly/modules/apprenticeship/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/widgets/menu_of_navigation.dart';
import 'package:pawlly/modules/apprenticeship/component/cursos.dart';
import 'package:pawlly/screens_demo/component/header_baner_user.dart';
import 'package:pawlly/styles/styles.dart';

class ApprenticeshipScreen extends GetView<ApprenticeshipController> {
  @override
  Widget build(Object context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: HeaderBanerUser(
                  altura: 160,
                ),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.only(top: 25),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Realiza tu búsqueda',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 70,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Styles.tertiaryColor,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: CustomTextFormField(
                  pleholder: 'Buscar el curso que necesites',
                  icon: 'assets/icons/ic_search.png',
                  controller: null,
                ),
              ),
              Container(
                width: 30,
                margin: EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Cursos',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'lato',
                    ),
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 3,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.1,
                ),
              ),
              Container(
                width: 30,
                child: Row(
                  children: [Cursos(), Cursos()],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: MenuOfNavigation(),
    );
  }
}
