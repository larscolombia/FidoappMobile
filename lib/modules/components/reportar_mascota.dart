import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/mascota_perdida/mscota_perdida.dart';

class LongPressButton extends StatefulWidget {
  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  double _progress = 0.0;
  Timer? _timer;
  final MascotaPerdida _mascotaPerdida = Get.put(MascotaPerdida());
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmación'),
        content: Text('¿Estás seguro de realizar esta acción?'),
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
    );
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
