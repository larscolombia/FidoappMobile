import 'package:flutter/material.dart';

class BotonCompartir extends StatelessWidget {
  const BotonCompartir({
    super.key,
    required this.modo,
    this.compra,
    this.onCompartir,
  });

  final String modo; // 'compra' o 'compartir'
  final bool?
      compra; // Define si el usuario adquirió el curso (solo para modoCompra)
  final void Function()?
      onCompartir; // Callback para el botón "Compartir curso"

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: modo == 'compartir'
          ? MainAxisAlignment.end // Alinear a la derecha en modo compartir
          : MainAxisAlignment.spaceBetween, // Espaciado normal en modo compra
      children: [
        if (modo == 'compra' &&
            (compra ?? false)) // Mostrar botón "Adquirido" solo si se compró
          Container(
            width: 127,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[90],
              border: Border.all(
                color: const Color.fromARGB(255, 11, 139, 21),
                width: 1,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 16,
                  ),
                  const Text(
                    'Adquirido',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: onCompartir, // Llamar al callback al tocar el botón
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 160,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 245, 245, 245),
                border: Border.all(
                  color: const Color.fromARGB(255, 172, 172, 172),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Compartir curso',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w600),
                  ),
                  Image.asset(
                    'assets/icons/send-2.png',
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
