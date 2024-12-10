import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'dart:convert';

import 'package:pawlly/modules/integracion/model/user_type/user_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var url = "${DOMAIN_URL}/api/get-user-by-type?user_type=vet";
  var isLoading = false.obs;
  var selectedUser =
      Rxn<User>(); // Variable observable para el usuario seleccionado

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('la respuesta de veterinario es $data');
        if (data['success']) {
          users.value = (data['data'] as List)
              .map((user) => User.fromJson(user))
              .toList();
          filteredUsers.value =
              users; // Inicialmente mostramos todos los usuarios
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error al obtener usuarios ${e}');
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

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = users; // Si no hay búsqueda, mostrar todos
    } else {
      var foundUser = users.firstWhere(
        (user) => user.email.toLowerCase() == query.toLowerCase(),
        orElse: () => defaultUser,
      );

      if (foundUser != null && foundUser != defaultUser) {
        filteredUsers.value = [foundUser];
      } else {
        filteredUsers.value = [defaultUser];
      }
    }
  }

  void selectUser(User user) {
    selectedUser.value = user;
  }

  void deselectUser() {
    selectedUser.value = null;
  }
}
