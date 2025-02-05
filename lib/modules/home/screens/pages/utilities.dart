import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/controller/herramientas/herramientas_controller.dart';
import 'package:pawlly/modules/integracion/controller/soun/soun_controller.dart';
import 'package:pawlly/styles/styles.dart';

class Utilities extends StatefulWidget {
  Utilities({Key? key}) : super(key: key);

  @override
  State<Utilities> createState() => _UtilitiesState();
}

class _UtilitiesState extends State<Utilities> {
  final SounController sounController = Get.put(SounController());
  final HerramientasController herramientasController =
      Get.put(HerramientasController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eliminamos el Center para evitar centrar el contenedor completo
        Container(
          width: width,
          // Aseguramos la alineación del contenido a la izquierda
          alignment: Alignment.centerLeft,
          child: const Text(
            'Utilidades',
            style: TextStyle(
              fontSize: 20,
              color: Styles.primaryColor,
              fontFamily: 'PoetsenOne',
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (herramientasController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lista de herramientas (puedes agregar más elementos aquí)
          final tools = herramientasController.tools;
          print('tools ${tools.length}');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              tools.length,
              (index) {
                final tool = tools[index];

                return Container(
                  width: MediaQuery.of(context).size.width / 3.7,
                  child: ToolWidget(
                    index: index,
                    imagePath: "$DOMAIN_URL/${tool.image}",
                    title: tool.name,
                    audioUrl: tool.audio ?? "",
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
        return 'assets/icons/silbar.png';
    }
  }
}

class ToolWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String audioUrl;
  final VoidCallback onError;
  final int index;
  const ToolWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.audioUrl,
    required this.onError,
    required this.index,
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
        height: 94,
        width: 94,
        decoration: BoxDecoration(
          color: Styles.fiveColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              child: Image.network(imagePath,
                  loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey, // Imagen gris de respaldo
                );
              }),
            ),
            const SizedBox(height: 8),
            Container(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Styles.greyTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
