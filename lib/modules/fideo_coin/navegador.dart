import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_controller.dart';
import 'package:pawlly/modules/integracion/controller/transaccion/transaction_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowserModal extends StatefulWidget {
  // Cambiado a StatefulWidget
  final String url;

  const InAppBrowserModal({Key? key, required this.url}) : super(key: key);

  @override
  State<InAppBrowserModal> createState() => _InAppBrowserModalState();
}

class _InAppBrowserModalState extends State<InAppBrowserModal> {
  late final WebViewController controller; // Declarado como late final

  @override
  void initState() {
    super.initState();
    controller = WebViewController() // Inicializado en initState
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url)); // Usando widget.url
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height:
                MediaQuery.sizeOf(context).height * 0.8, // 80% de la pantalla
            child: Stack(
              children: [
                // WebView principal
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                    child: WebViewWidget(
                      controller: controller), // Usando el controller inicializado
                  ),
                // Botón X en la esquina superior derecha
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      // Actualizar balance y transacciones antes de cerrar
                      final balanceController = Get.put(UserBalanceController());
                      final transactionController = Get.put(TransactionController());
                      await balanceController.fetchUserBalance();
                      await transactionController.fetchTransactions();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
