import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart'; // Importamos image_picker
import 'dart:io'; // Para manejar los archivos de imagen

class InputText extends StatefulWidget {
  const InputText({
    Key? key,
    this.label,
    this.placeholder,
    required this.onChanged,
    this.isDateField = false,
    this.isFilePicker = false, // Habilitar carga de archivos
    this.isImagePicker = false, // Habilitar carga de imagen
    this.suffixIcon,
    this.prefiIcon,
    this.isTimeField = false,
  }) : super(key: key);

  final String? placeholder;
  final String? label;
  final bool isDateField;
  final bool isFilePicker;
  final bool
      isImagePicker; // Nuevo parámetro para habilitar la selección de imágenes
  final ValueChanged<String> onChanged;
  final Icon? suffixIcon;
  final Icon? prefiIcon;
  final bool isTimeField;

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final TextEditingController _textController = TextEditingController();
  File? _imageFile; // Para almacenar la imagen seleccionada

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label ?? 'label',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: widget.isDateField
                ? () => _selectDate(context)
                : (widget.isTimeField
                    ? () => _selectTime(context)
                    : (widget.isFilePicker
                        ? () => _pickFile()
                        : (widget.isImagePicker ? () => _pickImage() : null))),
            child: AbsorbPointer(
              absorbing: widget.isDateField ||
                  widget.isTimeField ||
                  widget.isFilePicker ||
                  widget.isImagePicker,
              child: TextFormField(
                controller:
                    _textController, // Controlador para mostrar el nombre
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Styles.fiveColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Styles.fiveColor,
                      width: .5,
                    ),
                  ),
                  labelText: widget.placeholder ?? 'placeholder',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Styles.colorContainer,
                  suffixIcon: widget.isFilePicker
                      ? Icon(Icons.attach_file) // Icono de archivo
                      : widget.isImagePicker
                          ? Icon(Icons.image) // Icono de imagen
                          : widget.suffixIcon,
                  prefixIcon: widget.prefiIcon,
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
          // Mostrar vista previa de la imagen seleccionada
          if (_imageFile != null)
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.onChanged(dateFormat.format(picked));
      _textController.text = dateFormat.format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      widget.onChanged(picked.format(context));
      _textController.text = picked.format(context);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Solo permitir archivos PDF
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name; // Obtén el nombre del archivo

      setState(() {
        _textController.text =
            fileName; // Actualiza el campo con el nombre del archivo
      });

      widget.onChanged(filePath); // Notifica al padre la ruta del archivo
    }
  }

  // Función para seleccionar una imagen desde la galería
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Obtener la imagen desde la galería

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Actualiza la imagen
        _textController.text = pickedFile
            .name; // Puedes actualizar el campo con el nombre de la imagen si lo prefieres
      });

      widget.onChanged(pickedFile
          .path); // Notificar al padre la ruta de la imagen seleccionada
    }
  }
}
