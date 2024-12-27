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
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Balance(
              controller:
                  controller), // Asumo que Balance está definido en otro lugar
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.off(RecargarSaldoScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Styles
                      .colorContainer, // Cambia esto a Styles.colorContainer
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 150,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(RecargarSaldoScreen());
                      },
                      child: const Text('Recargar FidoCoins',
                          style: Styles.textDescription),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Icon(
                      Icons.add_circle,
                      color: Colors.green, // Cambia esto a Styles.primaryColor
                      size: 30,
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
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          decoration: const BoxDecoration(
            color: Styles.colorContainer,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  child: Text(
                    'FidoCoins Disponible ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '${controller.userBalance.value.balance}ƒ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Styles.primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (recarga)
                  SizedBox(
                    child: RecargaComponente(
                      callback: () {
                        controller.fetchUserBalance();
                      },
                      titulo: 'Actulizar Saldo',
                    ),
                  )
              ]),
        );
      }),
    );
  }
}
