import 'package:flutter/material.dart';
import 'package:pawlly/styles/styles.dart';

class CustomDateFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;
  final bool? enabled;
  final Color placeholderColor; // Color del placeholder
  final String? imagePath; // Ruta de la imagen para el prefixIcon
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDateFormFieldWidget({
    super.key,
    required this.placeholder,
    required this.controller,
    this.enabled,
    this.placeholderColor = Colors.black,
    this.imagePath,
    this.initialDate,
    this.firstDate,
    this.lastDate,
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
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: widget.initialDate ??  DateTime.now(),
                firstDate: widget.firstDate ?? DateTime(2000),
                lastDate: widget.lastDate ?? DateTime.now(),
              );
              if (pickedDate != null) {
                widget.controller?.text =
                    pickedDate.toLocal().toString().split(' ')[0];
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
