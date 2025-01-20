import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar los archivos de imagen

class InputText extends StatefulWidget {
  const InputText({
    super.key,
    this.label,
    this.placeholder,
    this.placeholderImage,
    this.placeholderFontFamily,
    required this.onChanged,
    this.isDateField = false,
    this.isFilePicker = false,
    this.isImagePicker = false,
    this.suffixIcon, // Ahora acepta un Widget en lugar de solo un Icon
    this.prefiIcon,
    this.isTimeField = false,
    this.readOnly = false,
    this.initialValue,
    this.fondoColor = Styles.colorContainer,
    this.borderColor = Colors.transparent,
    this.onImagePicked,
    this.isTextArea = false,
    this.fw,
  });

  final FontWeight? fw;
  final String? placeholder;
  final String? label;
  final String? placeholderFontFamily;
  final Image? placeholderImage;
  final bool isDateField;
  final bool isFilePicker;
  final bool isImagePicker;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon; // Cambiado a Widget para permitir una imagen
  final Icon? prefiIcon;
  final bool isTimeField;
  final bool readOnly;
  final String? initialValue;
  final Color? fondoColor;
  final Color borderColor;
  final ValueChanged<File>? onImagePicked;
  final bool isTextArea;

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late TextEditingController _textController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isTextArea ? double.infinity : 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 8),
              child: Text(
                widget.label ?? 'label',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: widget.fw ?? FontWeight.w500,
                ),
              ),
            ),
          GestureDetector(
            onTap: widget.isDateField
                ? () => _selectDate(context)
                : (widget.isTimeField
                    ? () => _selectTime(context)
                    : (widget.isFilePicker
                        ? () => _pickFile()
                        : (widget.isImagePicker ? () => _pickImage() : null))),
            child: AbsorbPointer(
              absorbing: widget.readOnly ||
                  widget.isDateField ||
                  widget.isTimeField ||
                  widget.isFilePicker ||
                  widget.isImagePicker,
              child: TextFormField(
                controller: _textController,
                maxLines: widget.isTextArea ? null : 1,
                minLines: widget.isTextArea ? 3 : 1,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: widget.isTextArea
                      ? null
                      : (widget.placeholder ?? 'placeholder'),
                  hintText: widget.isTextArea
                      ? (widget.placeholder ?? 'placeholder')
                      : null,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                  alignLabelWithHint: widget.isTextArea,
                  contentPadding: widget.isTextArea
                      ? const EdgeInsets.symmetric(vertical: 20, horizontal: 20)
                      : const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.borderColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.borderColor,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.fondoColor,
                  suffixIcon: widget.isFilePicker
                      ? const Icon(Icons.attach_file)
                      : widget.isImagePicker
                          ? const Icon(Icons.image)
                          : Container(
                              width: 24,
                              child: widget.suffixIcon,
                            ), // Ahora puede ser un Widget (Icono o Imagen)
                  prefixIcon: widget.prefiIcon ??
                      (widget.placeholderImage != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 12,
                              ),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: widget.placeholderImage,
                              ),
                            )
                          : null),
                ),
                onChanged: widget.onChanged,
                readOnly: widget.readOnly,
              ),
            ),
          ),
          if (_imageFile != null)
            Container(
              height: 220,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                    child: Text('Imagen Seleccionada'),
                  ),
                  SizedBox(
                    height: 200,
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
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;
      setState(() {
        _textController.text = fileName;
      });
      widget.onChanged(filePath);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _textController.text = pickedFile.name;
      });
      widget.onChanged(pickedFile.path);
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(_imageFile!);
      }
    }
  }
}
