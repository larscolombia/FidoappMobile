import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para manejar los archivos de imagen

class InputText extends StatefulWidget {
  const InputText({
    Key? key,
    this.label,
    this.placeholder,
    required this.onChanged,
    this.isDateField = false,
    this.isFilePicker = false,
    this.isImagePicker = false,
    this.suffixIcon,
    this.prefiIcon,
    this.isTimeField = false,
    this.readOnly = false,
    this.initialValue,
    this.fondoColor = Styles.colorContainer,
    this.onImagePicked, // Añade el callback para la imagen
  }) : super(key: key);

  final String? placeholder;
  final String? label;
  final bool isDateField;
  final bool isFilePicker;
  final bool isImagePicker;
  final ValueChanged<String> onChanged;
  final Icon? suffixIcon;
  final Icon? prefiIcon;
  final bool isTimeField;
  final bool readOnly;
  final String? initialValue;
  final Color? fondoColor;
  final ValueChanged<File>?
      onImagePicked; // Callback para cuando se selecciona una imagen

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
      width: 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Text(
                  widget.label ?? 'label',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                )
              : SizedBox(),
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
              absorbing: widget.readOnly ||
                  widget.isDateField ||
                  widget.isTimeField ||
                  widget.isFilePicker ||
                  widget.isImagePicker,
              child: TextFormField(
                controller: _textController,
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
                  fillColor: widget.fondoColor,
                  suffixIcon: widget.isFilePicker
                      ? Icon(Icons.attach_file)
                      : widget.isImagePicker
                          ? Icon(Icons.image)
                          : widget.suffixIcon,
                  prefixIcon: widget.prefiIcon,
                ),
                onChanged: widget.onChanged,
                readOnly: widget.readOnly,
              ),
            ),
          ),
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
