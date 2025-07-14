import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/modules/fideo_coin/recarga_controller.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:url_launcher/url_launcher.dart';

class RecargarSaldoScreen extends StatefulWidget {
  final bool isWithdraw;

  RecargarSaldoScreen({super.key, this.isWithdraw = false});

  @override
  _RecargarSaldoScreenState createState() => _RecargarSaldoScreenState();
}

class _RecargarSaldoScreenState extends State<RecargarSaldoScreen> {
  String _input = "";

  // Formatear la entrada
  String _formattedInput(String input) {
    if (input.isEmpty) return "0,00";
    String cleanInput = input.replaceAll(',', '').padLeft(3, '0');
    String formatted =
        "${cleanInput.substring(0, cleanInput.length - 2)},${cleanInput.substring(cleanInput.length - 2)}";
    return formatted;
  }

  final StripeController controller = Get.put(StripeController());

  // Manejar teclas
  void _onPressedKey(String key) {
    setState(() {
      if (key == 'C') {
        _input = "";
      } else if (key == 'x') {
        if (_input.isNotEmpty) _input = _input.substring(0, _input.length - 1);
      } else {
        _input += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 200,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Completa la información',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: Recursos.fuente2,
                        ),
                      ),
                      Text(
                        'Digita la cantidad que deseas '
                        '${widget.isWithdraw ? 'retirar' : 'recargar'}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: Recursos.fuente1,
                        ),
                      ),
                    ],
                  ),
                ),
                BorderRedondiado(top: 180)
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: Styles.paddingAll,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarraBack(
                    size: 20,
                    titulo: widget.isWithdraw ? 'Retiro' : 'Recarga',
                    callback: () {
                      // Regresar a la pantalla anterior
                      Get.back();
                    },
                  ),

                  // Input sin bordes
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Styles.colorContainer,
                    ),
                    child: Text(
                      _formattedInput(_input),
                      style: const TextStyle(
                        fontSize: 32,
                        letterSpacing: 2,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Ver ofertas link
                  if (!widget.isWithdraw)
                    GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse('https://admin.myfidoapp.com/get-package-list');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          CustomSnackbar.show(
                            title: 'Error',
                            message: 'No se pudo abrir el enlace',
                            isError: true,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          'Ver ofertas',
                          style: TextStyle(
                            fontSize: 16,
                            color: Styles.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  
                  if (!widget.isWithdraw) const SizedBox(height: 20),
                  
                  Expanded(
                    child: GridView.builder(
                      itemCount: 12,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        String key;
                        if (index < 9) {
                          key = (index + 1).toString();
                        } else if (index == 9) {
                          key = 'C';
                        } else if (index == 10) {
                          key = '0';
                        } else {
                          key = 'x'; // Reemplazo de coma por "x"
                        }
                        return TextButton(
                          onPressed: () {
                            _onPressedKey(key);
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Styles.colorContainer,
                          ),
                          child: Text(
                            key,
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Botón Confirmar
                  ButtonDefaultWidget(
                    title: 'Confirmar',
                    callback: () {
                      if (_input.isEmpty ||
                          double.tryParse(_input.replaceAll(',', '')) == 0) {
                        CustomSnackbar.show(
                          title: 'Error',
                          message: 'Debe ingresar un monto mayor a 0',
                          isError: true,
                        );
                        return;
                      }

                      if (widget.isWithdraw &&
                          AuthServiceApis.dataCurrentUser.paymentAccount.isEmpty) {
                        CustomSnackbar.show(
                          title: 'Cuenta de pago requerida',
                          message: 'Debes agregar una cuenta de pago desde tu perfil',
                          isError: true,
                        );
                        return;
                      }

                      Get.dialog(
                        CustomAlertDialog(
                          icon: Icons.check_circle_outline,
                          title: 'Confirmación',
                          buttonCancelar: true,
                          description: controller.isLoading.value
                              ? "Procesando..."
                              : widget.isWithdraw
                                  ? 'Estás a punto de retirar \$ ${_formattedInput(_input)} . ¿Deseas continuar?'
                                  : 'Estás a punto de adquirir \$ ${_formattedInput(_input)} . ¿Deseas continuar?',
                          primaryButtonText: 'Continuar',
                          onPrimaryButtonPressed: () async {
                            print('input: $_input');
                            // Validar que el monto sea mayor o igual a 1 dólar (100 centavos)
                            double? amount = double.tryParse(_input.replaceAll(',', ''));
                            if (amount != null && amount < 100) {
                              Get.back(); // Cerrar el diálogo de confirmación
                              CustomSnackbar.show(
                                title: 'Error',
                                message: 'El valor no puede ser menor a 1.00 USD',
                                isError: true,
                              );
                              return;
                            }

                            if (widget.isWithdraw) {
                              await controller.withdrawBalance(
                                  _formattedInput(_input), context);
                            } else {
                              controller.GetUrlPayment(
                                  _formattedInput(_input), context);
                            }
                          },
                        ),
                        barrierDismissible: true,
                      );
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
