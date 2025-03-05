import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/historia_componente.dart';
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
    // Convertir la fecha de String a DateTime
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = inputFormat.parse(fecha);

    // Formatear la fecha al nuevo formato
    DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' y", 'es_ES');
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    //historiaClinicaController
    //  .fetchHistorialClinico(_homeController.selectedProfile.value!.id);
    print('date  ${jsonEncode(_homeController.selectedProfile.value!)}');
    var mascota = _homeController.selectedProfile.value!;
    var padding = Helper.paddingDefault;
    var margen = Helper.margenDefault;
    var ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Styles.colorContainer, // Cambia el color según tu diseño
            ),
            child: const Stack(
              children: [
                Positioned(
                    bottom: 0,
                    child: BorderRedondiado(
                      top: 110,
                    )),
              ],
            ),
          ),
          // Segundo contenedor (superpuesto con scroll)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Helper.paddingDefault),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Ajusta el margen

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: BarraBack(
                                titulo: 'Pasaporte',
                                callback: () {
                                  Get.off(HomeScreen());
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
                      SizedBox(height: margen),
                      Container(
                        width: ancho,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge, // Agregar esta línea
                        child: Obx(() {
                          final imageUrl =
                              _homeController.selectedProfile.value!.petImage ??
                                  'https://via.placeholder.com/600x400';

                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/404.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        }),
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
                                // color: Styles.iconColorBack,
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
                                    _homeController
                                            .selectedProfile.value!.chip ??
                                        "",
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
                        style: Styles.TextTitulo,
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
                            ? 'Femenino'
                            : 'Masculino',
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
                      const SizedBox(
                        width: 305,
                        child: Text(
                          'Datos de Vacunación y Tratamientos',
                          style: Styles.TextTitulo,
                        ),
                      ),

                      //gridView
                      Container(
                        width:
                            ancho, // Puedes ajustar el ancho del Container según lo que necesites
                        padding: EdgeInsets.all(Helper
                            .paddingDefault), // Espaciado interno si lo deseas

                        child: Obx(() {
                          final historial =
                              historiaClinicaController.historialClinico;
                          if (historiaClinicaController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (historial.value.isEmpty) {
                            return const Center(
                                child: Text('No hay datos disponibles.'));
                          }
                          return GridView.builder(
                            shrinkWrap:
                                true, // Permite que el GridView ocupe solo el espacio necesario
                            physics:
                                const NeverScrollableScrollPhysics(), // Desactiva el scroll para evitar conflictos con el ScrollView principal
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Número de elementos por fila
                              crossAxisSpacing: 1, // Espacio entre columnas
                              mainAxisSpacing: 1, // Espacio entre filas
                              childAspectRatio:
                                  0.5, // Proporción de cada celda, puedes ajustarlo según tu diseño
                            ),
                            itemCount: historial
                                .length, // Número de elementos en el Grid
                            itemBuilder: (context, index) {
                              final history = historial[index];
                              return SizedBox(
                                height: 200,
                                child: HistoriaMascotaComponent(
                                  reportName: history.reportName,
                                  categoryName: history.categoryName,
                                  applicationDate: history.createdAt,
                                  id: history.id.toString(),
                                  callback: () {
                                    print('Callback');
                                  },
                                ),
                              );
                            },
                          );
                        }),
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
      width: MediaQuery.of(context).size.width,
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
