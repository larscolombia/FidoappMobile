import 'package:flutter/material.dart';

class MiPerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Center(
        child: Text('Contenido de Mi Perfil'),
      ),
    );
  }
}

class MascotasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mascotas'),
      ),
      body: Center(
        child: Text('Contenido de Mascotas'),
      ),
    );
  }
}

class TerminosCondicionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      body: Center(
        child: Text('Contenido de Términos y Condiciones'),
      ),
    );
  }
}

class PoliticasPrivacidadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Políticas de Privacidad'),
      ),
      body: Center(
        child: Text('Contenido de Políticas de Privacidad'),
      ),
    );
  }
}

class SobreAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre la App'),
      ),
      body: Center(
        child: Text('Contenido de Sobre la App'),
      ),
    );
  }
}

class CerrarSesionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerrar Sesión'),
      ),
      body: Center(
        child: Text('Contenido de Cerrar Sesión'),
      ),
    );
  }
}
