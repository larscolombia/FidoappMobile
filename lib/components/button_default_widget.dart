import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/styles/styles.dart';

class ButtonDefaultWidget extends StatelessWidget {
  final String title;
  final VoidCallback? callback;
  final Color defaultColor;
  final WidgetStateProperty<Color>? color;
  final Color textColor;
  final BorderSide? border;
  final double heigthButtom;
  final double? widthButtom;
  final double? textSize;
  final double? borderSize;
  final IconData? icon;
  final bool iconAfterText;
  final bool isLoading;

  const ButtonDefaultWidget({
    super.key,
    this.widthButtom,
    this.heigthButtom = 54,
    required this.title,
    this.callback,
    this.defaultColor = const Color(0xffFF4931),
    this.color,
    this.textColor = Styles.whiteColor,
    this.border,
    this.textSize,
    this.borderSize,
    this.icon,
    this.iconAfterText = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? WidgetStateProperty.all(defaultColor);
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xffFF4931)
                .withOpacity(0.1), // Sombra del color predeterminado
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: SizedBox(
        width: widthButtom ?? width,
        height: heigthButtom,
        child: TextButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(1),
            backgroundColor: resolvedColor,
            side: border != null
                ? WidgetStateProperty.all(border)
                : WidgetStateProperty.all(
                    BorderSide.none,
                  ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderSize ?? 16),
              ),
            ),
          ),
          onPressed: isLoading ? null : callback,
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                )
              : icon == null
                  ? Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: textSize ?? 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: iconAfterText
                          ? [
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: textSize ?? 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                icon,
                                color: textColor,
                              ),
                            ]
                          : [
                              Icon(
                                icon,
                                color: textColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: textSize ?? 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                    ),
        ),
      ),
    );
  }
}
