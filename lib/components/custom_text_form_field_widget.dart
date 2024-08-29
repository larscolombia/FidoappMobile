import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawlly/styles/styles.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String icon;
  final TextEditingController? controller;
  final bool? enabled;
  final bool? obscureText;
  final bool? isNumeric;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode; // Nueva propiedad

  CustomTextFormFieldWidget({
    Key? key,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.enabled,
    this.obscureText,
    this.isNumeric,
    this.validators,
    this.autovalidateMode =
        AutovalidateMode.disabled, // Inicializar nueva propiedad
  }) : super(key: key);

  @override
  _CustomTextFormFieldWidgetState createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  late bool _isObscure;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText ?? false;
    _errorMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller!,
      builder: (context, value, child) {
        bool hasText = value.text.isNotEmpty;
        return Focus(
          child: TextFormField(
            obscureText: _isObscure,
            controller: widget.controller,
            enabled: widget.enabled ?? true,
            keyboardType: widget.isNumeric == true
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: widget.isNumeric == true
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            autovalidateMode:
                widget.autovalidateMode, // Usar la nueva propiedad
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  hasText ? Colors.white : Color.fromRGBO(254, 247, 229, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
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
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Styles.iconColorBack,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.icon,
                  width: 20,
                  height: 20,
                ),
              ),
              labelText: hasText ? null : widget.placeholder,
              labelStyle: TextStyle(
                color: Styles.iconColorBack,
              ),
              errorText: _errorMessage,
              errorStyle: TextStyle(
                  color: Colors.red), // Cambiar color del texto de error a rojo
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
            onChanged: (value) {
              setState(() {
                _errorMessage = null;
              });
            },
            validator: (value) {
              if (widget.validators != null) {
                for (var validator in widget.validators!) {
                  final error = validator(value);
                  if (error != null) {
                    setState(() {
                      _errorMessage = error;
                    });
                    return _errorMessage;
                  }
                }
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
