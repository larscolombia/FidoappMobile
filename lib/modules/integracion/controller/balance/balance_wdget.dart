import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/fideo_coin/Recarga.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';

import '../../../components/style.dart';

class BalanceWidget extends StatelessWidget {
  final UserBalanceController controller = Get.put(UserBalanceController());
  BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Balance(controller: controller),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class Balance extends StatelessWidget {
  final bool recarga;
  const Balance({
    super.key,
    required this.controller,
    this.recarga = true,
  });

  final UserBalanceController controller;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Container(
        padding:
            EdgeInsets.symmetric(vertical: 10, horizontal: 15), // 4% del ancho
        height: screenHeight * 0.23, // 20% del alto de la pantalla
        decoration: BoxDecoration(
          color: Styles.colorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                'FidoCoins Disponibles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // 3% del ancho
                  fontFamily: 'Leto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // 1% del alto
            Text(
              '\$ ${controller.userBalance.value.balance}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24, // 5% del ancho
                fontWeight: FontWeight.w800,
                color: Styles.primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% del alto
            if (recarga)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 140,
                    height: 46,
                    child: ButtonDefaultWidget(
                      textSize: 12,
                      callback: () {
                        controller.fetchUserBalance();
                      },
                      title: 'Actualizar Saldo',
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 46,
                    child: ButtonDefaultWidget(
                      textSize: 12,
                      defaultColor: Color(0xff37AE4D),
                      callback: () {
                        Get.off(RecargarSaldoScreen());
                      },
                      title: 'Recargar Saldo',
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
