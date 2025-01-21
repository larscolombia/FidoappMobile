import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';

import 'package:pawlly/modules/components/border_redondiado.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/dashboard/screens/dashboard_screen.dart';
import 'package:pawlly/modules/fideo_coin/FideCoin.dart';
import 'package:pawlly/modules/fideo_coin/recarga_controller.dart';

class RecargarSaldoScreen extends StatefulWidget {
  RecargarSaldoScreen({super.key});

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
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Stack(
              children: [BorderRedondiado(top: 180)],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BarraBack(
                    titulo: 'Balance',
                    callback: () {
                      Get.off(() => DashboardScreen());
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
                              side: const BorderSide(
                                color: Styles.fiveColor,
                                width: .5,
                              ),
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
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        //pisa papel
                        CustomAlertDialog(
                          icon: Icons.check_circle_outline,
                          title: 'Confirmación',
                          buttonCancelar: true,
                          description: controller.isLoading.value == true
                              ? "cargando ..."
                              : 'Estas a punto de comprar ${_formattedInput(_input)}ƒ',
                          primaryButtonText: 'Continuar',
                          onPrimaryButtonPressed: () async {
                            // 2. Muestra una pantalla de carga

                            controller.GetUrlPayment(
                                _formattedInput(_input), context);
                          },
                        ),
                        barrierDismissible: true,
                      );

                      // _confirmarTransaccion();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Styles.primaryColor,
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 2,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
