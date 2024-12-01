import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/style.dart';

class BarraBack extends StatelessWidget {
  const BarraBack({
    super.key,
    required this.titulo,
    this.callback,
  });

  final String titulo;
  final void Function()? callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: callback,
            child: Container(
              width: 30,
              height: 30,
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Styles.fiveColor,
                  size: 20,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              color: Styles.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
