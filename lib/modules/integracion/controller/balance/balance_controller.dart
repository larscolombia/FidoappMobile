import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/configs.dart'; // Asegúrate de que este archivo exista y contenga la constante BASE_URL
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_wdget.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/model/balance/balance_model.dart';
import 'package:pawlly/services/auth_service_apis.dart'; // Asegúrate de que este archivo y clase existan

class UserBalanceController extends GetxController {
  final ProductoPayController productController =
      Get.put(ProductoPayController());
  final userBalance = UserBalance(
    id: 0,
    userId: 0,
    balance: '0.00',
    createdAt: '',
    updatedAt: '',
  ).obs;

  var shopin = {
    "precio": "",
    "nombre_producto": "nombre del producto",
    "imagen": "",
    "descripcion": "descripcion del producto",
    "slug": "libro",
  }.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserBalance();
  }

  Future<void> fetchUserBalance() async {
    isLoading.value = true;
    try {
      // Construir la URL
      final apiUrl = Uri.parse(BASE_URL).replace(
        path: 'api/wallet',
        queryParameters: {
          'user_id': AuthServiceApis.dataCurrentUser.id.toString()
        },
      );

      // Realizar la petición HTTP GET
      final response = await http.get(apiUrl, headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final data = json.decode(response.body);

        if (data['success']) {
          // Actualizar el estado del balance
          userBalance.value = UserBalance.fromJson(data['data']);
        } else {
          throw Exception('Error en los datos del servidor');
        }
      } else {
        throw Exception('Error en la conexión al servidor');
      }
    } catch (e) {
      // Manejo de errores
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showPurchaseModal(context) {
    final controller = Get.put(UserBalanceController());
    final miscursos = Get.put(CursoUsuarioController());
    final calendarController = Get.put(CalendarController());
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Styles.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Realizar compra ${productController.selectedProduct.value.slug}',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Ajusta el radio del borde según tus necesidades
                  child: Image.network(
                    productController.selectedProduct.value.imagen,
                    fit: BoxFit.cover,
                    width: double
                        .infinity, // Puedes ajustar el ancho según tus necesidades
                    height:
                        200, // Puedes ajustar la altura según tus necesidades
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                '${productController.selectedProduct.value.descripcion}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Balance(controller: controller, recarga: false),
                  const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.party_mode,
                      color: Styles.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Styles.colorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${productController.selectedProduct.value.nombreProducto}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: Text(
                              '${productController.selectedProduct.value.precio}ƒ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            ButtonDefaultWidget(
              callback: () {
                if (productController.selectedProduct.value.precio.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'El precio es requerido',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else if (double.parse(controller.userBalance.value.balance) <
                    double.parse(
                        productController.selectedProduct.value.precio)) {
                  Get.dialog(
                    CustomAlertDialog(
                      icon: Icons.close,
                      title: 'Error',
                      description: 'Fondos insuficientes',
                      primaryButtonText: 'Aceptar',
                      onPrimaryButtonPressed: () {
                        Get.back();
                      },
                    ),
                    barrierDismissible:
                        false, // No permite cerrar el diálogo tocando fuera
                  );
                } else {
                  Get.dialog(
                    CustomAlertDialog(
                      icon: Icons.check_circle_outline,
                      title: 'Éxito',
                      description: 'confirmar transacción',
                      primaryButtonText: 'Aceptar',
                      onPrimaryButtonPressed: () {
                        switch (productController.selectedProduct.value.slug) {
                          case 'curso':
                            miscursos.subscribeToCourse(
                                productController.selectedProduct.value.id);
                            break;
                          case 'servicio':
                            print(
                                'servicio medicos ${calendarController.event}');
                            calendarController.postEvent();
                            break;
                          default:
                            print('default');
                        }
                        Get.back();
                      },
                    ),
                    barrierDismissible:
                        false, // No permite cerrar el diálogo tocando fuera
                  );
                }
              },
              title: 'Comprar ${productController.selectedProduct.value.slug}',
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      isScrollControlled: true, // Permite que el modal sea más grande
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent, // Para usar el color del Container
    );
  }
}
