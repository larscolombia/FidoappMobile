import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectItem {
  final String label;
  final String value;
  SelectItem({required this.label, required this.value});
}

class CustomSelectWidget extends StatefulWidget {
  final String placeholder;
  final String? icon;
  final String? placeholderSvg;
  final Color? placeholderSvgColor;
  final TextEditingController? controller;
  final List<SelectItem>? items;
  final bool? enabled;
  final List<String? Function(String?)>? validators;
  final AutovalidateMode autovalidateMode;
  final void Function(String?)? onChange;
  final Color? filcolorCustom;
  final Color? textColor;
  final Color? borderColor;
  final String? label;

  const CustomSelectWidget({
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
  _CustomSelectWidgetState createState() => _CustomSelectWidgetState();
}

class _CustomSelectWidgetState extends State<CustomSelectWidget> {
  String? _selectedLabel;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    final initialValue = widget.controller?.text;
    if (initialValue != null && initialValue.isNotEmpty) {
      final match = widget.items?.firstWhere(
        (i) => i.value == initialValue,
        orElse: () => SelectItem(label: '', value: ''),
      );
      if (match != null && match.label.isNotEmpty) {
        _selectedLabel = match.label;
      }
    }
    if (widget.autovalidateMode == AutovalidateMode.always || widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  String? _validate() {
    final id = widget.controller?.text;
    if (id == null || id.isEmpty) return 'Este campo es requerido';
    if (widget.validators != null) {
      for (var validator in widget.validators!) {
        final result = validator(id);
        if (result != null) return result;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled ?? true;
    final hasText = _selectedLabel != null && _selectedLabel!.isNotEmpty;
    String? errorText;
    if (widget.autovalidateMode == AutovalidateMode.always || (widget.autovalidateMode == AutovalidateMode.onUserInteraction && hasText)) {
      errorText = _validate();
    }

    return GestureDetector(
      onTap: () => _removeOverlay(),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF383838),
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: () {
                if (!isEnabled) return;
                if (_overlayEntry == null) {
                  _overlayEntry = _createOverlayEntry();
                  Overlay.of(context)?.insert(_overlayEntry!);
                } else {
                  _removeOverlay();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.filcolorCustom ?? const Color(0xFFFFF6E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFFC9214),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFFC9214),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFFC9214),
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: widget.placeholderSvg != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 5),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              widget.placeholderSvg!,
                              colorFilter: widget.placeholderSvgColor != null ? ColorFilter.mode(widget.placeholderSvgColor!, BlendMode.srcIn) : null,
                            ),
                          ),
                        )
                      : widget.icon != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20, right: 5),
                              child: Image.asset(
                                widget.icon!,
                                width: 20,
                                height: 20,
                              ),
                            )
                          : null,
                  labelText: hasText ? null : widget.placeholder,
                  labelStyle: TextStyle(
                    color: widget.textColor ?? Colors.black,
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  errorText: errorText,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                ),
                isEmpty: !hasText,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLabel ?? '',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF383838),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 20,
                          child: SvgPicture.asset('assets/icons/svg/vector_flecha.svg'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (errorText != null) const SizedBox(height: 8),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12),
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
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (ctx) => Positioned(
        left: offset.dx,
        width: size.width,
        top: offset.dy + size.height + 5,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFFC9214)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.items?.length ?? 0,
                  itemBuilder: (_, i) {
                    final option = widget.items![i];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(option.label,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF535251),
                              )),
                          onTap: () {
                            setState(() {
                              _selectedLabel = option.label;
                              widget.controller?.text = option.value;
                              _removeOverlay();
                            });
                            widget.onChange?.call(option.value);
                          },
                        ),
                        const Divider(
                          height: 0.2,
                          color: Color(0xFFFCBA67),
                        ),
                      ],
                    );
                  },
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
