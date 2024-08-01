import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';

class CustomSelectFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String icon;
  final TextEditingController? controller;
  final List<String>? items;
  final bool? enabled; // Permite habilitar o deshabilitar el widget

  CustomSelectFormFieldWidget({
    Key? key,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.items,
    this.enabled,
  }) : super(key: key);

  @override
  _CustomSelectFormFieldWidgetState createState() =>
      _CustomSelectFormFieldWidgetState();
}

class _CustomSelectFormFieldWidgetState
    extends State<CustomSelectFormFieldWidget> {
  String? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    // Sincroniza _selectedValue con el valor del controlador al inicializar
    _selectedValue = widget.controller?.text.isNotEmpty == true
        ? widget.controller?.text
        : null;
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = widget.enabled ?? true;
    bool hasText = widget.controller?.text.isNotEmpty ?? false;
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (isEnabled) {
            if (_overlayEntry == null) {
              _overlayEntry = _createOverlayEntry();
              Overlay.of(context).insert(_overlayEntry!);
            } else {
              _removeOverlay();
            }
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: hasText || _selectedValue != null
                ? Colors.white
                : Color.fromRGBO(254, 247, 229, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: hasText || _selectedValue != null
                    ? Styles.iconColorBack
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: isEnabled
                    ? (hasText || _selectedValue != null)
                        ? Styles.iconColorBack
                        : Colors.transparent
                    : Colors.grey,
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
                color: Colors.grey,
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
            labelText: _selectedValue != null ? null : widget.placeholder,
            labelStyle: TextStyle(
              color: isEnabled ? Styles.iconColorBack : Colors.grey,
            ),
          ),
          isEmpty: _selectedValue == null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedValue ?? '',
                style: TextStyle(
                  color: isEnabled ? Colors.black : Colors.grey,
                ),
              ),
              Icon(Icons.arrow_drop_down,
                  color: isEnabled ? Styles.iconColorBack : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Crea el OverlayEntry para mostrar las opciones
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        width: size.width,
        top: offset.dy + size.height,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Styles.iconColorBack),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.items!.map((item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Styles.iconColorBack, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        _selectedValue = item;
                        widget.controller?.text = item;
                        _removeOverlay();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Remueve el OverlayEntry cuando se selecciona un valor
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
