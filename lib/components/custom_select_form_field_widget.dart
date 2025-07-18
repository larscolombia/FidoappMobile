import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSelectFormFieldWidget extends StatefulWidget {
  final String placeholder;
  final String? icon; // Icono opcional
  final String? placeholderSvg;
  final Color? placeholderSvgColor;
  final TextEditingController? controller;
  final List<String>? items;
  final bool? enabled;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode;
  final void Function(String?)? onChange;
  final Color? filcolorCustom;
  final Color? textColor;
  final Color? borderColor;
  final String? label;

  const CustomSelectFormFieldWidget({
    super.key,
    required this.placeholder,
    this.icon,
    this.placeholderSvg,
    this.placeholderSvgColor,
    required this.controller,
    this.items,
    this.enabled,
    this.validators,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChange,
    this.filcolorCustom,
    this.textColor,
    this.borderColor,
    this.label,
  });

  @override
  _CustomSelectFormFieldWidgetState createState() => _CustomSelectFormFieldWidgetState();
}

class _CustomSelectFormFieldWidgetState extends State<CustomSelectFormFieldWidget> {
  String? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.controller?.text.isNotEmpty == true ? widget.controller?.text : null;

    if (widget.autovalidateMode == AutovalidateMode.always ||
        widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
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

    if (widget.autovalidateMode == AutovalidateMode.always ||
        (widget.autovalidateMode == AutovalidateMode.onUserInteraction && _selectedValue != null)) {
      errorText = _validate();
    }

    return GestureDetector(
      onTap: () {
        // Cerrar el menú si se hace clic fuera del selector
        if (_overlayEntry != null) {
          _removeOverlay();
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          children: [
            if (widget.label != null)
            Container(
              padding: const EdgeInsets.only(left: 5),
              width: double.infinity,
              child: Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF383838),
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
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
                      fillColor: widget.filcolorCustom ?? (hasText || _selectedValue != null ? Colors.white : const Color.fromRGBO(252, 186, 103, 1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      prefixIcon: widget.placeholderSvg != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 15),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                widget.placeholderSvg!,
                                colorFilter: widget.placeholderSvgColor != null
                                  ? ColorFilter.mode(widget.placeholderSvgColor!, BlendMode.srcIn)
                                  : null, // Si es null, se mantiene el color original del SVG
                              ),
                            ),
                          )
                        : widget.icon != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Image.asset(
                                widget.icon!,
                                width: 20,
                                height: 20,
                              ),
                            )
                          : null,
                      labelText: _selectedValue != null ? null : widget.placeholder,
                      labelStyle: TextStyle(
                        color: widget.textColor ?? Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      errorText: errorText,
                    ),
                    isEmpty: _selectedValue == null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            _selectedValue ?? '',
                            style: const TextStyle(
                              // color: isEnabled ? Colors.black : Colors.grey,
                              color: Color(0XFF383838),
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 20,
                            child: SvgPicture.asset(
                              'assets/icons/svg/vector_flecha.svg',
                            ),
                          ),
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
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    // Para listados de más de 5 elementos se incrementa el tamaño
    // para lograr un efecto que muestra que existen más elementos
    final itemHeight = widget.items!.length <= 5 ? 56.0 : 59.0;
    final maxItems = widget.items!.length > 5 ? 5 : widget.items!.length;
    final maxHeight = maxItems * itemHeight;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _removeOverlay(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Menú desplegable
          Positioned(
            left: offset.dx,
            width: size.width,
            top: offset.dy + size.height,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items!.map((item) {
                      /// `itemHeight` es una constante que es igual
                      /// a la altura de esta columna.
                      return Column(children: [
                        ListTile(
                          title: Text(item,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF535251),
                              )),
                          selectedColor: Colors.black,
                          onTap: () {
                            setState(() {
                              _selectedValue = item;
                              widget.controller?.text = item;
                              _removeOverlay();
                            });

                            if (widget.onChange != null) {
                              widget.onChange!(_selectedValue);
                            }
                          },
                        ),
                        const Divider(
                          height: 0.2,
                          color: Color(0xFFFCBA67),
                        )
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
