import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawlly/styles/styles.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String? icon; // El icono ahora es opcional
  final TextEditingController? controller;
  final bool? enabled;
  final bool? obscureText;
  final bool? isNumeric;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode;
  final Function(String)? callback;

  const CustomTextFormFieldWidget({
    super.key,
    required this.placeholder,
    this.icon, // Elimina el `required`
    required this.controller,
    this.enabled,
    this.obscureText = false,
    this.isNumeric = false,
    this.validators,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.callback,
  });

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

    return TextFormField(
      obscureText: _isObscure,
      controller: widget.controller,
      enabled: widget.enabled ?? true,
      keyboardType:
          widget.isNumeric == true ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.isNumeric == true
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            hasText ? Colors.white : const Color.fromRGBO(254, 247, 229, 1),
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
          borderRadius: BorderRadius.circular(8.0),
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
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        prefixIcon: widget.icon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.icon!,
                  width: 20,
                  height: 20,
                ),
              )
            : null, // Si `icon` es null, no se muestra nada
        labelText: hasText ? null : widget.placeholder,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: widget.obscureText == true
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Styles.iconColorBack,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
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
