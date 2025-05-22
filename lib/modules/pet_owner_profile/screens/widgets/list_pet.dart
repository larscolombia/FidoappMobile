import 'package:flutter/material.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/owner_model.dart';
import 'package:pawlly/styles/styles.dart';

class ListPet extends StatelessWidget {
  final List<Pets> pets;

  const ListPet({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Styles.paddingAll,
      child: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              child: const Text(
                'Mascotas',
                style: TextStyle(
                  color: Styles.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PoetsenOne',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...pets.map((pet) {
            return GestureDetector(
              onTap: () {
                // Acción al hacer clic en una mascota
              },
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: const Color(0xffEFEFEF)),
                ),
                child: Card(
                  elevation: 0.0, // Quita la elevación (sombra)
                  shadowColor: Colors
                      .transparent, // Opcional: asegura que no se muestre sombra
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        pet.petImage ??
                            'https://via.placeholder.com/150', // Cambiar por la URL de la mascota
                      ),
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
                      pet.name ?? '',
                      style: Styles.textProfile14w700,
                    ),
                    subtitle: Text(
                      pet.age ?? '',
                      style: Styles.textProfile12w400,
                    ),
                    /*
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Styles.iconColorBack,
                    ),
                    */
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
