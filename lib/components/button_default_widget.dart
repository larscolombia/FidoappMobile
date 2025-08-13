import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:pawlly/components/safe_text_button.dart';

class ButtonDefaultWidget extends StatelessWidget {
  final String title;
  final VoidCallback? callback;
  final Future<void> Function()? callbackAsync; // Optional async handler to block until finished
  final Color defaultColor;
  final WidgetStateProperty<Color>? color;
  final Color textColor;
  final BorderSide? border;
  final double heigthButtom;
  final double? widthButtom;
  final double? textSize;
  final double? borderSize;
  final IconData? icon;
  final String? svgIconPath;
  final double? svgIconPathSize;
  final Color? svgIconColor;
  final bool iconAfterText;
  final bool isLoading;
  final List<BoxShadow>? boxShadow;
  final bool showDecoration;
  final bool disabled;

  const ButtonDefaultWidget({
    super.key,
    this.widthButtom,
    this.heigthButtom = 54,
    required this.title,
    this.callback,
  this.callbackAsync,
    this.defaultColor = const Color(0xffFF4931),
    this.color,
    this.textColor = Styles.whiteColor,
    this.border,
    this.textSize,
    this.borderSize,
    this.icon,
    this.svgIconPath,
    this.svgIconPathSize,
    this.svgIconColor,
    this.iconAfterText = true,
    this.isLoading = false,
    this.boxShadow,
    this.showDecoration = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? WidgetStateProperty.all(defaultColor);
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      decoration: showDecoration
          ? BoxDecoration(
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: const Color(0xffFF4931).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
            )
          : null,
      child: SizedBox(
        width: widthButtom ?? width,
        height: heigthButtom,
        child: SafeTextButton(
          onPressed: (callbackAsync == null && !isLoading && !disabled) ? callback : null,
          onPressedAsync: (!isLoading && !disabled) ? callbackAsync : null,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(1),
            backgroundColor: resolvedColor,
            side: border != null
                ? WidgetStateProperty.all(border)
                : WidgetStateProperty.all(BorderSide.none),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderSize ?? 16),
              ),
            ),
          ),
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                )
              : Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!iconAfterText &&
                          (svgIconPath != null || icon != null)) ...[
                        if (svgIconPath != null)
                          SvgPicture.asset(
                            svgIconPath!,
                            color: textColor,
                            width: svgIconPathSize ?? 24,
                            height: svgIconPathSize ?? 24,
                          )
                        else if (icon != null)
                          Icon(
                            icon,
                            color: textColor,
                          ),
                        const SizedBox(width: 8),
                      ],
                      (svgIconPath == null && icon == null)
                          ? Text(
                              title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: textSize ?? 16,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                                height: 1.2,
                                letterSpacing: 0.5,
                              ),
                            )
                          : Expanded(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: textSize ?? 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                      if (iconAfterText &&
                          (svgIconPath != null || icon != null)) ...[
                        const SizedBox(width: 8),
                        if (svgIconPath != null)
                          SvgPicture.asset(
                            svgIconPath!,
                            color: svgIconColor ?? Styles.iconColorBack,
                            width: svgIconPathSize ?? 24,
                            height: svgIconPathSize ?? 24,
                          )
                        else if (icon != null)
                          Icon(
                            icon,
                            color: textColor,
                          ),
                      ],
                    ],
                  ),
                ),
  ),
      ),
    );
  }
}
