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
      final response = await http.get(
        Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$type"),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(
            'la respuesta de veterinario es ${Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$type")}');
        print('la respuesta de veterinario es $data');
        if (data['success']) {
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
      Get.snackbar("Error", "Error al obtener usuarios",
          backgroundColor: Colors.red);
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
}
