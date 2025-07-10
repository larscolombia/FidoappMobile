import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/modules/integracion/model/availability/availability_model.dart';
import 'package:pawlly/modules/components/style.dart';

class AvailabilityModal {
  static void showAvailabilityModal(
    BuildContext context,
    AvailabilityResponse availabilityResponse,
    VoidCallback onContinue,
  ) {
    // Solo mostrar el modal si está ocupado
    if (!availabilityResponse.isOccupied) {
      return;
    }

    Get.dialog(
      CustomAlertDialog(
        icon: Icons.warning_amber_rounded,
        title: 'Horario Ocupado',
        description: _buildDescription(availabilityResponse),
        primaryButtonText: 'Entendido',
        onPrimaryButtonPressed: () {
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }

  static String _buildDescription(AvailabilityResponse response) {
    String description = 'El horario seleccionado está ocupado.\n\n';
    description += 'Duración del servicio: ${response.serviceDuration} minutos\n\n';
    
    if (response.occupiedIntervals.isNotEmpty) {
      description += 'Este profesional solo estará disponible fuera de estos horarios:\n';
      for (var interval in response.occupiedIntervals) {
        description += '• ${interval.start} - ${interval.end}\n';
      }
    }
    
    return description;
  }
} 