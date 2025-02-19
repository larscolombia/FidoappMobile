import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSelectFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String? icon; // Ahora icon es opcional (puede ser null)
  final String? placeholderSvg;
  final TextEditingController? controller;
  final List<String>? items;
  final bool? enabled;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode; // Nueva propiedad
  final void Function(String?)? onChange; // Parámetro opcional
  final Color? filcolorCustom;
  final Color? textColor;
  final Color? borderColor; // Nueva propiedad para el color del borde
  final String? label;

  const CustomSelectFormFieldWidget({
    super.key,
    required this.placeholder,
    this.icon, // Hacer el icono opcional
    this.placeholderSvg,
    required this.controller,
    this.items,
    this.enabled,
    this.validators,
    this.autovalidateMode =
        AutovalidateMode.disabled, // Inicializar nueva propiedad
    this.onChange, // Inicializar el parámetro opcional
    this.filcolorCustom,
    this.textColor,
    this.borderColor, // Inicialización de borderColor
    this.label,
  });

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
    if (_selectedValue == null || _selectedValue!.isEmpty) {
      return 'Este campo es requerido';
    }

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
      child: Column(
        children: [
          if (widget.label != null)
            Container(
              padding: const EdgeInsets.only(left: 5),
              width: double.infinity,
              child: const Text(
                'Categoria del evento',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          if (widget.label != null) const SizedBox(height: 8),
          GestureDetector(
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
                        : widget.filcolorCustom ??
                            const Color.fromRGBO(252, 186, 103, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: widget.borderColor ??
                            (hasText || _selectedValue != null
                                ? Styles.iconColorBack
                                : Colors.transparent),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Styles.iconColorBack,
                        width: .5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: widget.borderColor ?? Styles.iconColorBack,
                        width: 1.0,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    // Condicionar el prefixIcon si el icon es proporcionado
                    prefixIcon: widget.placeholderSvg != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 5,
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(widget.placeholderSvg!),
                            ),
                          )
                        : widget.icon != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Image.asset(
                                  widget.icon!,
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            : null, // Si no se pasa icono, no mostramos nada
                    labelText:
                        _selectedValue != null ? null : widget.placeholder,

                    labelStyle: TextStyle(
                      color: widget.textColor ?? Colors.black,
                      fontFamily:
                          'Lato', // Forzamos la fuente Lato para el placeholder
                      fontSize: 14,
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
                          fontFamily:
                              'Lato', // Forzamos la fuente Lato para el texto ingresado
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                            width: 20,
                            child:
                                Image.asset('assets/icons/flecha_select.png')),
                      ),
                    ],
                  ),
                ),
                if (errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      errorText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 170, // Limitar la altura máxima a 200px
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: widget.borderColor ?? Styles.iconColorBack),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: false,
                  children: widget.items!.map((item) {
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Styles.iconColorBack,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: ListTile(
                        focusColor: Colors.white,
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontFamily: 'Lato', // Utiliza Lato para los items
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedValue = item;
                            widget.controller?.text = item;
                            _removeOverlay();
                          });

                          if (widget.autovalidateMode ==
                              AutovalidateMode.onUserInteraction) {
                            setState(() {});
                          }

                          // Llamar a onChange si no es null
                          if (widget.onChange != null) {
                            widget.onChange!(_selectedValue);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
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
