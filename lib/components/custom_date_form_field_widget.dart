import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';

class CustomDateFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;
  final bool? enabled;

  const CustomDateFormFieldWidget({
    super.key,
    required this.placeholder,
    required this.controller,
    this.enabled,
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
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
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
                prefixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: Styles.iconColorBack,
                    )),
                labelText: hasText ? null : widget.placeholder,
                labelStyle: const TextStyle(
                  color: Styles.iconColorBack,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
