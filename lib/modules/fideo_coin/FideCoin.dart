import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/pages/header_notification.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_wdget.dart';
import 'package:pawlly/modules/integracion/controller/transaccion/transaction_controller.dart';

class FideCoin extends StatelessWidget {
  FideCoin({super.key});
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderNotification(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Aumentando márgenes laterales
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32), // Márgenes laterales más amplios
                      width: MediaQuery.of(context).size.width,
                      child: BarraBack(
                        callback: () {
                          Get.back();
                        },
                        titulo: 'Balance',
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    BalanceWidget(),
                    Container(
                      padding: Styles.paddingAll,
                      child: const Text(
                        'Mis Movimientos',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'PoetsenOne',
                          fontWeight: FontWeight.w400,
                          color: Styles.primaryColor,
                        ),
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
                  // Verificar si la lista de transacciones está vacía
                  if (controller.transactions.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No tienes movimientos aún.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF959595),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final transaction = controller.transactions[index];
                        return Center(
                          child: Movimientos(
                            amount: transaction.amount.toString(),
                            description: transaction.description,
                            date: transaction.createdAt.toString(),
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
  final String? date;
  Movimientos({
    super.key,
    this.description,
    this.amount,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8), // Márgenes laterales y verticales más amplios
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width - 48, // Ajustar al nuevo margen
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFFEFEFEFEF),
        ),
        borderRadius: BorderRadius.circular(16),
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
                  color: Styles.fiveColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SvgPicture.asset(
                  'assets/icons/svg/moneda.svg',
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description ?? "Movimiento",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fecha: $date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 78, 75, 75),
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            '$amount ƒ',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
