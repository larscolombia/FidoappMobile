import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/historia_grid.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/controller/historial_clinico/historial_clinico_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/pasaporte_mascota.dart';

class VerPasaporteMascota extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();
  final HistorialClinicoController historiaClinicaController =
      Get.put(HistorialClinicoController());

  VerPasaporteMascota({super.key});

  String formatFecha(String fecha) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = inputFormat.parse(fecha);
    DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' y", 'es_ES');
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Verificar si hay una mascota seleccionada
      if (_homeController.selectedProfile.value == null) {
        return Scaffold(
          backgroundColor: Styles.colorContainer,
          body: const Center(
            child: Text(
              'No hay mascota seleccionada',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Lato',
              ),
            ),
          ),
        );
      }

      var mascota = _homeController.selectedProfile.value!;
      var ancho = MediaQuery.sizeOf(context).width;
      var margen = Helper.margenDefault;
      var height = 99.0;

      return Scaffold(
        backgroundColor: Styles.colorContainer,
        body: Column(
          children: [
            // Primer contenedor (fondo o header)
            Container(
              width: ancho,
              height: 180,
              decoration: const BoxDecoration(
                color: Styles.colorContainer,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Styles.primaryColor,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: mascota.petImage != null && mascota.petImage!.isNotEmpty
                          ? Image.network(
                              mascota.petImage ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/404.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/404.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Segundo contenedor (superpuesto con scroll)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 34),
                      SizedBox(
                        width: ancho,
                        child: BarraBack(
                          titulo: 'Información del Pasaporte',
                          size: 20,
                          callback: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: 26),
                      SizedBox(height: margen),
                      if (mascota.chip != null)
                        Container(
                          width: ancho,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Styles.colorContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/svg/code-pet.svg',
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'ID del Microchip:',
                                style: Styles.textProfile14w700,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                mascota.chip?.numIdentificacion?.toString() ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (mascota.chip != null)
                        SizedBox(height: margen),

                      SizedBox(height: margen),
                      InfoMascota(
                        titulo: 'Nombre',
                        value: mascota.name,
                      ),
                      const InfoMascota(
                        titulo: 'Especie',
                        value: 'Canino',
                      ),
                      InfoMascota(
                        titulo: 'Sexo',
                        value: mascota.gender == "female"
                            ? 'Hembra'
                            : 'Macho',
                      ),
                      InfoMascota(
                        titulo: 'Raza',
                        value: mascota.breed,
                      ),
                      InfoMascota(
                        titulo: 'Fecha de nacimiento',
                        value:
                            '${mascota.dateOfBirth ?? "no lo ha colocado aún"}',
                      ),
                      InfoMascota(
                        titulo: 'Color del pelaje',
                        value: mascota.petFur,
                      ),
                      InfoMascota(
                        titulo: 'Altura',
                        value:
                            '${mascota.height ?? ""}${mascota.heightUnit ?? ""}',
                      ),
                      InfoMascota(
                        titulo: 'Marcas distintivas',
                        value: mascota.description ??
                            "No se ha definido una descripción",
                      ),
                      const SizedBox(height: 20),
                      Helper.titulo(
                        'Datos de Vacunación y Tratamientos',
                      ),
                      SizedBox(height: margen),
                      HistorialGrid(controller: historiaClinicaController),
                      SizedBox(height: margen),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class InfoMascota extends StatelessWidget {
  const InfoMascota({
    super.key,
    this.titulo,
    this.value,
  });

  final String? titulo;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Color(0xffEFEFEF),
          width: .5,
        ),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value ?? "",
            style: const TextStyle(
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
