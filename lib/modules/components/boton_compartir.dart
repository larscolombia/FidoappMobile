import 'package:flutter/material.dart';

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
                    color: Colors.green.shade100,
                    border: Border.all(
                      color: const Color.fromARGB(255, 11, 139, 21),
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Adquirido',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff19A02F),
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
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
          child: GestureDetector(
            onTap: onCompartir,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      title ?? "Compartir video",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'assets/icons/send-2.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
