import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_snackbar.dart';
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
          width: MediaQuery.of(context).size.width,
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
                    imagePath: _getImageForTool(index),
                    title: tool.name,
                    audioUrl: tool.audio ?? "",
                    onError: () => CustomSnackbar.show(
                      title: "Error",
                      message: "No se encontró el sonido",
                      isError: true,
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
        return 'assets/icons/svg/Silbar.svg';
      case 1:
        return 'assets/icons/svg/Correa.svg';
      case 2:
        return 'assets/icons/svg/Tecontador.svg';
      default:
        return 'assets/icons/svg/Silbar.svg';
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
              child: SvgPicture.asset(
                imagePath,
                placeholderBuilder: (context) => Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey, // Imagen gris de respaldo
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 24,
                  );
                },
              ),
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
