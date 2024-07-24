import 'package:flutter/material.dart';
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
        Container(
          height: 65,
          child: Image.asset(
            Assets.flechita,
            height: 20,
            width: 16,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.g_mobiledata_rounded),
          ),
        ),
        Container(
          height: 65,
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.lato(
                color: Styles.greyTextColor,
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