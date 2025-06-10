import 'package:flutter/material.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            HeaderNotification(),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
