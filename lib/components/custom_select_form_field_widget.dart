import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';

class CustomSelectFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String icon;
  final TextEditingController? controller;
  final List<String>? items;
  final bool? enabled;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode; // Nueva propiedad

  CustomSelectFormFieldWidget({
    Key? key,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.items,
    this.enabled,
    this.validators,
    this.autovalidateMode =
        AutovalidateMode.disabled, // Inicializar nueva propiedad
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
    _selectedValue = widget.controller?.text.isNotEmpty == true
        ? widget.controller?.text
        : null;

    // Si autovalidateMode es always o onUserInteraction, validamos inmediatamente al iniciar
    if (widget.autovalidateMode == AutovalidateMode.always ||
        widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {}); // Dispara la validación inicial
      });
    }
  }

  String? _validate() {
    if (widget.validators != null) {
      for (var validator in widget.validators!) {
        final validationResult = validator(_selectedValue);
        if (validationResult != null) {
          return validationResult;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = widget.enabled ?? true;
    bool hasText = widget.controller?.text.isNotEmpty ?? false;
    String? errorText;

    // Si autovalidateMode es always o onUserInteraction, obtenemos el error
    if (widget.autovalidateMode == AutovalidateMode.always ||
        (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
            _selectedValue != null)) {
      errorText = _validate();
    }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: hasText || _selectedValue != null
                    ? Colors.white
                    : Color.fromRGBO(254, 247, 229, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: hasText || _selectedValue != null
                        ? Styles.iconColorBack
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Styles.iconColorBack,
                    width: 1.0,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
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
                errorText: errorText, // Mostrar mensaje de error si existe
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
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Styles.iconColorBack),
              borderRadius: BorderRadius.circular(16),
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

                      // Revalida cuando el usuario selecciona un valor si el modo es onUserInteraction
                      if (widget.autovalidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        setState(() {});
                      }
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

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
