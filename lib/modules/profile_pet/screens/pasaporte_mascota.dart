import 'package:flutter/material.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';

class PasaporteMascota extends StatelessWidget {
  final String? name;
  final String? fechaNacimiento;
  final String? imageUrl;
  final String? raza;
  final String? sexo;
  final String? peso;
  final String? edad;
  PasaporteMascota(
      {super.key,
      this.name,
      this.fechaNacimiento,
      this.imageUrl,
      this.raza,
      this.sexo,
      this.peso,
      this.edad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Ajusta la altura del encabezado
              color: Styles.colorContainer, // Color del encabezado
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pasaporte Canino', // Título del encabezado
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Veriifica la información', // Título del encabezado
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 150, // Ajusta esta posición para la superposición
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, // Fondo blanco del contenedor inferior
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        30), // Redondear la parte superior izquierda
                    topRight: Radius.circular(
                        30), // Redondear la parte superior derecha
                  ),
                ),
                child: Column(
                  children: [
                    BarraBack(
                      callback: () {},
                      titulo: 'Información del Perro',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Especie',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Sexo',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Raza',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Fecha de nacimiento',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Color del pelaje',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Marcas distintivas',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Adjuntar archivo',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Nombre',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: InputText(
                        label: 'Adjuntar archivo',
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 305,
                      child: Text('Datos de Vacunación y Tratamientos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Styles.primaryColor,
                            fontFamily: 'Lato',
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
