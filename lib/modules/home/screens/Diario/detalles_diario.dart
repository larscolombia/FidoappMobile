import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/formulario_diario.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class DetallesDiario extends StatelessWidget {
  DetallesDiario({super.key});
  final PetActivityController controller = Get.put(PetActivityController());
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Styles.colorContainer,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: Styles.paddingAll, // Aplicando el padding global
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 130,
                              child: BarraBack(
                                titulo: 'Sobre este Registro',
                                size: 20,
                                callback: () {
                                  Get.back();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Styles.colorContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.updateField(
                                      'actividad',
                                      controller.activitiesOne.value!.actividad,
                                    );
                                    controller.updateField(
                                      'date',
                                      controller.activitiesOne.value!.date,
                                    );
                                    controller.updateField(
                                      'category_id',
                                      controller.activitiesOne.value!.categoryId
                                          .toString(),
                                    );
                                    controller.updateField(
                                      'notas',
                                      controller.activitiesOne.value!.notas,
                                    );
                                    controller.updateField(
                                      'pet_id',
                                      controller.activitiesOne.value!.petId
                                          .toString(),
                                    );
                                    controller.updateField(
                                      'image',
                                      controller.activitiesOne.value!.image ??
                                          "",
                                    );
                                    //print(controller.diario);
                                    Get.to(
                                        () => FormularioDiario(isEdit: true));
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/edit-2.svg',
                                    width:
                                        40, // Ajusta el tamaño según sea necesario
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return SizedBox(
                          width: 250,
                          child: Text(
                            controller.activitiesOne.value!.actividad,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'PoetsenOne',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                'Sobre ${homeController.selectedProfile.value!.name}',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.black),
                              );
                            }),
                            const SizedBox(height: 10),
                            Obx(() {
                              return Text(
                                controller.activitiesOne.value!.notas,
                                textAlign: TextAlign.start,
                                style: Styles.AvatarComentario,
                              );
                            }),
                            const SizedBox(height: 26),
                            Obx(() {
                              return Text(
                                  'Fecha: ${controller.activitiesOne.value!.date}',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black));
                            }),
                            const SizedBox(height: 26),
                            Obx(() {
                              if (controller.activitiesOne.value!.image ==
                                  null) {
                                return Center(
                                  child: SizedBox(
                                    width: 302,
                                    height: 200,
                                    child: Image.asset(
                                        'assets/images/actividad.jpg'),
                                  ),
                                );
                              }
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        controller.activitiesOne.value!.image ??
                                            ''),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              );
                            }),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
