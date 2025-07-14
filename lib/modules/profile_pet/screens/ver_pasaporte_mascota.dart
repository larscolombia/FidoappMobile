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
    var mascota = _homeController.selectedProfile.value!;
    var padding = Helper.paddingDefault;
    var margen = Helper.margenDefault;
    var ancho = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 160,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF7E5), // Color de fondo ajustado
            ),
            child: const Stack(
              children: [
                BorderRedondiado(
                  top: 130,
                ),
              ],
            ),
          ),

          // Segundo contenedor (superpuesto con scroll)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 26,
                    left: 26,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ancho, // Ajusta el margen
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: BarraBack(
                                titulo: 'Pasaporte',
                                size: 20,
                                callback: () {
                                  Get.back();
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => PasaporteMascota());
                              },
                              child: Container(
                                width: 42.4,
                                height: 42.4,
                                decoration: BoxDecoration(
                                  color: Styles.colorContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/edit-2.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height:
                              12), // Reducción del espacio debajo del "Pasaporte"
                      Container(
                        width: ancho,
                        height: 200,
                        child: Center(
                        child: Obx(() {
                          final imageUrl =
                              _homeController.selectedProfile.value!.petImage ??
                                  'https://via.placeholder.com/600x400';

                            return CircleAvatar(
                              radius: 80, // Radio del círculo
                              backgroundColor: Colors.grey[200], // Color de fondo
                              child: ClipOval(
                                child: CachedNetworkImage(
                            imageUrl: imageUrl,
                                  width: 160, // Ancho del círculo
                                  height: 160, // Alto del círculo
                                  fit: BoxFit.cover, // Mantener proporciones
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/404.jpg',
                                      width: 160,
                                      height: 160,
                                fit: BoxFit.cover,
                              );
                            },
                                ),
                              ),
                          );
                        }),
                        ),
                      ),
                      SizedBox(height: margen),
                      if (_homeController.selectedProfile.value!.chip != null)
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ID del Microchip:',
                                    style: Styles.descripcion,
                                  ),
                                  Text(
                                    _homeController.selectedProfile.value!.chip?.numIdentificacion?.toString() ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Styles.iconColorBack,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: margen),
                      const Text(
                        'Información del Perro',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'PoetsenOne',
                          color: Color(0xFFFF4931),
                        ),
                      ),
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
                        value: _homeController.selectedProfile.value!.breed,
                      ),
                      InfoMascota(
                        titulo: 'Fecha de nacimiento',
                        value:
                            '${_homeController.selectedProfile.value!.dateOfBirth ?? "no lo ha colocado aún"}',
                      ),
                      InfoMascota(
                        titulo: 'Color del pelaje',
                        value: _homeController.selectedProfile.value!.petFur,
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
          ),
        ],
      ),
    );
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
