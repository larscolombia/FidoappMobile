import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'dart:async';

import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascota_perdida/mscota_perdida.dart';

class LongPressButton extends StatefulWidget {
  const LongPressButton({super.key});

  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  double _progress = 0.0;
  Timer? _timer;
  final MascotaPerdida _mascotaPerdida = Get.put(MascotaPerdida());
  final HomeController _homeController = Get.put(HomeController());
  void _startProgress() {
    const duration = Duration(milliseconds: 50); // Intervalo de tiempo
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _progress += 0.01; // Incrementa el progreso en cada tick
      });

      if (_progress >= 1.0) {
        timer.cancel();
        _showAlert();
      }
    });
  }

  void _stopProgress() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _progress = 0.0; // Resetea el progreso
    });
  }

  void _showAlert() {
    Get.dialog(
      CustomAlertDialog(
        isSelect: true,
        icon: Icons.crisis_alert,
        buttonCancelar: true,
        title: 'Alerta de mascota extraviado',
        description:
            '¿Estás seguro de marcar a ${_homeController.selectedProfile.value!.name} como extraviado?',
        primaryButtonText: 'Aceptar',
        onPrimaryButtonPressed: () {
          print('Acción confirmada');
          _mascotaPerdida.reportarMascotaPerdida();
          Navigator.of(context).pop();
        },
      ),
      barrierDismissible: true, // No permite cerrar el diálogo tocando fuera
    );
    /** 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text(
            '¿Estás seguro de marcar a ${_homeController.selectedProfile.value!.name} como extraviado?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetButton();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              print('Acción confirmada');
              _mascotaPerdida.reportarMascotaPerdida();
              //  _resetButton();
            },
            child: Text('Aceptar'),
          ),
        ],
      ),
    );*/
  }

  void _resetButton() {
    setState(() {
      _progress = 0.0; // Restablece el progreso después de la alerta
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startProgress(),
      onLongPressEnd: (_) => _stopProgress(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Botón principal
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Styles.iconColorBack,
                width: .5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: const Center(
                child: Icon(
              Icons.report,
              color: Colors.black,
            )),
          ),

          // Barra de progreso

          // Indicador de progreso
          if (_progress > 0 && _progress < 1.0)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    value: _progress,
                    color: Styles.fiveColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
