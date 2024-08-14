import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/add_pet/screens/add_pet_screen.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class ProfilesDogs extends StatelessWidget {
  ProfilesDogs({super.key});

  // Instancia del controlador para manejar el estado
  final HomeController controller = Get.put(HomeController());

  // Método para mostrar el AlertDialog de selección de perfil
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Styles.whiteColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona un perfil',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Seleccionar el perfil de la mascota la cual quieres ver la información',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Contenido del diálogo
          content: Obx(() {
            if (controller.profiles.isEmpty) {
              // Mensaje cuando la lista está vacía
              return Text(
                'Aún no has agregado ninguna mascota, te invitamos a agregarla.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'Lato',
                ),
                textAlign: TextAlign.center,
              );
            } else {
              // Lista de perfiles de mascotas
              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.profiles.length,
                  itemBuilder: (context, index) {
                    var profile = controller.profiles[index];
                    var isSelected =
                        controller.selectedProfile.value == profile['name'];

                    return GestureDetector(
                      onTap: () {
                        // Actualiza el perfil seleccionado
                        controller.updateProfile(profile['name']);
                        Get.back(); // Cierra el dialog
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Styles.fiveColor : Colors.white,
                          border: Border.all(color: Styles.iconColorBack),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            // Contenedor de la imagen con borde y padding
                            Container(
                              width:
                                  50, // Tamaño del contenedor que contiene la imagen
                              height: 50,
                              padding: EdgeInsets.all(
                                  2), // Espacio entre la imagen y el borde
                              decoration: BoxDecoration(
                                color: Styles.fiveColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Styles.iconColorBack, // Color del borde
                                  width: 2.0, // Grosor del borde
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 22, // Tamaño de la imagen de perfil
                                backgroundImage: NetworkImage(
                                  profile['image'] ??
                                      'https://via.placeholder.com/150',
                                ),
                                backgroundColor: Colors
                                    .transparent, // Fondo transparente si la imagen no se carga
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.primaryColor,
                                  ),
                                ),
                                if (isSelected)
                                  Text(
                                    'Perfil Seleccionado',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Lato',
                                      color: Styles.iconColorBack,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
          // Botones de acción en el diálogo
          actions: [
            ButtonDefaultWidget(
              title: locale.value.newPet + ' +',
              callback: () async {
                // Navegar a AddPetScreen a través de la ruta nombrada
                var result = await Get.toNamed(Routes.ADDPET);

                // Si se devuelve algún resultado de la pantalla AddPetScreen, se agrega el perfil
                if (result != null) {
                  controller.addProfile(result);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _showProfileDialog(context); // Muestra el AlertDialog al hacer tap
      },
      child: Padding(
        padding: Styles.paddingAll,
        child: Container(
          margin: EdgeInsets.only(top: 16),
          height: 90,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Styles.fiveColor,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(
              color: Styles.iconColorBack, // Borde con color específico
            ),
          ),
          child: Obx(() {
            if (controller.selectedProfile.value.isEmpty) {
              // Mostrar mensaje si no hay perfil seleccionado
              return Center(
                child: Text(
                  'Agrega tu mascota',
                  style: TextStyle(
                    color: Styles.primaryColor,
                    fontFamily: 'PoetsenOne',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            } else {
              // Mostrar imagen y datos del perfil seleccionado
              return Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    padding:
                        EdgeInsets.all(2), // Espacio entre la imagen y el borde
                    decoration: BoxDecoration(
                      color: Styles.fiveColor, // Fondo del borde
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Styles.iconColorBack, // Color del borde
                        width: 2.0, // Grosor del borde
                      ),
                    ),
                    child: CircleAvatar(
                      radius:
                          26, // Ajustar el radio para que la imagen se adapte mejor al contenedor
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                      backgroundColor: Colors
                          .transparent, // Fondo transparente si la imagen no se carga
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width / 2.5,
                        child: Text(
                          controller.selectedProfile.value,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Styles.primaryColor,
                            fontFamily: 'PoetsenOne',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        width: width / 2.5,
                        child: Text(
                          'Perfil de ${controller.selectedProfile.value}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Styles.blackColor,
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Styles.iconColorBack, // Color del icono
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
