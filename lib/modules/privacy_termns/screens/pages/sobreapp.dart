import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/generated/config.dart';
import 'package:pawlly/styles/styles.dart';

class SobreApp extends StatelessWidget {
  const SobreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      body: Container(
        padding: Styles.paddingAll,
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Bienvenido a\n${Config.NameApp}',
                style: Styles.joinTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'La herramienta diseñada para acompañarte en cada etapa de la vida de tu perro. Desde el primer día en casa hasta su entrenamiento y cuidado diario, aquí encontrarás todo lo que necesitas para garantizar su bienestar de manera sencilla y organizada.',
                style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF383838)),
              ),
              const SizedBox(height: 20),
              _buildFeature(
                title: 'Crear y gestionar el perfil de tu perro',
                description:
                    'Guarda toda su información en un solo lugar: nombre, edad, raza, historial de salud, entrenamientos y más.',
              ),
              _buildFeature(
                title: 'Sincronizar y organizar eventos',
                description:
                    'Agenda citas con el veterinario, recordatorios de vacunas, sesiones de entrenamiento y cualquier evento importante con nuestro calendario inteligente.',
              ),
              _buildFeature(
                title: 'Acceder a herramientas de entrenamiento',
                description:
                    'Utiliza clickers y silbatos virtuales, sigue guías paso a paso y mejora la comunicación con tu perro mediante técnicas efectivas de educación canina.',
              ),
              _buildFeature(
                title: 'Conectar con veterinarios y entrenadores',
                description:
                    'Encuentra expertos en salud y educación canina, agenda consultas y mantén un seguimiento profesional de la evolución de tu perro.',
              ),
              _buildFeature(
                title: 'Explorar una biblioteca de recursos',
                description:
                    'Aprende sobre razas, nutrición, primeros auxilios y comportamiento con artículos, e-books y cursos en video creados por especialistas.',
              ),
              _buildFeature(
                title: 'Llevar un control de la salud de tu perro',
                description:
                    'Mantén un historial clínico actualizado con vacunas, desparasitaciones, tratamientos y cualquier dato relevante que puedas compartir con tu veterinario.',
              ),
              _buildFeature(
                title: 'Personalizar la experiencia',
                description:
                    'Desde recordatorios hasta comandos de entrenamiento favoritos, ajusta ${Config.NameApp} a tus necesidades y las de tu perro.',
              ),
              const SizedBox(height: 30),
              _buildFeature(
                title: '📲 Un compañero digital para una vida mejor',
                description:
                    '${Config.NameApp} está diseñada para hacer tu vida más fácil y garantizar el mejor cuidado para tu perro. Ya sea que estés entrenando a un cachorro, gestionando la salud de un perro adulto o buscando recursos para mejorar su bienestar, aquí encontrarás todo lo que necesitas.',
                applyCheck: false,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ButtonDefaultWidget(
                  title: 'Regresar',
                  callback: () => Get.back(),
                  showDecoration: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required String title,
    required String description,
    bool applyCheck = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${applyCheck ? '✔ ' : ''}$title',
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF383838),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF383838),
            ),
          ),
        ],
      ),
    );
  }
}
