import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_alert_dialog_widget.dart';
import 'package:pawlly/components/custom_snackbar.dart';

import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/home/controllers/home_controller.dart';
import 'package:pawlly/modules/home/screens/home_screen.dart';
import 'package:pawlly/modules/integracion/util/util.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:pawlly/modules/home/screens/training/crear_comando.dart';
import 'dart:convert';

import '../../model/comandos_model/comandos_model.dart';

class ComandoController extends GetxController {
  final HomeController homeController = Get.find();
  var comandoList = <Comando>[].obs;
  var isLoading = false.obs;
  final String apiUrl = "$DOMAIN_URL/api"; // Reemplaza con tu URL de API
  var selectedComando =
      Rxn<Comando>(); // Variable observable para el comando seleccionado
  @override
  void onInit() {
    super.onInit();

    // Escucha los cambios en el perfil seleccionado dinámicamente
    ever(homeController.selectedProfile, (profile) {
      if (profile != null) {
        fetchComandos(profile.id.toString());
      } else {
        comandoList.clear(); // Limpia la lista si no hay perfil seleccionado
      }
    });

    // Llama a fetchComandos si ya hay un perfil seleccionado al inicio
    if (homeController.selectedProfile.value != null) {
      fetchComandos(homeController.selectedProfile.value!.id.toString());
    }
  }

  void selectComando(Comando comando) {
    selectedComando.value = comando;
  }

  void deselectComando() {
    selectedComando.value = null;
  }

  void editComando(Comando comando) {
    // Cargar los datos del comando en el formulario de edición
    dataComando['name'] = comando.name;
    dataComando['description'] = comando.description;
    dataComando['type'] = comando.type;
    dataComando['is_favorite'] = comando.isFavorite;
    dataComando['category_id'] = comando.categoryId;
    dataComando['voz_comando'] = comando.vozComando;
    dataComando['instructions'] = comando.instructions;
    dataComando['pet_id'] = homeController.selectedProfile.value?.id ?? '';
    
    // Debug: imprimir los datos cargados
    print('=== DATOS CARGADOS PARA EDICIÓN ===');
    print('name: ${dataComando['name']}');
    print('description: ${dataComando['description']}');
    print('voz_comando: ${dataComando['voz_comando']}');
    print('instructions: ${dataComando['instructions']}');
    print('====================================');
    
    // Navegar a la pantalla de edición
    Get.to(() => CrearComando(isEditing: true, comandoId: comando.id));
  }

