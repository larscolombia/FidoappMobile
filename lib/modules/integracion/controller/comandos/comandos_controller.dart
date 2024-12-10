import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';

import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/util/util.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'dart:convert';

import '../../model/comandos_model/comandos_model.dart';

class ComandoController extends GetxController {
  final HomeController homeController = Get.find();
  var comandoList = <Comando>[].obs;
  var isLoading = false.obs;
  final String apiUrl = "${DOMAIN_URL}/api"; // Reemplaza con tu URL de API
  var selectedComando =
      Rxn<Comando>(); // Variable observable para el comando seleccionado
  @override
  void onInit() {
    super.onInit();
    fetchComandos(
      homeController.selectedProfile.value!.id.toString() ?? "0",
    );
  }

  void selectComando(Comando comando) {
    selectedComando.value = comando;
  }

  void deselectComando() {
    selectedComando.value = null;
  }

  void fetchComandos(String petId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/comandos/commands-by-user/get?pet_id=${petId}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          });
      print('Comandos de entrenamientos ${json.decode(response.body)}');
      print('comandos de entrenamientos ${Uri.parse('$apiUrl/comandos')}');
      if (response.statusCode == 200) {
        var comandoData = json.decode(response.body);
        if (comandoData['success']) {
          var comandoListFromJson = (comandoData['data'] as List)
              .map((comandoJson) => Comando.fromJson(comandoJson))
              .toList();
          comandoList.assignAll(comandoListFromJson);
        }
      } else {
        print('Failed to fetch commands');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateComando(Comando updatedComando) async {
    isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/comandos/${updatedComando.id}'),
        headers: Util.headers(),
        body: json.encode(updatedComando.toJson()),
      );

      if (response.statusCode == 200) {
        int index = comandoList.indexWhere((c) => c.id == updatedComando.id);
        if (index != -1) {
          comandoList[index] = updatedComando;
          comandoList.refresh();
        }
        Get.snackbar('Success', 'Command updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update command');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateDummyData(List<Comando> comandos) {
    dummyData.clear();
    comandos.forEach((comando) {
      dummyData.add({
        "Comando": comando.name,
        "Acción": comando.description,
        "Aprendido": comando.isFavorite ? "Sí" : "No",
        "Comando personalizado": comando.vozComando
      });
    });
  }

  void toggleFavorite(int id) async {
    int index = comandoList.indexWhere((c) => c.id == id);
    if (index != -1) {
      bool newFavoriteStatus = !comandoList[index].isFavorite;
      comandoList[index].isFavorite = newFavoriteStatus;

      isLoading.value = true;
      try {
        final response = await http.put(
          Uri.parse('$apiUrl/comandos/${id}'),
          headers: Util.headers(),
          body: json.encode({'is_favorite': newFavoriteStatus ? 1 : 0}),
        );

        if (response.statusCode == 200) {
          comandoList.refresh();
          Get.snackbar('Success', 'Favorite status updated');
        } else {
          comandoList[index].isFavorite = !newFavoriteStatus;
          Get.snackbar('Error', 'Failed to update favorite status');
        }
      } catch (e) {
        comandoList[index].isFavorite = !newFavoriteStatus;
        Get.snackbar('Error', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  final List<Map<String, String>> dummyData = [];

  //crear comando

  var dataComando = {
    "name": "Comando 1",
    "description": "Descripción del comando 1",
    "type": "especializado",
    "is_favorite": true,
    "category_id": 1,
    "voz_comando": "Voz de comando 1",
    "instructions": "Instrucciones del comando 1",
    "pet_id": ''
  }.obs;

  void updateField(String key, dynamic value) {
    dataComando[key] = value;
  }

  //crear comando

  Future<void> postCommand(Map<String, dynamic> dataComando) async {
    final url = Uri.parse('${BASE_URL}comandos');
    isLoading.value = true;
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}', // Ajusta esto según sea necesario
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dataComando),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'La mascota ha sido eliminada exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.off(HomeScreen()); // Cerrar el diálogo
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error al crear el comando: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
