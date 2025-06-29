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
import 'package:pawlly/modules/profile_pet/screens/pet_passport_form.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/info_mascota.dart';

class PetPassportView extends StatelessWidget {
  PetPassportView({super.key});
  
  final _homeController = Get.find<HomeController>();
  final _historiaClinicaController = Get.put(HistorialClinicoController());

  String formatFecha(String fecha) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = inputFormat.parse(fecha);
    DateFormat outputFormat = DateFormat("d 'de' MMMM 'de' y", 'es_ES');
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var ancho = MediaQuery.sizeOf(context).width;
    var margen = Helper.margenDefault;

    var profileData = Obx(() {
      var mascota = _homeController.selectedProfile.value!;

      return Column(
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
                      Get.off(const HomeScreen());
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const PetPassportForm());
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
          const SizedBox(height:12),

          // Imagen de la mascota
          Container(
            width: ancho,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: Obx(() {
              final imageUrl = _homeController.selectedProfile.value!.petImage ??
                'https://via.placeholder.com/600x400';

              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
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

          // Chip
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'PoetsenOne',
              color: Color(0xFFFF4931),
            ),
          ),
          SizedBox(height: margen),
          // Nombre
          InfoMascota(
            titulo: 'Nombre',
            value: mascota.name,
          ),
          // Especie
          InfoMascota(
            titulo: 'Especie',
            // value: 'Canino',
            value: mascota.pettype,
          ),
          // Sexo
          InfoMascota(
            titulo: 'Sexo',
            value: mascota.gender == "female"
                ? 'Hembra'
                : 'Macho',
          ),
          // Raza
          InfoMascota(
            titulo: 'Raza',
            value: mascota.breed,
          ),
          // Fecha de nacimiento
          InfoMascota(
            titulo: 'Fecha de nacimiento',
            value: mascota.birthDateFormatted,
          ),
          // Color del pelaje
          InfoMascota(
            titulo: 'Color del pelaje',
            value: mascota.petFur ?? '',
          ),
          // Peso
          InfoMascota(
            titulo: 'Peso',
            value: '${mascota.weight} ${mascota.weightUnit}',
          ),
          // Altura
          InfoMascota(
            titulo: 'Altura',
            value: '${mascota.height} ${mascota.heightUnit}',
          ),
          // Marcas distintivas
          InfoMascota(
            titulo: 'Marcas distintivas',
            value: mascota.description ??
                "No se ha definido una descripción",
          ),
          const SizedBox(height: 20),

          Helper.titulo('Datos de Vacunación y Tratamientos'),
          SizedBox(height: margen),

          HistorialGrid(controller: _historiaClinicaController),
          SizedBox(height: margen),
        ],
      );
    });
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Primer contenedor (fondo o header)
          Container(
            height: 160,
            width: ancho,
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
                  padding: const EdgeInsets.only(
                    right: 26,
                    left: 26,
                  ),
                  child: profileData,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