  void fetchComandos(String petId) async {
    isLoading.value = true;
    print(
        'id de la mascota ${Uri.parse('$apiUrl/comandos/commands-by-user/get?pet_id=${petId ?? '0'}')}');
    try {
      final response = await http.get(
          Uri.parse(
              '$apiUrl/comandos/commands-by-user/get?pet_id=${petId ?? '0'}'),
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
        } else {
          // Si success es false, limpiar la lista de comandos
          comandoList.clear();
          print('No se encontraron comandos para este pet_id: ${comandoData['message']}');
        }
      } else {
        print('Failed to fetch commands');
        comandoList.clear();
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
        CustomSnackbar.show(
          title: 'Éxito',
          message: 'Comando actualizado correctamente',
          isError: false,
        );
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'No se pudo actualizar el comando',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateDummyData(List<Comando> comandos) {
    dummyData.clear();
    for (var comando in comandos) {
      dummyData.add({
        "Comando": comando.name,
        "Acción": comando.description,
        "Aprendido": comando.isFavorite ? "Sí" : "No",
        "Comando personalizado": comando.vozComando
      });
    }
  }

  void toggleFavorite(int id) async {
    int index = comandoList.indexWhere((c) => c.id == id);
    if (index != -1) {
      bool newFavoriteStatus = !comandoList[index].isFavorite;
      comandoList[index].isFavorite = newFavoriteStatus;

      isLoading.value = true;
      try {
        final response = await http.put(
          Uri.parse('$apiUrl/comandos/$id'),
          headers: Util.headers(),
          body: json.encode({'is_favorite': newFavoriteStatus ? 1 : 0}),
        );

        if (response.statusCode == 200) {
          comandoList.refresh();
          CustomSnackbar.show(
            title: 'Éxito',
            message: 'Estado favorito actualizado',
            isError: false,
          );
        } else {
          comandoList[index].isFavorite = !newFavoriteStatus;
          CustomSnackbar.show(
            title: 'Error',
            message: 'No se pudo actualizar el estado favorito',
            isError: true,
          );
        }
      } catch (e) {
        comandoList[index].isFavorite = !newFavoriteStatus;
        CustomSnackbar.show(
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  final List<Map<String, String>> dummyData = [];

  //crear comando

  var dataComando = {
    "name": "",
    "description": "",
    "type": "especializado",
    "is_favorite": true,
    "category_id": 1,
    "voz_comando": "",
    "instructions": "",
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
            description: 'Comando creado con éxito',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              dataComando = {
                "name": "",
                "description": "",
                "type": "especializado",
                "is_favorite": true,
                "category_id": 1,
                "voz_comando": "",
                "instructions": "",
                "pet_id": ''
              };
              Get.off(HomeScreen()); // Cerrar el diálogo
              CustomSnackbar.show(
                title: 'Éxito',
                message: 'Comando creado correctamente',
                isError: false,
              );
            },
          ),
          barrierDismissible:
              false, // No permite cerrar el diálogo tocando fuera
        );
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Error al crear el comando',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al crear el comando: ${e.toString()}',
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }

  // Actualizar comando
  Future<void> updateCommand(int comandoId, Map<String, dynamic> dataComando) async {
    final url = Uri.parse('${BASE_URL}comandos/$comandoId');
    isLoading.value = true;
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization':
              'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(dataComando),
      );

      if (response.statusCode == 200) {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'Comando actualizado con éxito',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              dataComando = {
                "name": "",
                "description": "",
                "type": "especializado",
                "is_favorite": true,
                "category_id": 1,
                "voz_comando": "",
                "instructions": "",
                "pet_id": ''
              };
              Get.off(HomeScreen()); // Cerrar el diálogo
              CustomSnackbar.show(
                title: 'Éxito',
                message: 'Comando actualizado correctamente',
                isError: false,
              );
            },
          ),
          barrierDismissible: false,
        );
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Error al actualizar el comando',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al actualizar el comando: ${e.toString()}',
        isError: true,
      );
    } finally {
      isLoading(false);
    }
  }

  // Método para eliminar un comando
  Future<void> deleteComando(int comandoId) async {
    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse('$apiUrl/comandos/$comandoId'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Eliminar el comando de la lista local
        comandoList.removeWhere((comando) => comando.id == comandoId);
        
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.check_circle_outline,
            title: 'Éxito',
            description: 'Comando eliminado exitosamente.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () {
              Get.back();
            },
          ),
          barrierDismissible: false,
        );
      } else {
        Get.dialog(
          CustomAlertDialog(
            icon: Icons.error_outline,
            title: 'Error',
            description: 'Hubo un problema al eliminar el comando.',
            primaryButtonText: 'Aceptar',
            onPrimaryButtonPressed: () => Get.back(),
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      print('Error al eliminar el comando: $e');
      Get.dialog(
        CustomAlertDialog(
          icon: Icons.error_outline,
          title: 'Error',
          description: 'Error al eliminar el comando: $e',
          primaryButtonText: 'Aceptar',
          onPrimaryButtonPressed: () => Get.back(),
        ),
        barrierDismissible: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Método para mostrar confirmación de eliminación
  void showDeleteConfirmation(int comandoId, String comandoName) {
    Get.dialog(
      CustomAlertDialog(
        icon: Icons.delete_outline,
        title: "Confirmar eliminación",
        description: "¿Estás seguro de que deseas eliminar '$comandoName'?",
        buttonCancelar: true,
        primaryButtonText: "Eliminar",
        onPrimaryButtonPressed: () async {
          Get.back(); // Cierra el modal de confirmación
          await deleteComando(comandoId);
        },
      ),
    );
  }
}
