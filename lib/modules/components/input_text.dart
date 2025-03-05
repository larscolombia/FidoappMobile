import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pawlly/modules/components/style.dart';

class InputText extends StatefulWidget {
  const InputText({
    super.key,
    this.label,
    this.placeholder,
    this.placeholderImage,
    this.placeholderSvg,
    this.placeholderFontFamily,
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
    this.borderColor = Colors.transparent,
    this.onImagePicked,
    this.isTextArea = false,
    this.fw,
    this.controller,
    this.isRequired = false,
    this.errorText, // Nuevo parámetro para mensajes de error
    this.errorPadding = false,
  });

  final FontWeight? fw;
  final String? placeholder;
  final String? label;
  final String? placeholderFontFamily;
  final Image? placeholderImage;
  final String? placeholderSvg;
  final bool isDateField;
  final bool isFilePicker;
  final bool isImagePicker;
  final ValueChanged<String> onChanged;
  final Widget? suffixIcon;
  final Icon? prefiIcon;
  final bool isTimeField;
  final bool readOnly;
  final String? initialValue;
  final Color? fondoColor;
  final Color borderColor;
  final ValueChanged<File>? onImagePicked;
  final bool isTextArea;
  final TextEditingController? controller;
  final bool isRequired;
  final String? errorText; // Mensaje de error externo
  final bool errorPadding;
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  File? _imageFile;
  bool _isControllerOwner = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _textController = widget.controller!;
      _isControllerOwner = false;
    } else {
      _textController = TextEditingController(text: widget.initialValue ?? "");
      _isControllerOwner = true;
    }
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    if (_isControllerOwner) {
      _textController.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isTextArea ? double.infinity : 302,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
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
              if (widget.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8),
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),

          GestureDetector(
            onTap: () {
              if (widget.isDateField) {
                _selectDate(context);
              } else if (widget.isTimeField) {
                _selectTime(context);
              } else if (widget.isFilePicker) {
                _pickFile();
              } else if (widget.isImagePicker) {
                _pickImage();
              }
            },
            child: AbsorbPointer(
              absorbing: widget.readOnly ||
                  widget.isDateField ||
                  widget.isTimeField ||
                  widget.isFilePicker ||
                  widget.isImagePicker,
              child: TextFormField(
                controller: _textController,
                focusNode: _focusNode,
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
                      : const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? widget.borderColor // Borde rojo si hay error
                          : widget.borderColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color:
                          widget.errorPadding ? Colors.red : widget.borderColor,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.fondoColor,
                  suffixIcon: Container(
                    padding: const EdgeInsets.only(right: 15),
                    width: 30,
                    child: widget.suffixIcon,
                  ),
                  prefixIcon: widget.prefiIcon ??
                      (widget.placeholderSvg != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 5,
                              ),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(widget.placeholderSvg!),
                              ),
                            )
                          : widget.placeholderImage != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 5,
                                  ),
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: widget.placeholderImage,
                                  ),
                                )
                              : null),
                ),
                onChanged: (value) {
                  widget.onChanged(value);
                },
                readOnly: widget.readOnly,
              ),
            ),
          ),
          // Mensaje de error

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

  // Métodos para selectores de fecha/hora/archivo...
  Future<void> _selectDate(BuildContext context) async {
    _focusNode.unfocus();
    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final formattedDate = dateFormat.format(picked);
      widget.onChanged(formattedDate);
      setState(() => _textController.text = formattedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    _focusNode.unfocus();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      widget.onChanged(formattedTime);
      setState(() => _textController.text = formattedTime);
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
      setState(() => _textController.text = fileName);
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
      widget.onImagePicked?.call(_imageFile!);
    }
  }
}
