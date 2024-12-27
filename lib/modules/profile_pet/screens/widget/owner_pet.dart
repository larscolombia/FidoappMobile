import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pawlly/modules/profile_pet/controllers/pet_owner_controller.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/styles/styles.dart';

class PetOwnersWidget extends StatelessWidget {
  final int petId;

  const PetOwnersWidget({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final PetOwnerController controller = Get.put(PetOwnerController());

    // Llama al método para obtener los datos
    controller.fetchOwnersList(petId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Dueños de Mascota'),
      ),
      body: Obx(() {
        return ListView(
          children: controller.associatedPersons.map((person) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.PETOWNERPROFILE, arguments: person);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      person['imageUrl'] ?? 'https://via.placeholder.com/150',
                    ),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Styles.iconColorBack,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    person['name'] ?? '',
                    style: Styles.textProfile14w700,
                  ),
                  subtitle: Text(
                    person['relation'] ?? '',
                    style: Styles.textProfile12w400,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Styles.iconColorBack,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
