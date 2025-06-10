import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/user_type/user_controller.dart';

class UserSearchPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  UserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Usuarios'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => userController.filterUsers(value),
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: userController.filteredUsers.length,
          itemBuilder: (context, index) {
            final user = userController.filteredUsers[index];
            return ListTile(
              leading: Image.network(user.profileImage ?? ''),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
            );
          },
        );
      }),
    );
  }
}
