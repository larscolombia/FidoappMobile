import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pawlly/modules/helper/helper.dart';

import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/utils/common_base.dart';

class CustomDateFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;
  final bool? enabled;
  final Color placeholderColor; // Color del placeholder
  final String? imagePath; // Ruta de la imagen para el prefixIcon

  const CustomDateFormFieldWidget({
    super.key,
    required this.placeholder,
    required this.controller,
    this.enabled,
    this.placeholderColor = Colors.black, // Valor por defecto: negro
    this.imagePath, // Imagen opcional para el prefixIcon
  });

  @override
  _CustomDateFormFieldWidgetState createState() =>
      _CustomDateFormFieldWidgetState();
}

class _CustomDateFormFieldWidgetState extends State<CustomDateFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller!,
      builder: (context, value, child) {
        bool hasText = value.text.isNotEmpty;

        return GestureDetector(
          onTap: () async {
            if (widget.enabled ?? true) {
              final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
              DateTime? pickedDate = await showDatePicker(
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
              if (pickedDate != null) {
                final formattedDate = dateFormat.format(pickedDate);
                widget.controller?.text = Helper.formatDate(formattedDate);
              }
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: widget.controller,
              enabled: widget.enabled ?? true,
              decoration: InputDecoration(
                filled: true,
                fillColor: hasText
                    ? Colors.white
                    : const Color.fromRGBO(254, 247, 229, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasText ? Styles.iconColorBack : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Styles.iconColorBack,
                    width: 1.0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Styles.iconColorBack.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                // Usar imagen como prefixIcon si está definida
                prefixIcon: widget.imagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          widget.imagePath!,
                          width: 24,
                          height: 24,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.calendar_today,
                          color: Styles.iconColorBack,
                        ),
                      ),
                labelText: hasText ? null : widget.placeholder,
                labelStyle: TextStyle(
                  color: widget
                      .placeholderColor, // Cambiar el color del placeholder
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
