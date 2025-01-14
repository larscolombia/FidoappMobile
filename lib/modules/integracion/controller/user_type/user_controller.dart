import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';

import 'package:pawlly/modules/integracion/model/user_type/user_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var selecterUser = <User>[].obs;
  var url = "$DOMAIN_URL/api/get-user-by-type?user_type=training";
  var isLoading = false.obs;
  var selectedButton = 'Veterinarios'.obs;
  var selectedUser =
      Rxn<User>(); // Variable observable para el usuario seleccionado
  var type = 'vet'.obs;
  var expertTags = <String>[].obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      print(
          'usertype url ${Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$type")}');

      final response = await http.get(
        Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$type"),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data['success']) {
          print('usuario tipo ${data['data']}');
          users.value = (data['data'] as List)
              .map((user) => User.fromJson(user))
              .toList();
          filteredUsers.value =
              users; // Inicialmente mostramos todos los usuarios
          selecterUser.value = users;
          generateExpertTags();
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error al obtener usuarios $e');
    } finally {
      isLoading.value = false;
    }
  }

  final User defaultUser = User(
    id: 0,
    profileImage: '',
    firstName: '',
    lastName: '',
    email: '',
  );

  void filterUsers(String? query) {
    if (query == null || query.isEmpty) {
      filteredUsers.value =
          List.from(users); // Si no hay búsqueda, mostrar todos
    } else {
      var foundUsers = users
          .where(
              (user) => user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredUsers.value = foundUsers.isEmpty ? [] : foundUsers;
    }
  }

  void filterUsersByExpert(String? expertQuery) {
    if (expertQuery == null || expertQuery.isEmpty) {
      filteredUsers.value =
          List.from(users); // Mostrar todos si no hay búsqueda
    } else {
      var foundUsers = users
          .where((user) =>
              user.profile != null &&
              user.profile!.expert != null &&
              user.profile!.expert!
                  .toLowerCase()
                  .contains(expertQuery.toLowerCase()))
          .toList();
      filteredUsers.value = foundUsers.isEmpty ? [] : foundUsers;
    }
  }

  void generateExpertTags() {
    expertTags.value = users
        .map((user) => user.profile?.expert ?? '')
        .where((expert) => expert.isNotEmpty)
        .toSet()
        .toList();
  }

  void selectUser(User user) {
    selectedUser.value = user;
  }

  void deselectUser() {
    selectedUser.value = null;
  }

  Future<void> getSharedOwnersWithEmail(String petId, String email) async {
    // Reemplaza 'https://example.com' por tu URL base real.
    final url = Uri.parse('${BASE_URL}pets/$petId/shared-owners-with-email');
    isLoading.value = true;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          // Corregido: "email" en lugar de "emaul"
          "email": email,
        }),
      );

      print('Respuesta agregar usuario: ${response}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decodificamos la respuesta si es exitosa
        final data = json.decode(response.body);

        Get.snackbar(
          'Éxito',
          'Persona agregada exitosamente',
          backgroundColor: Colors.green,
        );

        // Aquí puedes retornar o manipular la data obtenida
      } else {
        print('Respuesta agregar usuario: ${response.body}');

        Get.snackbar(
          'Error',
          'Hubo un error al agregar la persona',
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error del servidor',
        backgroundColor: Colors.red,
      );
      print('Error de conexión: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
