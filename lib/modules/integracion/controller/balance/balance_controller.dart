import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart'; // Asegúrate de que este archivo exista y contenga la constante BASE_URL
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/integracion/controller/balance/balance_wdget.dart';
import 'package:pawlly/modules/integracion/controller/balance/producto_pay_controller.dart';
import 'package:pawlly/modules/integracion/controller/calendar_controller/calendar_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/model/balance/balance_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

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
      print('data balance ${json.decode(response.body)}');
      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final data = json.decode(response.body);
        print('data balance $data');
        if (data['success']) {
          userBalance.value = UserBalance.fromJson(data['data']);
        } else {
          throw Exception('Error en los datos del servidor');
        }
      } else {
        throw Exception('Error en la conexión al servidor');
      }
    } catch (e) {
      // Manejo de errores
      print('data balance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showPurchaseModal(BuildContext context) {
    // Instanciamos los controladores (si ya están instanciados, Get.put devolverá la instancia existente)
    final userBalanceController = Get.put(UserBalanceController());
    final cursoController = Get.put(CursoUsuarioController());
    final calendarController = Get.put(CalendarController());

    // Nota: Se asume que productController ya está inicializado en algún otro lugar con Get.find o similar

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height / 1.2,
        width: MediaQuery.of(context).size.width,
        padding: Styles.paddingAll,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        // Usamos Obx para reaccionar al estado de carga
        child: Obx(() {
          // Se considera en carga si alguno de los controladores está realizando una operación
          final bool loading = cursoController.isLoading.value ||
              calendarController.isLoading.value;

          return Stack(
            children: [
              // Contenido principal desplazable
              if (!loading)
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Indicador visual en la parte superior
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
                      // Imagen del producto
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            productController.selectedProduct.value.imagen,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/placeholder_image.png', // Reemplaza con la ruta de tu imagen de repuesto
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Descripción del producto
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          productController.selectedProduct.value.descripcion,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Contenedor con Balance y detalles del producto
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                decoration: const BoxDecoration(
                                  color: Styles.colorContainer,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        productController.selectedProduct.value
                                            .nombreProducto,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Leto',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        productController
                                            .selectedProduct.value.precio,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Styles.primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                              child: Icon(
                                Icons.party_mode,
                                color: Styles.primaryColor,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                decoration: const BoxDecoration(
                                  color: Styles.colorContainer,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Balance(
                                  controller: userBalanceController,
                                  recarga: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 15),
                      // Botón de compra, deshabilitado si se está en estado de carga
                      ButtonDefaultWidget(
                        callback: loading
                            ? null
                            : () {
                                var precioProducto = Helper.cleanNumberString(
                                    productController
                                        .selectedProduct.value.precio);

                                var precionBalance = Helper.cleanNumberString(
                                    userBalanceController
                                        .userBalance.value.balance);

                                if (productController
                                    .selectedProduct.value.precio.isEmpty) {
                                  CustomSnackbar.show(
                                    title: 'Error',
                                    message: 'El precio es requerido',
                                    isError: true,
                                  );
                                  return;
                                }

                                // Validación de fondos insuficientes
                                if (double.parse(precionBalance) <
                                    double.parse(precioProducto)) {
                                  Get.dialog(
                                    CustomAlertDialog(
                                      icon: Icons.close,
                                      title: 'Error',
                                      description: 'Fondos insuficientes',
                                      primaryButtonText: 'Aceptar',
                                      onPrimaryButtonPressed: () => Get.back(),
                                    ),
                                    barrierDismissible: false,
                                  );
                                } else {
                                  Get.dialog(
                                    CustomAlertDialog(
                                      icon: Icons.account_balance_wallet,
                                      title: 'Atención',
                                      description:
                                          'Estás a punto de confirmar esta transacción. ¿Deseas continuar?',
                                      primaryButtonText: 'Aceptar',
                                      onPrimaryButtonPressed: () {
                                        switch (productController
                                            .selectedProduct.value.slug) {
                                          case 'curso':
                                            cursoController.subscribeToCourse(
                                              productController
                                                  .selectedProduct.value.id,
                                            );
                                            break;
                                          case 'servicio':
                                            calendarController.postEvent();
                                            break;
                                          default:
                                            print(
                                                'Tipo de producto no reconocido');
                                        }
                                        Get.back();
                                      },
                                    ),
                                    barrierDismissible: false,
                                  );
                                }
                              },
                        title: loading
                            ? 'Cargando...'
                            : 'Comprar ${productController.selectedProduct.value.slug}',
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              // Overlay de carga
              if (loading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        }),
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
