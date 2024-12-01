import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/util/util.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'dart:convert';

import '../../model/comandos_model/comandos_model.dart';

class ComandoController extends GetxController {
  var comandoList = <Comando>[].obs;
  var isLoading = true.obs;
  final String apiUrl = "${DOMAIN_URL}/api"; // Reemplaza con tu URL de API

  @override
  void onInit() {
    super.onInit();
  }

  void url() {
    print('comandos de entrenamientos ${Uri.parse('$apiUrl/comandos')}');
  }

  void fetchComandos() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/comandos'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
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

  final List<Map<String, String>> dummyData = [
    {
      "Comando": "Sentarse",
      "Acción": "El perro se sienta",
      "Aprendido": "Sí",
      "Comando personalizado": ""
    },
    {
      "Comando": "Quieto",
      "Acción": "El perro se queda quieto",
      "Aprendido": "No",
      "Comando personalizado": ""
    },
    {
      "Comando": "Buscar",
      "Acción": "El perro trae el objeto",
      "Aprendido": "Sí",
      "Comando personalizado": "Busca pelota"
    },
    {
      "Comando": "Buscar",
      "Acción": "El perro trae el objeto",
      "Aprendido": "Sí",
      "Comando personalizado": "Busca pelota"
    },
  ];
}
