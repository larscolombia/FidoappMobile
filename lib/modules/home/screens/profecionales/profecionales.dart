import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/home/screens/profecionales/user_card.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class Profecionales extends StatelessWidget {
  Profecionales({super.key});

  // Instancia del controlador
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 60;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Styles.colorContainer,
                    ),
                    child: Stack(
                      children: [
                        HeaderNotification(),
                        const BorderRedondiado(top: 170)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: width,
                child: BarraBack(
                  titulo: 'Profesionales',
                  callback: () {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Veterinarios
                    Expanded(
                      child: Obx(() => Selecboton(
                            titulo: 'Veterinarios',
                            callback: () {
                              controller.selectedButton.value = 'Veterinarios';
                              controller.type.value = 'vet';
                              controller.fetchUsers();
                            },
                            selected: controller.selectedButton.value ==
                                'Veterinarios',
                          )),
                    ),
                    const SizedBox(width: 10),
                    // Botón Entrenadores
                    Expanded(
                      child: Obx(() => Selecboton(
                            titulo: 'Entrenadores',
                            callback: () {
                              controller.selectedButton.value = 'Entrenadores';
                              controller.type.value = 'trainer';
                              controller.fetchUsers();
                            },
                            selected: controller.selectedButton.value ==
                                'Entrenadores',
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: width,
                child: const Text(
                  'Filtrar por:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: width,
                child: Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.expertTags.map((tag) {
                        final isSelected = controller.type.value == tag;

                        return GestureDetector(
                          onTap: () {
                            // Filtra usuarios basados en el tag seleccionado
                            controller.filterUsersByExpert(tag);
                            controller.type.value =
                                tag; // Marca el tag como seleccionado
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Styles.colorContainer
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: isSelected
                                    ? Styles.fiveColor
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: InputText(
                  onChanged: (value) {
                    controller.filterUsers(value);
                  },
                  placeholder: 'Realiza tu búsqueda',
                  fondoColor: Colors.white,
                  borderColor: const Color.fromARGB(255, 107, 105, 105),
                  placeholderImage: Image.asset('assets/icons/search.png'),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.filteredUsers.isEmpty) {
                  return const Text(
                      'No hay usuarios que coincidan con la búsqueda');
                }

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SizedBox(
                  width: width + 35,
                  height: MediaQuery.of(context).size.height *
                      0.4, // Altura fija o dinámica
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.filteredUsers[index];
                      return UserCard(user: user);
                    },
                  ),
                );
              }),
              RecargaComponente(
                callback: () {
                  controller.fetchUsers();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Selecboton extends StatelessWidget {
  final String titulo;
  final Function()? callback;
  final bool selected;

  const Selecboton({
    super.key,
    this.titulo = 'Todos',
    required this.callback,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 100,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? Color(0XFFFC9214) : Colors.white,
        ),
        child: Center(
          child: Text(
            titulo,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Lato',
            ),
          ),
        ),
      ),
    );
  }
}
