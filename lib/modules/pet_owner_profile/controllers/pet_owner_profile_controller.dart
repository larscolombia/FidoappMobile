import 'package:get/get.dart';

class PetOwnerProfileController extends GetxController {
  var ownerName = 'Juan Pérez'.obs;
  var email = 'juan.perez@example.com'.obs;
  var phone = '+1 809 555 5555'.obs;
  var address = 'Av. Independencia, Santo Domingo, R.D.'.obs;
  var profileImagePath = ''.obs;
  var relation = 'Dueño'.obs;
  var rating = 4.5.obs; // Clasificación
  var userType = 'Veterinario'.obs; // Tipo de usuario
  var description =
      'Descripción del usuario aquí... Esta es una breve descripción de la persona asociada.'
          .obs;
  var veterinarianLinked = true.obs; // Condición si está vinculado
  var specializationArea = 'Cirugía'.obs; // Área de especialización principal
  var otherAreas = ['Cardiología', 'Dermatología', 'Oftalmología']
      .obs; // Lista de otras áreas de especialización
  var commentCount = 456.obs; // Número de comentarios
  var commenterImages = [
    'https://example.com/img1.jpg',
    'https://example.com/img2.jpg',
    'https://example.com/img3.jpg',
    'https://example.com/img4.jpg',
    'https://example.com/img5.jpg'
  ].obs; // Lista de URLs de imágenes de los comentaristas

  // Datos dummy de comentarios
  var comments = [
    {
      'image': 'https://example.com/img1.jpg',
      'name': 'Ana López',
      'rating': 4.5,
      'comment': 'Excelente servicio y atención.'
    },
    {
      'image': 'https://example.com/img2.jpg',
      'name': 'Carlos Gómez',
      'rating': 5.0,
      'comment': 'Muy satisfecho con el trato recibido.'
    },
    {
      'image': 'https://example.com/img3.jpg',
      'name': 'María Martínez',
      'rating': 4.0,
      'comment': 'Todo bien, aunque el tiempo de espera fue algo largo.'
    },
    {
      'image': 'https://example.com/img4.jpg',
      'name': 'Pedro Sánchez',
      'rating': 5.0,
      'comment': 'Increíble servicio, altamente recomendado.'
    },
    {
      'image': 'https://example.com/img5.jpg',
      'name': 'Lucía Fernández',
      'rating': 4.8,
      'comment': 'Gran atención al detalle y profesionalismo.'
    }
  ].obs;
}
