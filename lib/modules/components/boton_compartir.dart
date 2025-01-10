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
      compra; // Define si el usuario adquirió el curso (solo para modoCompra)
  final void Function()?
      onCompartir; // Callback para el botón "Compartir curso"

  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Botón "Adquirido" solo si está en modo compra y fue adquirido
          if (modo == 'compra' && (compra ?? false))
            Flexible(
              flex: 1,
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green[90],
                  border: Border.all(
                    color: const Color.fromARGB(255, 11, 139, 21),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          color: Colors.green,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Botón "Compartir"
          Flexible(
            flex: modo == 'compartir' ? 2 : 1, // Ajustar según el modo
            child: GestureDetector(
              onTap: onCompartir,
              child: Padding(
                padding: const EdgeInsets.only(left: 125.0, right:10.0, bottom: 10.0),
                child: Container(
                  height: 32,
                  width: 220,
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
                      Flexible(
                        child: Image.asset(
                          'assets/icons/send-2.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
