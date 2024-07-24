import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/styles/styles.dart';

class SelecInputText extends StatefulWidget {
  final String placeholder;
  final String icon;
  final TextEditingController? controller;
  final List<String>? items;
  final bool isDropdown;
  final bool? enabled;

  SelecInputText({
    Key? key,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.items,
    this.enabled,
    this.isDropdown = false,
  }) : super(key: key);

  @override
  _SelecInputTextState createState() => _SelecInputTextState();
}

class _SelecInputTextState extends State<SelecInputText> {
  final FocusNode _focusNode = FocusNode();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selected value from the controller if present
    if (widget.controller != null) {
      _selectedValue = widget.controller!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: Stack(
        children: [
          TextFormField(
            enabled: widget.enabled ?? true,
            controller: widget.controller,
            readOnly: widget.isDropdown,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.controller?.text.isNotEmpty ?? false
                  ? Colors.white
                  : Color.fromRGBO(254, 247, 229, 1),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.controller?.text.isNotEmpty ??
                          false || _focusNode.hasFocus
                      ? Styles.iconColorBack
                      : Colors.transparent,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.controller?.text.isNotEmpty ??
                          false || _focusNode.hasFocus
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
                  widget.icon,
                  width: 20,
                  height: 20,
                ),
              ),
              labelText: widget.controller?.text.isNotEmpty ??
                      false || _focusNode.hasFocus
                  ? null
                  : widget.placeholder,
              labelStyle: TextStyle(
                color: Color.fromRGBO(136, 136, 136, 1),
              ),
            ),
          ),
          if (widget.isDropdown &&
              (widget.enabled == null || widget.enabled == true))
            Positioned.fill(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedValue,
                  icon: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedValue = newValue;
                      if (widget.controller != null) {
                        widget.controller!.text = newValue ?? '';
                      }
                    });
                  },
                  items: _buildDropdownMenuItems(widget.items),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String>? items) {
    if (items == null) return [];
    return items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: 8),
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(item),
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(252, 146, 20, 1),
            ),
          ],
        ),
      );
    }).toList();
  }
}
