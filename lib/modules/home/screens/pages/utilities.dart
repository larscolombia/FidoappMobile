import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/controller/herramientas/herramientas_controller.dart';
import 'package:pawlly/modules/integracion/controller/soun/soun_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Utilities extends StatelessWidget {
  Utilities({Key? key}) : super(key: key);

  final SounController sounController = Get.put(SounController());
  final HerramientasController herramientasController =
      Get.put(HerramientasController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Utilidades',
          style: TextStyle(
            fontSize: 20,
            color: Styles.primaryColor,
            fontFamily: 'PoetsenOne',
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (herramientasController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lista de herramientas (puedes agregar más elementos aquí)
          final tools = herramientasController.tools;

          return Row(
            children: List.generate(
              tools.length,
              (index) {
                final tool = tools[index];

                return Expanded(
                  child: ToolWidget(
                    imagePath: "$DOMAIN_URL/${tool.image}",
                    title: tool.name,
                    audioUrl: tool.audio,
                    onError: () => Get.snackbar(
                      "Error",
                      "No se encontró el sonido",
                      backgroundColor: Colors.red,
                    ),
                  ),
                );
              },
            ).toList(),
          );
        }),
      ],
    );
  }

  String _getImageForTool(int index) {
    switch (index) {
      case 0:
        return 'assets/icons/silbar.png';
      case 1:
        return 'assets/icons/Correa.png';
      case 2:
        return 'assets/icons/tecontador.png';
      default:
        return 'assets/icons/default.png';
    }
  }
}

class ToolWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String audioUrl;
  final VoidCallback onError;

  const ToolWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.audioUrl,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (audioUrl.isNotEmpty) {
          await Get.find<SounController>().urlSound(audioUrl);
        } else {
          onError();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        height: 93,
        decoration: BoxDecoration(
          color: Styles.fiveColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imagePath),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Styles.greyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
