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
    this.placeHolderColor = false,
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
    this.labelColor = null,
    this.labelFontSize = null,
    this.height = null,
    this.onImagePicked,
    this.isTextArea = false,
    this.fw,
  });

  final FontWeight? fw;
  final String? placeholder;
  final bool placeHolderColor;
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
  final Color? labelColor;
  final double? labelFontSize;
  final double? height;
  final ValueChanged<File>? onImagePicked;
  final bool isTextArea;

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue ?? "");
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
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
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
              child: Text(
                widget.label ?? 'label',
                style: TextStyle(
                  fontSize: widget.labelFontSize ?? 14,
                  color: widget.labelColor ?? Colors.black,
                  fontFamily: 'Lato',
                  fontWeight: widget.fw ?? FontWeight.w500,
                ),
              ),
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
                minLines: widget.isTextArea ? 5 : 1,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 13,
                  color: Color(0XFF383838),
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
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: widget.placeHolderColor == true
                        ? const Color(0XFF959595)
                        : Colors.black,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                  ),
                  alignLabelWithHint: widget.isTextArea,
                  contentPadding: widget.isTextArea
                      ? const EdgeInsets.symmetric(vertical: 20, horizontal: 20)
                      : const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
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
                  suffixIcon: Container(
                      padding: const EdgeInsets.only(right: 15),
                      width: 30,
                      child: widget.suffixIcon),
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
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.onChanged(value); // Debounce aplicado
                  });
                },
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
    // Remueve el foco para evitar que el teclado aparezca
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
      widget.onChanged(formattedDate); // Notifica el cambio
      setState(() {
        _textController.text = formattedDate; // Actualiza el controlador
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // Remueve el foco para evitar que el teclado aparezca
    _focusNode.unfocus();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      widget.onChanged(formattedTime); // Notifica el cambio
      setState(() {
        _textController.text = formattedTime; // Actualiza el controlador
      });
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
