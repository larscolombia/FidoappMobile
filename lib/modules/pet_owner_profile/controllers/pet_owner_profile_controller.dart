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
  var description = 'Descripción del usuario aquí... Esta es una breve descripción de la persona asociada.'.obs;
  var veterinarianLinked = true.obs; // Condición si está vinculado
  var specializationArea = 'Cirugía'.obs; // Área de especialización principal
  var otherAreas = ['Cardiología', 'Dermatología', 'Oftalmología'].obs; // Lista de otras áreas de especialización
  var commentCount = 456.obs; // Número de comentarios
  var commenterImages = [
    'https://example.com/img1.jpg',
    'https://example.com/img2.jpg',
    'https://example.com/img3.jpg',
    'https://example.com/img4.jpg',
    'https://example.com/img5.jpg'
  ].obs; // Lista de URLs de imágenes de los comentaristas
}
