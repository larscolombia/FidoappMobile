import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';

class VerPasaporteMascota extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();

  String formatFecha(String fecha) {
    // Convertir la fecha de String a DateTime
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = inputFormat.parse(fecha);

    // Formatear la fecha al nuevo formato
    DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' y", 'es_ES');
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(
        _homeController.selectedProfile.value!.dateOfBirth ?? '0000-00-00');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Styles.colorContainer, // Cambia el color según tu diseño
            ),
          ),
          // Segundo contenedor (superpuesto con scroll)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      // Barra de navegación y botón de editar
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BarraBack(
                              titulo: 'Pasaporte',
                              callback: () {},
                            ),
                            Container(
                              child: Image.asset(
                                'assets/icons/edit-2.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Imagen del perro
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          _homeController.selectedProfile.value!.petImage ??
                              'https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Contenedor para el ID de microchip
                      Container(
                        width: 302,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Styles.colorContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/codigo_mascota.png'),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID del Microchip:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  'colocar chip',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Título para la sección de Información
                      Container(
                        width: 302,
                        child: Text(
                          'Información del Perro',
                          style: Styles.TextTitulo,
                        ),
                      ),
                      // Sección con datos del perro
                      InfoMascota(
                        value: _homeController.selectedProfile.value!.name,
                        titulo: 'Nombre',
                      ),
                      InfoMascota(
                        value: 'Canino',
                        titulo: 'Especie',
                      ),
                      InfoMascota(
                        value: _homeController.selectedProfile.value!.gender,
                        titulo: 'Sexo',
                      ),
                      InfoMascota(
                        value: 'Fecha de nacimiento',
                        titulo: '',
                      ),
                      InfoMascota(
                        value: 'Color del pelaje',
                        titulo: '',
                      ),
                      InfoMascota(
                        value: '',
                        titulo: 'Altura',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoMascota extends StatelessWidget {
  InfoMascota({
    super.key,
    this.titulo,
    this.value,
  });

  final String? titulo;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 302,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffEFEFEF), width: .5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo!,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value!,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
