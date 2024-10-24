import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:pawlly/modules/profile_pet/screens/widget/show_filter_dialog.dart';
import 'package:pawlly/styles/styles.dart';

class MedicalHistoryTab extends StatelessWidget {
  final ProfilePetController controller;

  MedicalHistoryTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Cambiamos a SingleChildScrollView para manejar el contenido desplazable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Historia Clínica',
              style: Styles.dashboardTitle20,
            ),
          ),
          const SizedBox(height: 16),
          // Barra de búsqueda y botón de filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    enabled: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Realiza tu búsqueda',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/ic_search2.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    FilterDialog.show(context, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Styles.fiveColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Styles.iconColorBack,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Lista del historial médico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Desactivar el scroll del GridView
              shrinkWrap:
                  true, // Permitir que el GridView se ajuste al contenido
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.70,
              ),
              itemCount: controller.medicalHistory.length,
              itemBuilder: (context, index) {
                final history = controller.medicalHistory[index];
                // Aquí no necesitas un Obx ya que estás mostrando datos fijos
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 55,
                        child: Text(
                          history['title']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${history['type']}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Styles.iconColorBack,
                        ),
                      ),
                      Text(
                        '${history['date']}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Informe: ${history['reportNumber']}',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ButtonDefaultWidget(
                          title: 'Abrir >',
                          callback: () {},
                          heigthButtom: 46,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
