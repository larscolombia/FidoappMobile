import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/components/custom_snackbar.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/user_type/user_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var selecterUser = <User>[].obs;
  var url = "$DOMAIN_URL/api/get-user-by-type?user_type=training";
  var isLoading = false.obs;
  var usersDetails = <User>[].obs;

  var selectedButton = 'Veterinarios'.obs;
  var selectedUser = Rxn<User>(); // Variable observable para el usuario seleccionado
  var type = 'vet'.obs;
  var expertTags = <String>[].obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers([String? passedType]) async {
    print(passedType);
    final userType = passedType ?? type; // usa passedType si no es null, sino usa la propiedad type

    try {
      isLoading.value = true;
      print('usertype url ${Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$userType")}');

      final response = await http.get(
        Uri.parse("$DOMAIN_URL/api/get-user-by-type?user_type=$userType"),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        if (data['success']) {
          print('usuario tipo ${data['data']}');
          users.value = (data['data'] as List).map((user) => User.fromJson(user)).toList();
          filteredUsers.value = users;
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

  Future<void> fetchMultipleOwners(List<int> ownerIds) async {
    usersDetails.clear();
    isLoading.value = true;

    try {
      for (var id in ownerIds) {
        final user = await fetchUserById(id); // Llama la función para un solo usuario
        if (user != null) {
          usersDetails.add(user); // Acumula cada usuario en la lista
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<User?> fetchUserById(int id) async {
    try {
      final url = '${DOMAIN_URL}/api/user-detail?id=$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse["status"] == true && jsonResponse["data"] != null) {
          return User.fromJson(jsonResponse["data"]);
        } else {
          CustomSnackbar.show(
            title: 'Error',
            message: 'Usuario con id $id no encontrado',
            isError: true,
          );
        }
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Error al obtener usuario $id: ${response.statusCode}',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error al obtener usuario: $e',
        isError: true,
      );
    }

    return null; // En caso de error, retorna null
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
      filteredUsers.value = List.from(users); // Si no hay búsqueda, mostrar todos
    } else {
      var foundUsers = users.where((user) => user.email.toLowerCase().contains(query.toLowerCase())).toList();
      filteredUsers.value = foundUsers.isEmpty ? [] : foundUsers;
    }
  }

  void filterUsersId(String? query) {
    if (query == null || query.isEmpty) {
      filteredUsers.value = []; // Si no hay búsqueda o está vacía, no mostrar nada
    } else {
      // Intentamos convertir la consulta a un entero para filtrar por ID
      int? queryId = int.tryParse(query);

      if (queryId != null) {
        // Filtramos solo por ID si la conversión fue exitosa
        var foundUsers = users.where((user) => user.id == queryId).toList();
        print('resultado de la busqueda ${foundUsers}');
        filteredUsers.value = foundUsers.isEmpty ? [] : foundUsers;
      } else {
        // Si la consulta no es un número, no mostramos resultados
        filteredUsers.value = [];
      }
    }
  }

  void filterUsersByExpert(String? expertQuery) {
    if (expertQuery == null || expertQuery.isEmpty) {
      filteredUsers.value = List.from(users); // Mostrar todos si no hay búsqueda
    } else {
      var foundUsers = users
          .where((user) =>
              user.profile != null && user.profile!.expert != null && user.profile!.expert!.toLowerCase().contains(expertQuery.toLowerCase()))
          .toList();
      filteredUsers.value = foundUsers.isEmpty ? [] : foundUsers;
    }
  }

  void generateExpertTags() {
    expertTags.value = users.map((user) => user.profile?.expert ?? '').where((expert) => expert.isNotEmpty).toSet().toList();
  }

  void selectUser(User user) {
    selectedUser.value = user;
  }

  void deselectUser() {
    selectedUser.value = null;
  }

  Future<void> getSharedOwnersWithEmail(String petId, String email) async {
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

        CustomSnackbar.show(
          title: 'Éxito',
          message: 'Persona agregada exitosamente',
          isError: false,
        );

        // Aquí puedes retornar o manipular la data obtenida
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Hubo un error al agregar la persona',
          isError: true,
        );
      }
    } catch (error) {
      CustomSnackbar.show(
        title: 'Error',
        message: 'Error del servidor',
        isError: true,
      );
      print('Error de conexión: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
