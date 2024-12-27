import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'dart:convert';

import 'package:pawlly/configs.dart';
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
        openStripeCheckout(url_pago_stripe.toString());
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
      //pisa papel
      CustomAlertDialog(
        icon: Icons.check_circle_outline,
        title: 'Confirmación',
        description: 'Estas apunto de comprar $precio ',
        primaryButtonText: 'Continuar',
        onPrimaryButtonPressed: () {
          //Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }
}
