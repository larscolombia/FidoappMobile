import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/generated/assets.dart';
import 'package:pawlly/styles/styles.dart';
//import 'package:pawlly_employee/generated/assets.dart';

class ButtonBack extends StatelessWidget {
  final String text;

  const ButtonBack({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 65,
          child: SvgPicture.asset(
            Assets
                .flechita, // Asegúrate de que 'flechita' sea un archivo SVG en tu carpeta de assets
            height: 16,
            width: 16,
            color: Color(0xFF383838),
            
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const Icon(Icons
                .g_mobiledata_rounded), // Usamos un icono mientras se carga
          ),
        ),
        SizedBox(
          height: 65,
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.lato(
                color: const Color(0XFF383838),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*
TextStyle(
                  color: Color.fromRGBO(83, 82, 81, 1),
                  fontFamily: 'Lato',
                  fontSize: 16,),
*/