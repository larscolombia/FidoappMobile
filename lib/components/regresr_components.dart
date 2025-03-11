import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pawlly/modules/components/style.dart';

class BarraBack extends StatefulWidget {
  const BarraBack({
    super.key,
    required this.titulo,
    this.callback,
    this.color = Styles.primaryColor,
    this.subtitle,
    this.ColorSubtitle,
    this.size = 20.00,
    this.fontFamily,
  });

  final String titulo;
  final Color color;
  final String? subtitle;
  final Color? ColorSubtitle;
  final double size;
  final String? fontFamily;
  final void Function()? callback;

  @override
  State<BarraBack> createState() => _BarraBackState();
}

class _BarraBackState extends State<BarraBack> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Make the entire area tappable
      onTap: () {
        if (widget.titulo.length > 20) {
          // Example condition to enable expansion for longer titles
          setState(() {
            _isExpanded = !_isExpanded;
          });
        }
        if (widget.callback != null) {
          widget.callback!();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 45, // Increased width for touch area
            height: 45, // Increased height for touch area
            child: Padding(
              padding: const EdgeInsets.all(
                  10.0), // Padding to center the icon visually
              child: SvgPicture.asset(
                'assets/icons/svg/arrow_back.svg',
                width: 15,
                height: 15,
                colorFilter:
                    ColorFilter.mode(Styles.fiveColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Text(
                      widget.titulo,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      maxLines:
                          _isExpanded ? null : 2, // No maxLines when expanded
                      softWrap: true, // Allow text wrapping when expanded
                      style: TextStyle(
                        fontSize: widget.size,
                        fontWeight: FontWeight.w400,
                        fontFamily: widget.fontFamily ?? 'PoetsenOne',
                        color: widget.color,
                      ),
                    );
                  },
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: widget.fontFamily ?? 'Lato',
                      color: widget.ColorSubtitle ?? Styles.fiveColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
