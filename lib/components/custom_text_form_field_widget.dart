import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/styles/styles.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String? icon; // El icono ahora es opcional
  final String? placeholderSvg; // El SVG ahora es opcional
  final Color? colorSVG;
  final TextEditingController? controller;
  final bool? enabled;
  final bool? obscureText;
  final bool? isNumeric;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode;
  final Function(String)? callback;
  final String? suffixText;
  final Widget? suffixIcon;

  const CustomTextFormFieldWidget({
    super.key,
    required this.placeholder,
    this.icon, // Elimina el `required`
    this.placeholderSvg, // Elimina el `required`
    this.colorSVG,
    required this.controller,
    this.enabled,
    this.obscureText = false,
    this.isNumeric = false,
    this.suffixText,
    this.suffixIcon,
    this.validators,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.callback,
  }) : assert(
    obscureText != true || (suffixText == null && suffixIcon == null),
    'If obscureText is true, suffixText and suffixIcon must be null.',
  );

  @override
  _CustomTextFormFieldWidgetState createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText!;
  }

  @override
  Widget build(BuildContext context) {
    bool hasText = widget.controller?.text.isNotEmpty ?? false;

    var prefixIcon = widget.placeholderSvg != null
        ? Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: SvgPicture.asset(
              widget.placeholderSvg!,
              width: 20,
              height: 20,
              color: widget.colorSVG,
            ),
          )
        : widget.icon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Image.asset(
                  widget.icon!,
                  width: 20,
                  height: 20,
                ),
              )
            : null;

    var suffixIcon = widget.suffixIcon ?? (widget.obscureText == true
        ? Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFFFCBA67),
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          )
        : null);
    
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: hasText ? Colors.white : const Color.fromRGBO(254, 247, 229, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: hasText ? Styles.iconColorBack : Colors.transparent,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(
          color: Styles.iconColorBack,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      prefixIcon: prefixIcon,
      labelText: hasText ? null : widget.placeholder,
      labelStyle: const TextStyle(
        color: Color(0xff383838),
        fontSize: 14,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w500,
      ),
      suffixIcon: suffixIcon,
      suffixText: widget.suffixText ?? '',
    );

    return TextFormField(
      obscureText: _isObscure,
      controller: widget.controller,
      enabled: widget.enabled ?? true,
      keyboardType: widget.isNumeric == true ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.isNumeric == true
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      autovalidateMode: widget.autovalidateMode,
      decoration: inputDecoration,
      onChanged: widget.callback,
      validator: (value) {
        if (widget.validators != null) {
          for (var validator in widget.validators!) {
            final error = validator(value);
            if (error != null) {
              return error;
            }
          }
        }
        return null;
      },
    );
  }
}
