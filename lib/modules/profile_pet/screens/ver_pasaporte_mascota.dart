import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/historia_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
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
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(
        _homeController.selectedProfile.value!.dateOfBirth ?? '0000-00-00');
    //historiaClinicaController
    //  .fetchHistorialClinico(_homeController.selectedProfile.value!.id);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Styles.colorContainer, // Cambia el color según tu diseño
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 260,
                              child: BarraBack(
                                titulo: 'Pasaporte',
                                callback: () {
                                  Get.off(HomeScreen());
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(PasaporteMascota());
                              },
                              child: Image.asset('assets/icons/edit-2.png'),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 305,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black,
                        ),
                        child: Obx(() {
                          final imageUrl =
                              _homeController.selectedProfile.value!.petImage ??
                                  'https://via.placeholder.com/600x400';

                          return CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) {
                              // Imagen predeterminada si falla la carga
                              return Image.asset(
                                'assets/images/404.jpg', // Ruta de la imagen predeterminada
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 304,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Styles.colorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/codigo_mascota.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Codigó de Mascota',
                                  style: Styles.descripcion,
                                ),
                                Text(
                                  'Encuentra toda la información aquí',
                                  style: TextStyle(
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
                      const SizedBox(height: 20),
                      Container(
                        child: const Text(
                          'Información del Perro',
                          style: Styles.TextTitulo,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InfoMascota(
                        titulo: 'Nombre',
                        value: _homeController.selectedProfile.value!.name,
                      ),
                      InfoMascota(
                        titulo: 'Especie',
                        value: 'Canino',
                      ),
                      InfoMascota(
                        titulo: 'Sexo',
                        value: _homeController.selectedProfile.value!.gender,
                      ),
                      InfoMascota(
                        titulo: 'Raza',
                        value: _homeController.selectedProfile.value!.breed,
                      ),

                      InfoMascota(
                        titulo: 'Fecha de nacimiento',
                        value:
                            '${_homeController.selectedProfile.value!.dateOfBirth}',
                      ),
                      InfoMascota(
                        titulo: 'Color del pelaje',
                        value: _homeController.selectedProfile.value!.petFur,
                      ),
                      InfoMascota(
                        titulo: 'Altura',
                        value:
                            _homeController.selectedProfile.value!.heightUnit ??
                                "n/A",
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 305,
                        child: const Text(
                          'Datos de Vacunación y Tratamientos',
                          style: Styles.TextTitulo,
                        ),
                      ),

                      //gridView
                      Container(
                        width:
                            305, // Puedes ajustar el ancho del Container según lo que necesites
                        padding: const EdgeInsets.all(
                            16), // Espaciado interno si lo deseas

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
      width: 302,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffEFEFEF), width: .5),
      ),
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
