import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SelecInputText extends StatefulWidget {
  final String placeholder;
  final String icon;
  final TextEditingController? controller;
  final List<String>? items; // Lista de opciones para el dropdown
  final bool isDropdown; // Indicador para comportamiento como dropdown

  SelecInputText({
    Key? key,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.items,
    this.isDropdown = false,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<SelecInputText> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          readOnly: widget
              .isDropdown, // Hacer que el campo sea de solo lectura si es dropdown
          decoration: InputDecoration(
            filled: true,
            border: InputBorder.none,
            fillColor: Color.fromRGBO(254, 247, 229, 1),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(0),
              child: Image.asset(
                widget.icon,
                width: 17,
                height: 17,
              ),
            ),
            suffixIcon: widget.isDropdown
                ? Icon(Icons.arrow_drop_down) // Agregar la flecha hacia abajo
                : null,
            labelText: widget.placeholder,
            labelStyle: TextStyle(
              color: Color.fromRGBO(136, 136, 136, 1),
            ),
          ),
        ),
        if (widget.isDropdown)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null, // No mostrar valor seleccionado
                  icon: Container(), // Quitar el icono por defecto
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                      widget.controller?.text = newValue ?? '';
                    });
                  },
                  items: _buildDropdownMenuItems(widget.items),
                  dropdownColor: Color.fromRGBO(
                      255, 255, 254, 1), // Color de fondo del dropdown
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String>? items) {
    if (items == null) return [];
    List<DropdownMenuItem<String>> menuItems = [];
    for (int i = 0; i < items.length; i++) {
      menuItems.add(
        DropdownMenuItem<String>(
            value: items[i],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 280,
                      margin: EdgeInsets.only(left: 10),
                      child: Text(items[i]),
                    ),
                  ),
                  if (i < items.length - 1)
                    Divider(
                      thickness: 1,
                      color: Color.fromRGBO(252, 146, 20, 1),
                    ),
                ],
              ),
            )),
      );
    }
    return menuItems;
  }
}
