import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/custom_text_form_field_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/profile_pet/controllers/profile_pet_controller.dart';
import 'package:http/http.dart' as http;
import 'package:pawlly/services/auth_service_apis.dart';

class PetInfoModal extends StatefulWidget {
  final ProfilePetController controller;

  PetInfoModal({required this.controller});

  @override
  _PetInfoModalState createState() => _PetInfoModalState();
}

class _PetInfoModalState extends State<PetInfoModal> {
  final _formKey = GlobalKey<FormState>();
  late String petName;
  late String petAge;
  late String petWeight = ""; // String petWeight;
  late String raza = "";
  late String description = "";
  late String petBirthDate = "";
  late String? petGender = "";
  late String petBreed;
  @override
  void initState() {
    super.initState();
    // Inicializamos los valores con los datos actuales del controlador
    petName = widget.controller.petName.value;
    petAge = widget.controller.petAge.value;
    petWeight = "${widget.controller.petWeight.value}";
    raza = widget.controller.petProfile.breed;
    description = widget.controller.petDescription.value;
    petGender = widget.controller.petProfile.gender;
    petBreed = widget.controller.petBirthDate.value;
  }

  //Actuliza la información de la mascota
  Future<void> _updatePetInfo(String petId) async {
    final url = Uri.parse('${DOMAIN_URL}/api/pets/${petId}');

    final token = AuthServiceApis.dataCurrentUser.apiToken;
    'tu_token_de_autenticacion_aqui'; // Reemplaza con tu token de autenticación
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': petName,
        'age': petAge,
        'gender': petGender,
        'weight': petWeight,
        'breed': raza,
        'description': description,
        'birth_date': petBirthDate,
      }),
    );

    if (response.statusCode == 200) {
      print('Pet updated successfully');
    } else {
      print('Error updating pet');
    }
    var res = response.body;
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Actualizar Información de la Mascota'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              // Campo para el Nombre de la Mascota
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: petName,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Mascota',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    petName = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: petGender, // Valor inicial
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Masculino')),
                  DropdownMenuItem(value: 'female', child: Text('Femenino')),
                ],
                onChanged: (value) {
                  setState(() {
                    petGender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona el sexo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo para la Edad de la Mascota
              TextFormField(
                initialValue: petAge,
                decoration: const InputDecoration(
                  labelText: 'Edad de la Mascota',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la edad.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    petAge = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: petWeight,
                decoration: const InputDecoration(
                  labelText: 'peso',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la edad.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    petWeight = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: raza,
                decoration: const InputDecoration(
                  labelText: 'Raza',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la edad.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    raza = value;
                  });
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                initialValue: petBreed,
                decoration: const InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la edad.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    petBreed = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Actualizamos los valores en el controlador
              widget.controller.petName.value = petName;
              widget.controller.petAge.value = petAge;

              // Lógica adicional como guardar en una API si es necesario
              _formKey.currentState
                  ?.save(); // Lógica para guardar la información actualizada
              // _updatePetInfo();

              // Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
