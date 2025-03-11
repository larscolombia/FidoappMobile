import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/style.dart';

class TagInputWidget extends StatefulWidget {
  /// Lista inicial de tags con la que se iniciará el Widget.
  final List<String> initialTags;

  /// Callback para notificar al padre cuando cambie la lista de tags.
  final ValueChanged<List<String>>? onChanged;

  const TagInputWidget({
    Key? key,
    required this.initialTags,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  /// Lista interna de tags.
  late List<String> _tags;

  /// Controlador temporal para el campo de texto del diálogo.
  final TextEditingController _dialogController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Copiamos las tags iniciales para trabajar con ellas.
    _tags = List.from(widget.initialTags);
  }

  /// Método para mostrar el diálogo que permite al usuario agregar una nueva tag.
  void _showAddTagDialog() {
    _dialogController
        .clear(); // Limpiamos el texto cada vez que abrimos el diálogo

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white, // Fondo blanco
        contentPadding: const EdgeInsets.all(20),
        title: const Text(
          'Nueva Tab',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            color: const Color(0xFFFF4931),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _dialogController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Tab',
                labelStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Cerramos el diálogo sin hacer nada
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 8,
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontFamily: 'Lato',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text(
              'Cancelar',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 8,
              ),
              elevation: 0,
            ),
            onPressed: () {
              final newTag = _dialogController.text.trim();
              if (newTag.isNotEmpty && !_tags.contains(newTag)) {
                // Agrega el texto con comillas dobles.
                final quotedTag = '"$newTag"';

                setState(() {
                  _tags.add(quotedTag);
                });
                widget.onChanged?.call(_tags);
              }
              // Cerramos el diálogo
              Get.back();
            },
            child: const Text(
              'Agregar',
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Método para eliminar la tag.
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onChanged?.call(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Muestra las tags como chips
        Wrap(
          spacing: 9.0,
          runSpacing: 4.0,
          children: [
            for (String tag in _tags)
              Chip(
                backgroundColor: Styles.colorContainer,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Styles.colorContainer, // Color del borde del chip
                    width: 1, // Grosor del borde
                  ),
                  borderRadius:
                      BorderRadius.circular(16), // Radio de las esquinas
                ),
                label: Text(
                  tag,
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Styles.iconColorBack, // Color del texto
                  ),
                ),
                // Elimina el borde de la "X" y usa el mismo color que el texto
                deleteIcon: const Icon(
                  Icons.close,
                  color: Styles.iconColorBack,
                  size: 14.00,
                ), // Ícono de la "X"
                deleteIconColor:
                    Styles.iconColorBack, // Color del ícono de eliminación

                onDeleted: () => _removeTag(tag),
              ),
            // El "Chip" (o botón) para agregar una nueva tag
            ActionChip(
              backgroundColor: Styles.iconColorBack,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Styles.iconColorBack, // Color del borde del chip
                  width: 1, // Grosor del borde
                ),
                borderRadius:
                    BorderRadius.circular(16), // Radio de las esquinas
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Añadir Tab',
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white, // Color del texto
                    ),
                  ),
                  const SizedBox(width: 15), // Espacio para separar el icono
                  SvgPicture.asset(
                    'assets/icons/svg/vector_plus.svg',
                    height: 10, // Ajusta el tamaño del ícono si es necesario
                    width: 10,
                  ),
                ],
              ),
              onPressed: _showAddTagDialog,
            )
          ],
        ),
      ],
    );
  }
}
