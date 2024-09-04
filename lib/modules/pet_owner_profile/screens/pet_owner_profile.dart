import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Paquete para manejar estrellas de clasificación

class PetOwnerProfileScreen extends StatelessWidget {
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height / 8; // Reducir la altura del header

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none, // Permitir que la imagen salga del Stack
        children: [
          Column(
            children: [
              // Contenedor superior (encabezado)
              Container(
                height: headerHeight, // Ajustar la altura del header
                width: double.infinity,
                color:
                    Styles.fiveColor, // Color amarillo pálido (parte superior)
              ),
              // Contenedor inferior para mostrar los detalles del dueño de la mascota
              Expanded(
                child: Container(
                  padding: Styles.paddingAll,
                  decoration: BoxDecoration(
                    color: Styles.whiteColor, // Contenedor blanco
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 60), // Espacio para la imagen superpuesta
                      // Nombre del dueño de la mascota, centrado
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pop(context), // Acción de retroceso
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Styles.primaryColor,
                                size: 22,
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.ownerName.value, // Nombre del dueño
                                style: Styles.dashboardTitle20,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width:
                                  40, // Espacio vacío para mantener el nombre centrado
                            ),
                          ],
                        ),
                      ),

                      // Agregar sección de estrellas y rating
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Estrellas de clasificación (tamaño reducido)
                            RatingBar.builder(
                              initialRating: controller.rating.value,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemSize:
                                  20.0, // Tamaño reducido de las estrellas
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // Puedes añadir lógica si deseas permitir cambios en el rating
                              },
                              ignoreGestures:
                                  true, // Para evitar que el usuario lo modifique
                            ),
                            SizedBox(width: 8),
                            Text(
                              controller.rating.value.toString(),
                              style: Styles
                                  .secondTextTitle, // Mostrar el número de rating
                            ),
                          ],
                        ),
                      ),

                      // Agregar el tipo de usuario
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.userType
                                .value, // Tipo de usuario (dueño, veterinario, etc.)
                            style: Styles
                                .secondTextTitle, // Estilo para el texto del tipo de usuario
                          ),
                        ),
                      ),

                      // Divider con espacio
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        child: Divider(height: 10, thickness: 1),
                      ),
                      // Sección de detalles del perfil del dueño de la mascota
                      SizedBox(height: 16),
                      Obx(() =>
                          _buildDetailItem('Email', controller.email.value)),
                      Obx(() =>
                          _buildDetailItem('Teléfono', controller.phone.value)),
                      Obx(() => _buildDetailItem(
                          'Dirección', controller.address.value)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Imagen circular que se posiciona sobre ambos contenedores
          Positioned(
            top: headerHeight -
                50, // Alinea la imagen en el medio de los dos contenedores
            left: (size.width / 2) - 50, // Centrar horizontalmente la imagen
            child: Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(4), // Espacio entre la imagen y el borde
              decoration: BoxDecoration(
                color: Styles.whiteColor, // Fondo del borde
                shape: BoxShape.circle,
                border: Border.all(
                  color: Styles.iconColorBack, // Color del borde
                  width: 3.0, // Grosor del borde
                ),
              ),
              child: Obx(
                () => CircleAvatar(
                  radius: 46, // Ajustar el radio
                  backgroundImage: controller.profileImagePath.isNotEmpty
                      ? NetworkImage(controller.profileImagePath.value)
                      : AssetImage('assets/images/avatar.png')
                          as ImageProvider, // Imagen predeterminada si no hay URL
                  backgroundColor: Colors.transparent, // Fondo transparente
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget que crea un ítem de detalle
  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles
                .secondTextTitle, // Puedes definir este estilo en tu archivo de estilos
          ),
          Text(
            value,
            style: Styles
                .secondTextTitle, // Puedes definir este estilo en tu archivo de estilos
          ),
        ],
      ),
    );
  }
}
