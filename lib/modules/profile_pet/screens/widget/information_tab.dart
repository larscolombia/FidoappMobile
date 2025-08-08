import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/select_user.dart';
import 'package:pawlly/modules/diario/diario.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/user_profile_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/screens/pet_owner_profile.dart';
import 'package:pawlly/modules/profile_pet/controllers/pet_owner_controller.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/pet_passport_view.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/associated_persons_modal.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:share_plus/share_plus.dart';

class InformationTab extends StatelessWidget {
  final ProfilePetController controller;
  InformationTab({super.key, required this.controller});

  final HomeController homeController = Get.put(HomeController());
  final PetOwnerController petcontroller = Get.put(PetOwnerController());
  final PetOwnerProfileController onewrProfileController = Get.put(PetOwnerProfileController());
  final UserProfileController profileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    petcontroller.fetchOwnersList(controller.petProfile.value.id);
    var ancho = MediaQuery.sizeOf(context).width;
    var margen = Helper.margenDefault;

    return Obx(() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Helper.paddingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nombre de la mascota y botón de compartir
              SizedBox(
                width: ancho,
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
                          homeController.selectedProfile.value!.name,
                          style: Styles.dashboardTitle20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    if (AuthServiceApis.dataCurrentUser.userType == 'user')
                    ButtonDefaultWidget(
                      title: 'Compartir perfil',
                      callback: () {
                        // Lógica para compartir
                        Share.share(
                          'Esta es mi mascota: ${homeController.selectedProfile.value!.petImage}',
                          subject: AuthServiceApis.dataCurrentUser.userName,
                        );
                      },
                      defaultColor: Colors.transparent,
                      border: const BorderSide(color: Colors.grey, width: 1),
                      textColor: Colors.black,
                      icon: Icons.share,
                      iconAfterText: true,
                      widthButtom: 200,
                      textSize: 14,
                      borderSize: 25,
                      heigthButtom: 40,
                      svgIconPath: 'assets/icons/svg/compartir2.svg',
                    ),
                  ],
                ),
              ),
              SizedBox(height: margen),

              // Botón de editar perfil de mascota
              if (AuthServiceApis.dataCurrentUser.userType == 'user')
              Center(
                child: SizedBox(
                  height: 54,
                  child: Obx(() => ButtonDefaultWidget(
                        iconAfterText: false,
                        title: 'Pasaporte',
                        svgIconPath: 'assets/icons/svg/mdi_passport.svg',
                        isLoading: controller.isOpeningPassport.value,
                        callback: () async {
                          if (controller.isOpeningPassport.value) return;
                          controller.isOpeningPassport.value = true;
                          await Get.to(
                            PetPassportView(),
                          );
                          controller.isOpeningPassport.value = false;
                        },
                      )),
                ),
              ),
              SizedBox(height: margen),
              // Nombre de la mascota
              SizedBox(
                width: ancho,
                child: Text(
                  'Sobre ${homeController.selectedProfile.value!.name}',
                  style: Styles.textProfile15w700,
                  textAlign: TextAlign.start,
                ),
              ),
              // Descripción de la mascota
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  homeController.selectedProfile.value!.description ?? "",
                  style: Styles.textProfile15w400,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: margen),
              // Botón de Diario de Actividad
              SizedBox(
                width: ancho,
                child: ButtonDefaultWidget(
                  iconAfterText: false,
                  title: 'Diario de Actividad',
                  defaultColor: Styles.iconColorBack,
                  svgIconPath: 'assets/icons/svg/archive-book.svg',
                  callback: () {
                    Get.to(
                      Diario(),
                    );
                  },
                ),
              ),
              SizedBox(height: margen),
              // ID del Microchip
              SizedBox(
                width: ancho,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ID del Microchip:',
                      style: Styles.textProfile14w700,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      homeController.selectedProfile.value!.chip ?? "",
                      style: Styles.chiptitle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: margen),
              // Raza
              Card(
                margin: const EdgeInsets.only(top: 0),
                color: Styles.fiveColor,
                elevation: 0.0,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/svg/task-square.svg',
                    // color: Styles.iconColorBack,
                  ),
                  title: Text(
                    'Raza:',
                    style: Styles.textProfile14w400,
                  ),
                  subtitle: Text(
                    homeController.selectedProfile.value!.breed,
                    style: Styles.textProfile14w800,
                  ),
                ),
              ),
              SizedBox(height: margen),
              // Edad y Fecha de Nacimiento
              Card(
                margin: const EdgeInsets.only(top: 0),
                color: Styles.fiveColor,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Sección de Edad
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/svg/mdi_cake-variant.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edad:',
                                style: Styles.textProfile14w400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                homeController.selectedProfile.value!.age,
                                style: Styles.textProfile14w800,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      /// Línea Divisora
                      Container(
                        height: 30,
                        width: 1,
                        color: Styles.iconColorBack,
                      ),

                      const SizedBox(width: 10),
                      /// Sección de Fecha de Nacimiento
                      Expanded(
                        flex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [
                            Text(
                              'Fecha de nacimiento:',
                              style: Styles.textProfile14w400,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              homeController.selectedProfile.value!.birthDateFormatted,
                              style: Styles.textProfile14w800,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: margen),
              // Peso y Sexo
              Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(top: 0),
                      color: Styles.fiveColor,
                      elevation: 0.0,
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/icons/svg/weight.svg',
                          // color: Styles.iconColorBack,
                          width: 24,
                          height: 24,
                        ),
                        title: Text(
                          'Peso: ',
                          style: Styles.textProfile14w400,
                        ),
                        subtitle: Text(
                          '${homeController.selectedProfile.value!.weight} ${homeController.selectedProfile.value!.weightUnit}',
                          style: Styles.textProfile13w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.only(top: 0),
                      color: Styles.fiveColor,
                      elevation: 0.0,
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/icons/svg/ph_heart-fill.svg',
                          // color: Styles.iconColorBack,
                          width: 24,
                          height: 24,
                        ),
                        title: Text(
                          'Sexo:',
                          style: Styles.textProfile14w400,
                        ),
                        subtitle: Text(homeController.selectedProfile.value!.gender == "female"
                            ? 'Hembra'
                            : 'Macho',
                          style: Styles.textProfile13w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: margen),
              // Sección de compartir QR
              SizedBox(
                width: ancho,
                child: Text(
                  'Comparte este perfil con este QR:',
                  style: Styles.textProfile14w700,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 20),
              // QR Code
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
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
                  aspectRatio: 0.9, // Ajustar el aspect ratio
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/404.jpg', // Imagen de respaldo
                    image: homeController.selectedProfile.value!.qrCode ??
                        'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit
                        .contain, // Ajusta la imagen para cubrir todo el contenedor
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/pop_up_design.png', // Imagen a mostrar si ocurre un error
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit
                            .cover, // Asegúrate de que la imagen de error también cubra el contenedor
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Personas asociadas a la mascota
              if (AuthServiceApis.dataCurrentUser.userType != 'user')
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Personas Asociadas a\nesta Mascota',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),

              // Botón para agregar personas asociadas (solo si el usuario es un propietario)
              if (AuthServiceApis.dataCurrentUser.userType == 'user')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Personas Asociadas a\nesta Mascota',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        height: 1.3,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44, // Ancho fijo
                    height: 44, // Alto fijo
                    child: Obx(() => ElevatedButton(
                          onPressed: petcontroller.isAddingPerson.value
                              ? null
                              : () async {
                                  petcontroller.isAddingPerson.value = true;
                                  await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      return AssociatedPersonsModal(
                                          controller: controller);
                                    },
                                  );
                                  petcontroller.isAddingPerson.value = false;
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFC9214),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.zero,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: petcontroller.isAddingPerson.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.add,
                                  color: Colors.white, size: 24),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Lista de personas asociadas
              Column(
                children: petcontroller.associatedPersons.map((person) {
                  return GestureDetector(
                      onTap: () {
                        onewrProfileController.ownerName.value = person['name'];
                        onewrProfileController.relation.value = person['relation'];
                        onewrProfileController.profileImagePath.value = person['profile_image'];
                        // Navegar a la ruta 'PETOWNERPROFILE' y pasar los datos del perfil si es necesario
                        //Get.toNamed(Routes.PETOWNERPROFILE, arguments: person);
                        profileController.fetchUserData(person['id'].toString());

                        Get.to(
                          PetOwnerProfileScreen(id: person['id'].toString()),
                        );
                      },
                      child: Column(
                        children: [
                          SelectedAvatar(
                            imageUrl: person['profile_image'],
                            nombre: person['name'],
                            profesion: person['relation'],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ));
                }).toList(),
              ),
              SizedBox(height: margen),
              
              // Botón de eliminar mascota
              if (AuthServiceApis.dataCurrentUser.userType == 'user')
              Center(
                child: TextButton(
                  onPressed: controller.deletePet,
                  child: const Text(
                    'Eliminar animal',
                    style: TextStyle(color: Colors.red, fontFamily: "Lato"),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
