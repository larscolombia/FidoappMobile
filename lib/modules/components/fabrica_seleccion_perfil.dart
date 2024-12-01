import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

class SelccionarMascota extends StatelessWidget {
  SelccionarMascota({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      if (controller.selectedProfile.value == null) {
        // Mostrar mensaje si no hay perfil seleccionado
        return GestureDetector(
          onTap: () =>
              showPetsModal(context, controller), // Abre el modal al tocar
          child: Center(
            child: Text(
              'Agrega tu mascota',
              style: TextStyle(
                color: Styles.primaryColor,
                fontFamily: 'PoetsenOne',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      } else {
        // Mostrar imagen y datos del perfil seleccionado
        final profile = controller.selectedProfile.value!;
        return GestureDetector(
          onTap: () =>
              showPetsModal(context, controller), // Abre el modal al tocar
          child: SelccionarPerfil(
              nombre: profile.name,
              age: profile.age,
              avatar: profile.petImage != null && profile.petImage!.isNotEmpty
                  ? NetworkImage(profile.petImage!)
                  : NetworkImage(
                          'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg')
                      as ImageProvider),
        );
      }
    });
  }

  void showPetsModal(BuildContext context, HomeController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que el modal use toda la altura disponible
      backgroundColor: Colors.white, // Color de fondo del modal
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0), // Espaciado alrededor del contenido
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajustar el tamaño del modal
            children: [
              Text(
                'Selecciona una mascota',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10), // Espacio entre el título y la lista
              Obx(() {
                // Verifica si hay perfiles disponibles
                if (controller.profiles.isEmpty) {
                  return Center(child: Text('No hay mascotas disponibles.'));
                }

                return ListView.builder(
                  shrinkWrap:
                      true, // Permite que la lista ocupe solo el espacio necesario
                  physics:
                      NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento de la lista
                  itemCount: controller.profiles.length,
                  itemBuilder: (context, index) {
                    var profile = controller.profiles[index];
                    var isSelected =
                        controller.selectedProfile.value == profile;

                    return GestureDetector(
                      onTap: () {
                        controller
                            .updateProfile(profile); // Seleccionar mascota
                        Navigator.of(context).pop(); // Cerrar el modal
                      },
                      child: SelccionarPerfil(
                        conIcono: false,
                        nombre: profile.name,
                        age: profile.age,
                        avatar: profile.petImage != null &&
                                profile.petImage!.isNotEmpty
                            ? NetworkImage(profile.petImage!)
                            : NetworkImage(
                                'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg'),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 10), // Espacio adicional antes de cerrar
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el modal
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// para seleccionar el perfil avatar
class SelccionarPerfil extends StatelessWidget {
  SelccionarPerfil({
    super.key,
    this.nombre,
    this.age,
    this.avatar,
    this.conIcono = true,
  });

  final String? nombre;
  final String? age;
  final ImageProvider? avatar;
  final bool? conIcono;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          padding: EdgeInsets.all(2), // Espacio entre la imagen y el borde
          margin: EdgeInsets.only(bottom: 16),
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
            backgroundImage: avatar,

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
                nombre ?? '',
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
                'edad ${nombre}',
                textAlign: TextAlign.left,
                style: const TextStyle(
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
        conIcono!
            ? Icon(
                Icons.arrow_drop_down,
                color: Styles.iconColorBack, // Color del icono
              )
            : SizedBox(),
      ],
    );
  }
}
