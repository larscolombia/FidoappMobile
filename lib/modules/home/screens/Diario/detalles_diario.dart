import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/Diario/formulario_diario.dart';
import 'package:pawlly/modules/integracion/controller/diario/activida_mascota_controller.dart';

class DetallesDiario extends StatelessWidget {
  DetallesDiario({super.key});
  final PetActivityController controller = Get.put(PetActivityController());
  final HomeController homeController = Get.find<HomeController>();

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
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
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
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 320,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: BarraBack(
                              titulo: 'Sobre este Registro',
                              callback: () {
                                Get.back();
                              },
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Styles.colorContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('editar');
                                controller.updateField(
                                  'activityId',
                                  controller.activitiesOne.value!.id,
                                );
                                controller.updateField(
                                  'date',
                                  controller.activitiesOne.value!.date,
                                );
                                controller.updateField(
                                  'category_id',
                                  controller.activitiesOne.value!.categoryId,
                                );
                                controller.updateField(
                                  'notas',
                                  controller.activitiesOne.value!.notas,
                                );
                                controller.updateField(
                                  'pet_id',
                                  controller.activitiesOne.value!.petId,
                                );
                                controller.updateField(
                                  'image',
                                  controller.activitiesOne.value!.image,
                                );

                                Get.to(FormularioDiario(isEdit: true));
                              },
                              child: Image.asset(
                                'assets/icons/edit-2.png',
                                width: 24,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
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
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: 305,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sobre ${homeController.selectedProfile.value!.name}',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            controller.activitiesOne.value!.notas,
                            textAlign: TextAlign.center,
                            style: Styles.AvatarComentario,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Fecha ${controller.activitiesOne.value!.date}'),
                          const SizedBox(
                            height: 20,
                          ),
                          controller.activitiesOne.value!.image != null
                              ? Container(
                                  width: 302,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          controller.activitiesOne.value!.image,
                                        )),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
