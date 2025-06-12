import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';

class InputTextFullWidth extends StatefulWidget {
  const InputTextFullWidth({
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
    this.placeholderSuffixSvg,
    this.prefiIcon,
    this.isTimeField = false,
    this.readOnly = false,
    this.initialValue,
    this.fondoColor = Styles.colorContainer,
    this.borderColor = Colors.transparent,
    this.labelColor,
    this.labelFontSize,
    this.height,
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
  final bool placeHolderColor;
  final String? label;
  final String? placeholderFontFamily;
  final Image? placeholderImage;
  final String? placeholderSvg;
  final String? placeholderSuffixSvg;
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
  final TextEditingController? controller;
  final bool isRequired;
  final String? errorText; // Mensaje de error externo
  final bool errorPadding;
  @override
  _InputTextFullWidthState createState() => _InputTextFullWidthState();
}

class _InputTextFullWidthState extends State<InputTextFullWidth> {
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
    return SizedBox(
      width: double.infinity,
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
                      color: const Color(0xFF383838),
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
                if (widget.readOnly == false) {
                  _selectDate(context);
                }
              } else if (widget.isTimeField) {
                if (widget.readOnly == false) {
                  _selectTime(context);
                }
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
                maxLines: widget.isTextArea ? null : 5,
                minLines: widget.isTextArea ? 3 : 1,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 15,
                  color: Color(0XFF383838),
                  fontWeight: FontWeight.w400,
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
                  border: widget.isImagePicker || widget.isDateField
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFFC9214), // Color del borde
                            width: 1, // Grosor del borde
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: widget.errorText != null
                                ? widget.borderColor // Borde rojo si hay error
                                : widget.borderColor,
                            width: 1,
                          ),
                        ),
                  enabledBorder: widget.isImagePicker || widget.isDateField
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color:
                                Color(0xFFFC9214), // Color del borde punteado
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        )
                      : widget.isFilePicker
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(
                                    0xFFFCBA67), // Color del borde cuando no está seleccionado
                                width: 1,
                              ),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: widget.errorPadding
                                    ? Colors.red
                                    : widget.borderColor,
                                width: 1,
                              ),
                            ),
                  filled: true,
                  fillColor: widget.fondoColor,
                  suffixIcon: widget.placeholderSuffixSvg != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: SizedBox(
                            width: 0.1,
                            height: 0.1,
                            child: SvgPicture.asset(
                              widget.placeholderSuffixSvg!,
                              width: 0.1,
                              height: 0.1,
                            ),
                          ),
                        )
                      : Container(
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
            SizedBox(
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: double
                        .infinity, // Para que ocupe todo el ancho disponible
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                        alignment: Alignment
                            .center, // Asegura que la imagen esté centrada
                      ),
                    ),
                  ),
                ],
              ),
            )
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
      confirmText: 'Aceptar',
      cancelText: 'Cancelar',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFC9214), // Color del header
              onPrimary: Colors.white, // Texto en el header
              surface: Colors.white, // Fondo del calendario
              onSurface: Colors.black, // Texto del calendario
              secondary: Color(0xFFFC9214), // Color para selección de días
            ),
            dividerColor: Color(0xFFFC9214),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFC9214), // Color del header
              foregroundColor: Colors.white, // Color del texto del header
              surfaceTintColor: Color(0xFFFC9214),
              titleTextStyle: TextStyle(
                // Fuente del header
                fontFamily: 'PoetsenOne',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            datePickerTheme: const DatePickerThemeData(
              headerBackgroundColor: Color(0xFFFF4931),
              headerForegroundColor: Colors.white,
              dividerColor: Color(0xFFFF4931),
              backgroundColor: Colors.white,
              headerHeadlineStyle: TextStyle(
                fontFamily: 'PoetsenOne',
                fontWeight: FontWeight.w400,
                fontSize: 26,
              ),
              headerHelpStyle: TextStyle(
                fontFamily: 'PoetsenOne',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                // Fuente para el día, mes y año
                fontFamily: 'PoetsenOne',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              labelLarge: GoogleFonts.lato(
                // Fuente para los botones Aceptar/Cancelar
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.orange,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFFF4931), // Color de los botones
                textStyle: TextStyle(
                  fontFamily: 'PoetsenOne',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      final formattedDate = dateFormat.format(picked);
      widget.onChanged(formattedDate); // Notifica el cambio

      setState(() {
        // Actualizamos el controlador con la fecha formateada como DD/MM/YYYY
        print('fecha ${formattedDate}');
        _textController.text = Helper.formatDate(formattedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // Remueve el foco para evitar que el teclado aparezca
    _focusNode.unfocus();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      confirmText: 'Aceptar',
      cancelText: 'Cancelar',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFC9214), // Color del header
              onPrimary: Colors.white, // Texto en el header
              surface: Colors.white, // Fondo del selector de hora
              onSurface: Colors.black, // Texto del selector de hora
              secondary: Color(0xFFFC9214), // Color de selección
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFC9214),
              foregroundColor: Colors.white,
              surfaceTintColor: Color(0xFFFC9214),
              titleTextStyle: TextStyle(
                fontFamily: 'PoetsenOne',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white, // Fondo del TimePicker
              hourMinuteColor:
                  Color(0xFFFC9214), // Color del número seleccionado
              hourMinuteTextColor:
                  Colors.white, // Texto de la hora seleccionada
              dialHandColor: Color(0xFFFC9214), // Color de la aguja del reloj
              dialBackgroundColor: Colors.white, // Fondo del reloj
              entryModeIconColor: Color(0xFFFC9214), // Icono de cambio de modo
              hourMinuteTextStyle: TextStyle(
                fontFamily: 'PoetsenOne',
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
              helpTextStyle: TextStyle(
                fontFamily: 'PoetsenOne',
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Colors.black, // Cambia el color del texto
              ),
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(
                fontFamily: 'PoetsenOne',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              labelLarge: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.orange,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFFF4931),
                textStyle: TextStyle(
                  fontFamily: 'PoetsenOne',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
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
