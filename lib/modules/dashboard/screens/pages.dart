import 'package:flutter/material.dart';

class MiPerfilPage extends StatelessWidget {
  const MiPerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: const Center(
        child: Text('Contenido de Mi Perfil'),
      ),
    );
  }
}

class MascotasPage extends StatelessWidget {
  const MascotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas'),
      ),
      body: const Center(
        child: Text('Contenido de Mascotas'),
      ),
    );
  }
}

class TerminosCondicionesPage extends StatelessWidget {
  const TerminosCondicionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: const Center(
        child: Text('Contenido de Términos y Condiciones'),
      ),
    );
  }
}

class PoliticasPrivacidadPage extends StatelessWidget {
  const PoliticasPrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Políticas de Privacidad'),
      ),
      body: const Center(
        child: Text('Contenido de Políticas de Privacidad'),
      ),
    );
  }
}

class SobreAppPage extends StatelessWidget {
  const SobreAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre la App'),
      ),
      body: const Center(
        child: Text('Contenido de Sobre la App'),
      ),
    );
  }
}

class CerrarSesionPage extends StatelessWidget {
  const CerrarSesionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerrar Sesión'),
      ),
      body: const Center(
        child: Text('Contenido de Cerrar Sesión'),
      ),
    );
  }
}
