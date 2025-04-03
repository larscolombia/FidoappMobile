import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/fideo_coin/navegador.dart';
import 'dart:convert';

import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeController extends GetxController {
  RxBool isLoading = false.obs;
  var url_pago_stripe = "".obs;

  var url = "${BASE_URL}checkout";

  // ignore: non_constant_identifier_names
  Future<void> GetUrlPayment(String amount, context) async {
    isLoading.value = true;
    print({
      "quantity": amount.split(',')[0],
      "user_id": "${AuthServiceApis.dataCurrentUser.id}"
    });
    try {
      var response = await http.post(
        Uri.parse('${BASE_URL}checkout'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
        body: {
          "quantity": amount.split(',')[0],
          "user_id": "${AuthServiceApis.dataCurrentUser.id}"
        },
      );
      print('response ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        url_pago_stripe.value = data['url'];
        Get.off(() => FideCoin());
        print('contexto ${url_pago_stripe.toString()}');
        abrirNavegador(context, url_pago_stripe.toString());
        //openStripeCheckout(url_pago_stripe.toString());
      } else {
        // ignore: avoid_print
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('stripe url:4 $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openStripeCheckout(String url) async {
    final Uri uri = Uri.parse(url); // Convierte la URL en un objeto Uri

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Abre en el navegador externo
    )) {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  Future<void> showModalCompra(String precio) async {
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.check_circle_outline,
        title: 'Confirmación',
        description: 'Estás a punto de adquirir $precio. ¿Deseas continuar?',
        primaryButtonText: 'Continuar',
        onPrimaryButtonPressed: () async {
          // 1. Cierra el modal
          Get.back();

          // 2. Muestra una pantalla de carga
          Get.dialog(
            Center(
              child: CircularProgressIndicator(),
            ),
            barrierDismissible: false, // Evitar que se cierre al tocar fuera
          );

          // 3. Simula el proceso de abrir el navegador (espera 2 segundos)
          await Future.delayed(Duration(seconds: 2));

          // 4. Redirige a la ruta de balance
          Get.off(() =>
              HomeScreen()); // Cambia '/balance' por la ruta que necesites

          // 5. (Opcional) Aquí puedes abrir el navegador con tu lógica
          // Por ejemplo, usando url_launcher
          // await launchUrl(Uri.parse('https://tu-navegador.com'));
        },
      ),
      barrierDismissible: true,
    );
  }

  void abrirNavegador(BuildContext context, String url) {
    print('contexto modal $context');
    if (!context.mounted) return; // Previene contextos no válidos
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InAppBrowserModal(url: url);
      },
    );
  }
}
