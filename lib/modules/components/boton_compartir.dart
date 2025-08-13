import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/components/debounce_gesture_detector.dart';

class BotonCompartir extends StatelessWidget {
  const BotonCompartir({
    super.key,
    this.title,
    required this.modo,
    this.compra,
    this.onCompartir,
  });

  final String? title; // Título del botón (solo para modo compartir)
  final String modo; // 'compra' o 'compartir'
  final bool?
      compra; // Define si el usuario adquirió el curso (solo para modo compra)
  final void Function()?
      onCompartir; // Callback para el botón "Compartir curso"

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primer Flexible: botón "Adquirido" si se compró, o un contenedor vacío en caso contrario
        Flexible(
          child: (compra ?? false)
              ? Container(
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xFFE5FEED),
                    border: Border.all(
                      color: const Color(0xFF19A02F),
                      width: 0.5,
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          color: Color(0xFF19A02F),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Adquirido',
                          style: TextStyle(
                            color: Color(0xFF19A02F),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(), // Contenedor vacío para ocupar el espacio
        ),
        const SizedBox(width: 8),
        // Segundo Flexible: siempre muestra el botón "Compartir"
        Flexible(
          child: DebounceGestureDetector(
            debounceDuration: const Duration(milliseconds: 500),
            onTap: onCompartir,
            child: Container(
              height: 32,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 245, 245, 245),
                border: Border.all(
                  color: const Color.fromARGB(255, 172, 172, 172),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Text(
                      title ?? "Compartir video",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/svg/send-2.svg',
                    width: 20,
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
