import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/date_helper.dart';

class InputDate extends StatefulWidget {
  const InputDate({
    super.key,
    required this.onChanged,
    required this.initialValue,
    required this.firstDate,
    required this.lastDate,
    this.borderColor = Colors.transparent,
    this.controller,
    this.errorPadding = false,
    this.errorText,
    this.fondoColor = Styles.colorContainer,
    this.fw,
    this.height,
    this.isRequired = false,
    this.label,
    this.labelColor,
    this.labelFontSize,
    this.placeholder,
    this.placeHolderColor = false,
    this.placeholderFontFamily,
    this.placeholderImage,
    this.placeholderSuffixSvg,
    this.placeholderSvg,
    this.prefiIcon,
    this.readOnly = false,
    this.suffixIcon,
  });

  final ValueChanged<DateTime> onChanged;
  
  final bool errorPadding;
  final bool isRequired;
  final bool placeHolderColor;
  final bool readOnly;
  final Color borderColor;
  final Color? fondoColor;
  final Color? labelColor;
  final DateTime initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final double? height;
  final double? labelFontSize;
  final FontWeight? fw;
  final Icon? prefiIcon;
  final Image? placeholderImage;
  final String? errorText;
  final String? label;
  final String? placeholder;
  final String? placeholderFontFamily;
  final String? placeholderSuffixSvg;
  final String? placeholderSvg;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _isControllerOwner = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _textController = widget.controller!;
      _isControllerOwner = false;
    } else {
      _textController = TextEditingController(
        text: DateHelper.formatUiDateShort(widget.initialValue),
      );
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
      // width: 302,
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
              _selectDate(context);
            },
            child: AbsorbPointer(
              absorbing: true,
              child: TextFormField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 15,
                  color: Color(0XFF383838),
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  labelText: widget.placeholder ?? 'placeholder',
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFFC9214), // Color del borde
                      width: 1, // Grosor del borde
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color:
                          Color(0xFFFC9214), // Color del borde punteado
                      width: 1,
                      style: BorderStyle.solid,
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
                onChanged: null, // Se utiliza onTap en GestureDetector
                readOnly: widget.readOnly,
              ),
            ),
          ),
          // Mensaje de error
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Remueve el foco para evitar que el teclado aparezca
    _focusNode.unfocus();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialValue,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
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
            dividerColor: const Color(0xFFFC9214),
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
              titleLarge: const TextStyle(
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
                foregroundColor: const Color(0xFFFF4931), // Color de los botones
                textStyle: const TextStyle(
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

    if (selectedDate != null) {
      widget.onChanged(selectedDate);

      setState(() {
        _textController.text = DateHelper.formatUiDateShort(selectedDate);
      });
    }
  }
}
