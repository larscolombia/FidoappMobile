import 'package:pawlly/models/pet_data.dart';
import 'package:pawlly/models/pet_list_res_model.dart';

class PetProfile {
  String name;
  String breed;
  String description;
  String age;
  String birthDate;
  String weight;
  String gender;
  String imagePath;
  List<Map<String, String>> associatedPersons;
  List<Map<String, String>> medicalHistory;

  PetProfile({
    required this.name,
    required this.breed,
    required this.description,
    required this.age,
    required this.birthDate,
    required this.weight,
    required this.gender,
    required this.imagePath,
    required this.associatedPersons,
    required this.medicalHistory,
  });

  factory PetProfile.fromPetData(PetData petData) {
    return PetProfile(
      name: petData.name,
      breed: petData.breed,
      description: petData.description ?? 'No se a colocado descripción',
      age: petData.age,
      birthDate: petData.dateOfBirth ?? '01/01/2021',
      weight: '${petData.weight}',
      gender: petData.gender,
      imagePath: petData.petImage ?? '',
      associatedPersons: [
        {'name': 'John Does', 'relation': 'Dueño'},
        {'name': 'Jane Smiths', 'relation': 'Veterinario'},
        {'name': 'Alice Johnson', 'relation': 'Invitado'},
        {'name': 'Alice Johnson', 'relation': 'Invitado'},
      ],
      medicalHistory: [
        {
          'title': 'Consulta General',
          'type': 'Consulta',
          'date': '01/08/2023',
          'reportNumber': '12345'
        },
        {
          'title': 'Vacunación Anual',
          'type': 'Vacuna',
          'date': '15/07/2023',
          'reportNumber': '67890'
        },
      ],
    );
  }

  void updateFromPetData(PetData petData) {
    name = petData.name;
    breed = petData.breed;
    description = 
        petData.description ?? 'Una mascota muy amigable y juguetona.';
    age = petData.age;
    birthDate = petData.dateOfBirth ?? '01/01/2021';
    weight = '${petData.weight}';
    gender = petData.gender;
    imagePath = petData.petImage ?? '';
  }
}
