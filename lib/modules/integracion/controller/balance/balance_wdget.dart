import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      padding: EdgeInsets.all(screenWidth * 0.04), // 4% del ancho como padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Balance(controller: controller),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Get.off(RecargarSaldoScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.colorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: screenHeight * 0.2, // 20% del alto de la pantalla
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(RecargarSaldoScreen());
                      },
                      child: Text(
                        'Recargar FidoCoins',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035, // 3.5% del ancho
                          fontFamily: 'Leto',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // 1% del alto
                    Icon(
                      Icons.add_circle,
                      color: Colors.green,
                      size: screenWidth * 0.08, // 8% del ancho
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        padding: EdgeInsets.all(screenWidth * 0.04), // 4% del ancho
        height: screenHeight * 0.2, // 20% del alto de la pantalla
        decoration: BoxDecoration(
          color: Styles.colorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FidoCoins Disponibles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.03, // 3% del ancho
                fontFamily: 'Leto',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // 1% del alto
            Text(
              '${controller.userBalance.value.balance}ƒ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.05, // 5% del ancho
                fontWeight: FontWeight.bold,
                color: Styles.primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% del alto
            if (recarga)
              RecargaComponente(
                callback: () {
                  controller.fetchUserBalance();
                },
                titulo: 'Actualizar Saldo',
              ),
          ],
        ),
      );
    });
  }
}
