import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputSelect extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final Color? TextColor;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;
  final Color? color;
  final String? suffixIcon;
  final String? prefiIcon;
  final String? prefiIconSVG;
  final String? value;
  final bool isReadOnly;
  final Color? borderColor;
  final double fonsize;

  const InputSelect({
    super.key,
    this.label,
    this.placeholder,
    required this.onChanged,
    required this.items,
    this.suffixIcon,
    this.color,
    this.prefiIcon,
    this.prefiIconSVG,
    this.TextColor,
    this.value,
    this.isReadOnly = false,
    this.borderColor,
    this.fonsize = 14,
  });

  @override
  _InputSelectState createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  String? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;

    if (widget.value != null &&
        widget.items.any((item) => item.value == widget.value)) {
      _selectedValue = widget.value;
    } else {
      _selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry != null) {
          _removeOverlay();
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.label != null)
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF383838),
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (widget.label != null) const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                if (!widget.isReadOnly) {
                  if (_overlayEntry == null) {
                    _overlayEntry = _createOverlayEntry();
                    Overlay.of(context)?.insert(_overlayEntry!);
                  } else {
                    _removeOverlay();
                  }
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.color ?? Colors.white,
                  prefixIcon: widget.prefiIconSVG != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 15),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              widget.prefiIconSVG!,
                              colorFilter: widget.prefiIconSVG != null
                                  ? ColorFilter.mode(
                                      Colors.grey, BlendMode.srcIn)
                                  : null,
                            ),
                          ),
                        )
                      : widget.prefiIcon != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Image.asset(
                                widget.prefiIcon!,
                                width: 20,
                                height: 20,
                              ),
                            )
                          : null,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      widget.suffixIcon ?? 'assets/icons/svg/flecha_select.svg',
                      width: 1,
                      height: 5,
                    ),
                  ),
                  labelText: _selectedValue == null
                      ? widget.placeholder
                      : null, // Mostrar placeholder solo si no hay valor seleccionado
                  labelStyle: TextStyle(
                    color: widget.TextColor ?? Colors.black,
                    fontFamily: 'Lato',
                    fontSize: widget.fonsize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedValue != null
                          ? widget.items
                              .firstWhere(
                                  (item) => item.value == _selectedValue)
                              .child
                              .toString()
                              .replaceAll('Text("', '')
                              .replaceAll('")', '')
                          : '',
                      style: TextStyle(
                        color: widget.isReadOnly ? Colors.grey : Colors.black,
                        fontFamily: 'Lato',
                        fontSize: widget.fonsize,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
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
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  return Column(children: [
                    ListTile(
                      title: Text(
                          item.child
                              .toString()
                              .replaceAll('Text("', '')
                              .replaceAll('")', ''),
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF535251),
                          )),
                      selectedColor: Colors.black,
                      onTap: () {
                        setState(() {
                          _selectedValue = item.value;
                        });
                        widget.onChanged(item.value);
                        _removeOverlay();
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
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
