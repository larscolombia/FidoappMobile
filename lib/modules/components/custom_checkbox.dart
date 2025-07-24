import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked; // Estado inicial del checkbox
  final ValueChanged<bool> onChanged; // Callback al cambiar el estado

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked; // Estado actual del checkbox

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked; // Inicializa con el estado recibido
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      setState(() {
        _isChecked = widget.isChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked; // Cambia el estado
        });
        widget.onChanged(_isChecked); // Llama al callback
      },
      child: Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color:
                  _isChecked ? Styles.iconColorBack : const Color(0xffBEBEBE),
            ),
            color: _isChecked
                ? Styles.iconColorBack
                : Colors.white, // Fondo según estado
            borderRadius: BorderRadius.circular(5), // Bordes redondeados
          ),
          child: _isChecked
              ? const Icon(
                  Icons.check,
                  color: Colors.white, // Palomita en blanco
                  size: 14,
                )
              : const Icon(
                  Icons.check,
                  color: Color(0xffBEBEBE), // Palomita en blanco
                  size: 14,
                ) // No mostrar nada si no está palomeado
          ),
    );
  }
}
