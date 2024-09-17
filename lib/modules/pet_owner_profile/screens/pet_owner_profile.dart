import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/widgets/comments_section.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PetOwnerProfileScreen extends StatelessWidget {
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height / 8;

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          // Cambiado a SingleChildScrollView para todo el contenido
          child: Column(
            children: [
              // Encabezado
              Stack(
                children: [
                  Container(
                    height: headerHeight,
                    width: double.infinity,
                    color: Styles.fiveColor,
                  ),
                  // Imagen circular ahora dentro del Stack pero sin Positioned
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: headerHeight - 50),
                      width: 100,
                      height: 100,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Styles.whiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Styles.iconColorBack,
                          width: 3.0,
                        ),
                      ),
                      child: Obx(
                        () => CircleAvatar(
                          radius: 46,
                          backgroundImage: controller
                                  .profileImagePath.value.isNotEmpty
                              ? NetworkImage(controller.profileImagePath.value)
                              : AssetImage('assets/images/avatar.png')
                                  as ImageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Espacio entre la imagen y el contenido
              Container(
                padding: Styles.paddingAll,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Styles.primaryColor,
                          size: 22,
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.grey, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'Santo Domingo, R.D',
                                style: TextStyle(
                                    color: Styles.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'lato'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
              Obx(() => Text(
                    controller.ownerName.value,
                    style: Styles.dashboardTitle20,
                    textAlign: TextAlign.center,
                  )),
              Obx(
                () => Text(
                  controller.userType.value,
                  style: Styles.secondTextTitle,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: controller.rating.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemSize: 20.0,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                    ignoreGestures: true,
                  ),
                  SizedBox(width: 8),
                  Text(
                    controller.rating.value.toString(),
                    style: Styles.secondTextTitle,
                  ),
                ],
              ),
              Padding(
                padding: Styles.paddingAll,
                child: Divider(height: 10, thickness: 1),
              ),
              Obx(
                () {
                  if (controller.userType.value == 'Veterinario' ||
                      controller.userType.value == 'Entrenador') {
                    return Container(
                      padding: Styles.paddingAll,
                      child: Column(
                        children: [
                          Container(
                            height: 54,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFE5FEED),
                              border: Border.all(
                                color: Color(0xFF19A02F),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Color(0xFF19A02F), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Veterinario Calificado',
                                    style: TextStyle(
                                        color: Color(0xFF19A02F),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'lato'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              Obx(
                () => Container(
                  padding: Styles.paddingAll,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sobre ${controller.ownerName.value}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'lato',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => Container(
                    padding: Styles.paddingAll,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.description.value,
                          style: Styles.secondTextTitle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  )),
              Container(
                padding: Styles.paddingAll,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ButtonDefaultWidget(
                    title: 'Compartir',
                    callback: () {
                      // Lógica para compartir perfil
                    },
                    defaultColor: Colors.transparent,
                    border: const BorderSide(color: Colors.grey, width: 1),
                    textColor: Colors.black,
                    icon: Icons.share,
                    iconAfterText: true,
                    widthButtom: 150,
                    textSize: 14,
                    borderSize: 25,
                    heigthButtom: 40,
                  ),
                ),
              ),
              Obx(() {
                if (controller.veterinarianLinked.value) {
                  return Container(
                    padding: Styles.paddingAll,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE5FEED),
                        border: Border.all(
                          color: Color(0xFF19A02F),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Color(0xFF19A02F), size: 20),
                          SizedBox(width: 8),
                          Text(
                            controller.veterinarianLinked.value
                                ? 'Veterinario vinculado a tu mascota'
                                : 'No vinculado',
                            style: TextStyle(
                                color: Color(0xFF19A02F),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lato'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              Container(
                padding: Styles.paddingAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Área de especialización',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => Container(
                    padding: Styles.paddingAll,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFEF7E5),
                        border: Border.all(
                          color: Color(0xFFFC9214),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.specializationArea.value,
                            style: TextStyle(
                                color: Color(0xFFFC9214),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lato'),
                          ),
                        ],
                      ),
                    ),
                  )),
              Container(
                padding: Styles.paddingAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Otras áreas de especialización',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'lato',
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => Container(
                    padding: Styles.paddingAll,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.otherAreas.map((area) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFEF7E5),
                            border: Border.all(
                              color: Color(0xFFFC9214),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            area,
                            style: TextStyle(
                                color: Color(0xFFFC9214),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'lato'),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
              SizedBox(height: 16),
              Container(
                padding: Styles.paddingAll,
                child: CommentsSection(),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
