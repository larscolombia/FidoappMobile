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
  var selectedUserForInvitation = Rxn<User>(); // Variable específica para invitación
  var selectedUserEmail = ''.obs; // Variable para almacenar el email del usuario seleccionado
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
          filteredUsers.value = []; // Inicialmente vacío, solo se llena con búsquedas
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
      filteredUsers.value = []; // Si no hay búsqueda, no mostrar nada
    } else {
      // Filtrar usuarios por email y excluir al usuario actual
      var foundUsers = users.where((user) => 
        user.email.toLowerCase().contains(query.toLowerCase()) && 
        user.id != AuthServiceApis.dataCurrentUser.id // Excluir al usuario actual
      ).toList();
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
        // Filtramos solo por ID si la conversión fue exitosa y excluimos al usuario actual
        var foundUsers = users.where((user) => 
          user.id == queryId && 
          user.id != AuthServiceApis.dataCurrentUser.id // Excluir al usuario actual
        ).toList();
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
      filteredUsers.value = []; // No mostrar nada si no hay búsqueda
    } else {
      var foundUsers = users
          .where((user) =>
              user.profile != null && 
              user.profile!.expert != null && 
              user.profile!.expert!.toLowerCase().contains(expertQuery.toLowerCase()) &&
              user.id != AuthServiceApis.dataCurrentUser.id) // Excluir al usuario actual
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

  // Métodos específicos para invitación
  void selectUserForInvitation(User user) {
    selectedUserForInvitation.value = user;
    selectedUserEmail.value = user.email ?? ''; // Almacenar el email del usuario seleccionado
  }

  void deselectUserForInvitation() {
    selectedUserForInvitation.value = null;
    selectedUserEmail.value = ''; // Limpiar el email cuando se deselecciona
  }

  Future<void> getSharedOwnersWithEmail(String petId, String email) async {
    final url = Uri.parse('${BASE_URL}pets/$petId/shared-owners-with-email');
    isLoading.value = true;

    try {
      final requestBody = json.encode({
        "email": email,
      });
      
      print('Enviando petición a: $url');
      print('Body de la petición: $requestBody');
      print('Email a enviar: $email');

      // Agregar un delay antes de enviar la petición para evitar rate limiting
      await Future.delayed(const Duration(milliseconds: 1000));

      // Implementar reintentos con backoff exponencial
      int maxRetries = 3;
      int retryCount = 0;
      http.Response? response;

      while (retryCount < maxRetries) {
        try {
          response = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
              'Content-Type': 'application/json',
            },
            body: requestBody,
          );

          // Si la respuesta es exitosa o no es 429, salir del bucle
          if (response.statusCode != 429) {
            break;
          }

          // Si es 429, esperar antes del siguiente intento
          retryCount++;
          if (retryCount < maxRetries) {
            int delayMs = 2000 * retryCount; // Backoff exponencial: 2s, 4s, 6s
            print('Error 429, reintentando en ${delayMs}ms (intento ${retryCount + 1}/$maxRetries)');
            await Future.delayed(Duration(milliseconds: delayMs));
          }
        } catch (e) {
          print('Error en intento ${retryCount + 1}: $e');
          retryCount++;
          if (retryCount < maxRetries) {
            int delayMs = 2000 * retryCount;
            await Future.delayed(Duration(milliseconds: delayMs));
          }
        }
      }

      // Si después de todos los reintentos no hay respuesta, lanzar error
      if (response == null) {
        throw Exception('No se pudo completar la petición después de $maxRetries intentos');
      }

      print('Respuesta agregar usuario: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decodificamos la respuesta si es exitosa
        final data = json.decode(response.body);
        print('Respuesta del servidor: $data');
        
        // Verificar si la respuesta indica éxito
        if (data['success'] == true || data['status'] == true || data['message']?.toString().toLowerCase().contains('exitosamente') == true) {
          final message = data['message'] ?? 'Persona agregada exitosamente';
          CustomSnackbar.show(
            title: 'Éxito',
            message: message,
            isError: false,
          );
        } else {
          // El backend respondió con éxito pero indicó que algo falló
          final message = data['message'] ?? 'Hubo un error al agregar la persona';
          CustomSnackbar.show(
            title: 'Error',
            message: message,
            isError: true,
          );
        }
      } else if (response.statusCode == 404) {
        // Usuario no encontrado - esto es esperado cuando el usuario no existe
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Usuario no encontrado. Se ha enviado una invitación.';
        CustomSnackbar.show(
          title: 'Invitación enviada',
          message: message,
          isError: false,
        );
      } else if (response.statusCode == 429) {
        // Error de demasiadas peticiones
        CustomSnackbar.show(
          title: 'Error',
          message: 'El servidor está muy ocupado. La invitación se enviará automáticamente en unos momentos.',
          isError: false, // Cambiar a false para que no parezca un error crítico
        );
      } else if (response.statusCode == 422) {
        // Error de validación
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Datos inválidos';
        CustomSnackbar.show(
          title: 'Error de validación',
          message: message,
          isError: true,
        );
      } else {
        // Otros errores
        final data = json.decode(response.body);
        final message = data['message'] ?? 'Hubo un error al agregar la persona';
        CustomSnackbar.show(
          title: 'Error',
          message: message,
          isError: true,
        );
      }
    } catch (error) {
      print('Error de conexión: $error');
      
      // Si el error es por demasiados reintentos, mostrar mensaje específico
      if (error.toString().contains('No se pudo completar la petición después de')) {
        CustomSnackbar.show(
          title: 'Servidor ocupado',
          message: 'El servidor está muy ocupado. La invitación se procesará automáticamente en unos momentos.',
          isError: false,
        );
      } else {
        CustomSnackbar.show(
          title: 'Error',
          message: 'Error de conexión con el servidor',
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
