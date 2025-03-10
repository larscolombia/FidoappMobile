import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'dart:async';

import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/integracion/controller/mascota_perdida/mscota_perdida.dart';

class LongPressButton extends StatefulWidget {
  final bool isDiario;

  const LongPressButton({super.key, this.isDiario = false});

  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  double _progress = 0.0;
  Timer? _timer;
  Timer? _vibrationTimer;
  bool _isPressed = false;
  final MascotaPerdida _mascotaPerdida = Get.put(MascotaPerdida());
  final HomeController _homeController = Get.put(HomeController());

  void _startProgress() {
    setState(() {
      _isPressed = true;
    });

    _startVibration();

    const duration = Duration(milliseconds: 50);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _progress += 0.01;
      });

      if (_progress >= 1.0) {
        timer.cancel();
        _stopVibration();
        _showAlert();
      }
    });
  }

  void _stopProgress() {
    _timer?.cancel();
    _stopVibration();
    setState(() {
      _progress = 0.0;
      _isPressed = false;
    });
  }

  void _startVibration() {
    _vibrationTimer =
        Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!_isPressed) {
        timer.cancel();
        return;
      }
      HapticFeedback.mediumImpact();
    });
  }

  void _stopVibration() {
    _vibrationTimer?.cancel();
  }

  void _showAlert() {
    Get.dialog(
      CustomAlertDialog(
        isSelect: true,
        icon: Icons.crisis_alert,
        buttonCancelar: true,
        title: 'Alerta de mascota extraviada',
        description:
            '¿Estás seguro de marcar a ${_homeController.selectedProfile.value?.name ?? "tu mascota"} como extraviado?',
        primaryButtonText: 'Aceptar',
        onPrimaryButtonPressed: () {
          _mascotaPerdida.reportarMascotaPerdida();
          _resetButton();
          Get.back(); // Cierra el diálogo
        },
      ),
      barrierDismissible: true,
    ).then((_) => _resetButton()); // Resetea cuando el modal se cierra
  }

  void _resetButton() {
    _stopVibration();
    setState(() {
      _progress = 0.0;
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.isDiario ? 0 : Styles.padding, vertical: 16),
      child: GestureDetector(
        onLongPressStart: (_) => _startProgress(),
        onLongPressEnd: (_) => _stopProgress(),
        child: AnimatedScale(
          scale: _isPressed ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isPressed
                  ? const Color(0xFFFF7A66)
                  : const Color(0xFFFC9214),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF4931).withOpacity(0.7),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    'Reportar mascota perdida',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
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
          ),
        ),
      ),
    );
  }
}
