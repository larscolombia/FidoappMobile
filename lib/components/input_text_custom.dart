import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';

class CustomTextFormField extends StatelessWidget {
  final String pleholder;
  final String icon;
  final TextEditingController? controller;
  final bool? enabled;
  final FocusNode _focusNode = FocusNode();

  CustomTextFormField({
    Key? key,
    required this.pleholder,
    required this.icon,
    required this.controller,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller!,
      builder: (context, value, child) {
        bool hasText = value.text.isNotEmpty;
        return Focus(
          focusNode: _focusNode,
          child: TextFormField(
            controller: controller,
            enabled: enabled ?? true,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  hasText ? Colors.white : Color.fromRGBO(254, 247, 229, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: hasText || _focusNode.hasFocus
                      ? Styles.iconColorBack
                      : Colors.transparent,
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
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Styles.iconColorBack.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                ),
              ),
              labelText: hasText || _focusNode.hasFocus ? null : pleholder,
              labelStyle: TextStyle(
                color: Color.fromRGBO(136, 136, 136, 1),
              ),
            ),
          ),
        );
      },
    );
  }
}
