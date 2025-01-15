import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/pet_owner_profile.dart';
import 'package:pawlly/modules/profile_pet/controllers/pet_owner_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';

import 'package:pawlly/modules/profile_pet/screens/ver_pasaporte_mascota.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/associated_persons_modal.dart';

import 'package:pawlly/services/auth_service_apis.dart';

import 'package:pawlly/styles/styles.dart';
import 'package:share_plus/share_plus.dart';

class InformationTab extends StatelessWidget {
  final ProfilePetController controller;
  final PetOwnerController petcontroller = Get.put(PetOwnerController());
  // ignore: non_constant_identifier_names
  final PetOwnerProfileController OnewrProfileController =
      Get.put(PetOwnerProfileController());

  final HomeController homeController = Get.put(HomeController());
  InformationTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var pet = petcontroller.fetchOwnersList(controller.petProfile.id);
    print('info pert ${(pet)}');
    return Obx(() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nombre de la mascota y botón de compartir
              SizedBox(
                width: 305,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Nombre',
                          style: Styles.textProfile14w400,
                        ),
                        Text(
                          controller.petName.value,
                          style: Styles.dashboardTitle20,
                        ),
                      ],
                    ),
                    if (AuthServiceApis.dataCurrentUser.userType == 'user')
                      ButtonDefaultWidget(
                        title: 'Compartir',
                        callback: () {
                          // Lógica para compartir
                          Share.share(
                            'Esta es mi mascota muy hermoza : ${homeController.selectedProfile.value!.petImage}',
                            subject: AuthServiceApis.dataCurrentUser.userName,
                          );
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
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (AuthServiceApis.dataCurrentUser.userType == 'user')
                Center(
                  child: SizedBox(
                    height: 54,
                    child: ButtonDefaultWidget(
                      title: 'Pasaporte',
                      callback: () {
                        Get.to(
                          VerPasaporteMascota(),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Card de la raza
              Card(
                color: Styles.fiveColor,
                elevation: 0.0,
                child: ListTile(
                  leading: const Icon(
                    Icons.pets,
                    color: Styles.iconColorBack,
                  ),
                  title: Text(
                    'Raza:',
                    style: Styles.textProfile14w400,
                  ),
                  subtitle: Text(
                    controller.petBreed.value,
                    style: Styles.textProfile14w800,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sección sobre la mascota
              SizedBox(
                width: 305,
                child: Text(
                  'Sobre ${controller.petName.value}',
                  style: Styles.textProfile15w700,
                ),
              ),
              Text(
                controller.petProfile.description ?? "no lo ha colocado aún",
                style: Styles.textProfile15w400,
              ),
              const SizedBox(height: 20),
              // Card de cumpleaños y fecha de nacimiento
              Card(
                color: Styles.fiveColor,
                elevation: 0.0,
                child: ListTile(
                  leading: const Icon(
                    Icons.cake,
                    color: Styles.iconColorBack,
                  ),
                  title: Text(
                    'Edad:',
                    style: Styles.textProfile14w400,
                  ),
                  subtitle: Text(
                    homeController.selectedProfile.value!.age ??
                        "no lo ha colocado aún",
                    style: Styles.textProfile14w800,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fecha de nacimiento:',
                        style: Styles.textProfile14w400,
                      ),
                      Text(
                        homeController.selectedProfile.value!.dateOfBirth ?? "",
                        style: Styles.textProfile14w800,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Cards de peso y sexo
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Styles.fiveColor,
                      elevation: 0.0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.line_weight,
                          color: Styles.iconColorBack,
                        ),
                        title: Text(
                          'Peso: ',
                          style: Styles.textProfile14w400,
                        ),
                        subtitle: Text(
                          '${controller.petProfile.weight}kg',
                          style: Styles.textProfile14w800,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Styles.fiveColor,
                      elevation: 0.0,
                      child: ListTile(
                        leading: const Icon(
                          Icons.female,
                          color: Styles.iconColorBack,
                        ),
                        title: Text(
                          'Sexo:',
                          style: Styles.textProfile14w400,
                        ),
                        subtitle: Text(
                          controller.petGender.value == "female"
                              ? 'Femenino'
                              : 'Masculino',
                          style: Styles.textProfile14w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sección de compartir QR
              Text(
                'Comparte este perfil con este QR:',
                style: Styles.textProfile14w700,
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage.assetNetwork(
                    placeholder:
                        'assets/images/404.jpg', // Imagen de respaldo (colócala en la carpeta assets)
                    image: controller.petProfile.qrCode ??
                        'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/pop_up_design.png', // Imagen a mostrar si ocurre un error
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Personas asociadas a la mascota
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Personas Asociadas a esta Mascota',
                      style: Styles.textTitleHome,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return AssociatedPersonsModal(controller: controller);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.iconColorBack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Column(
                children: petcontroller.associatedPersons.map((person) {
                  return GestureDetector(
                    onTap: () {
                      OnewrProfileController.ownerName.value = person['name'];
                      OnewrProfileController.relation.value =
                          person['relation'];
                      OnewrProfileController.profileImagePath.value =
                          person['profile_image'];
                      // Navegar a la ruta 'PETOWNERPROFILE' y pasar los datos del perfil si es necesario
                      //Get.toNamed(Routes.PETOWNERPROFILE, arguments: person);
                      Get.to(
                        PetOwnerProfileScreen(id: person['id'].toString()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            width: 1, color: const Color(0xffEFEFEF)),
                      ),
                      child: Card(
                        elevation: 0.0, // Quita la elevación (sombra)
                        shadowColor: Colors
                            .transparent, // Opcional: asegura que no se muestre sombra
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              person['imageUrl'] ??
                                  'https://via.placeholder.com/150', // Cambiar por la URL de la persona
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Styles.iconColorBack,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            person['name'] ?? '',
                            style: Styles.textProfile14w700,
                          ),
                          subtitle: Text(
                            person['relation'] ?? '',
                            style: Styles.textProfile12w400,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Styles.iconColorBack,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Botón de eliminar mascota
              /** 
              Center(
                child: TextButton(
                  onPressed: controller
                      .deletePet, // Llamar a la función para mostrar el modal
                  child: const Text(
                    'Eliminar mascota',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),*/
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
