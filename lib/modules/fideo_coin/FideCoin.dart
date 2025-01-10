import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_wdget.dart';
import 'package:pawlly/modules/integracion/controller/transaccion/transaction_controller.dart';

import '../components/border_redondiado.dart';

class FideCoin extends StatelessWidget {
  FideCoin({super.key});
  final TransactionController controller = Get.put(TransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color:
                  Styles.colorContainer, // Cambia esto a Styles.colorContainer
            ),
            child: Stack(
              children: [
                // Asumo que HeaderNotification y BorderRedondiado están definidos en otros lugares
                HeaderNotification(),
                const BorderRedondiado(
                  top: 150,
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      width: MediaQuery.of(context).size.width - 100,
                      child: BarraBack(
                        callback: () {
                          Get.back();
                        },
                        titulo: 'Balance',
                      ),
                    ),
                    BalanceWidget(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Mis Movimientos',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Styles
                                .primaryColor), // Cambia esto a Styles.textDescription
                      ),
                    ),
                  ]),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final transaction = controller.transactions[index];
                        // Crea una lista de movimientos
                        print('transacciones ${controller.transactions}');
                        return Center(
                          child: Movimientos(
                            amount: transaction.amount.toString(),
                            description: transaction.description,
                          ),
                        );
                      },
                      childCount: controller.transactions.length,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Movimientos extends StatelessWidget {
  final String? description;
  final String? amount;
  Movimientos({
    super.key,
    this.description,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 70,
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 1,
          )
        ],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Styles.primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                    child: Text(
                  'ƒ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  description ?? "Movimiento",
                  style: Styles.textDescription,
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              '$amountƒ',
              style: Styles.textDescription,
            ),
          ),
        ],
      ),
    );
  }
}
