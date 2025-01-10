import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pawlly/modules/components/avatar_comentario.dart';
import 'package:pawlly/modules/components/baner_comentarios.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';

class CommentsSection extends StatelessWidget {
  final String id;
  final PetOwnerProfileController controller =
      Get.put(PetOwnerProfileController());
  final CommentController comentariosController = Get.put(CommentController());
  CommentsSection({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    comentariosController.fetchComments(id, "user"); // pisa papel comentarios
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: BanerComentarios(
            eventTextChanged: (value) {
              comentariosController.updateField('review_msg', value);
            },
            titulo: 'Tu experiencia',
            onRatingUpdate: (rating) {
              comentariosController.updateField('rating', rating);
            },
            onEvento: () {
              comentariosController.updateField('employee_id', id);

              comentariosController.postComment('user', context);
            },
          ),
        ),
        const SizedBox(height: 20), // Espaciado entre secciones
        // Sección de comentarios lista
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: const Text(
              'Comentarios',
              style: TextStyle(
                color: Styles.primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'PoetsenOne',
                fontSize: 20,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
              width: MediaQuery.of(context).size.width - 100,
              child: const Divider(color: Colors.grey, thickness: .3)),
        ),
        Center(
          child: RecargaComponente(
            callback: () {
              comentariosController.fetchComments(id, "user");
            },
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            child: Obx(() {
              if (comentariosController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: comentariosController.comments.map((value) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: AvatarComentarios(
                        avatar: value.userAvatar ??
                            "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg",
                        name: value.userFullName ?? '',
                        date: "Fecha",
                        comment: value.reviewMsg,
                        rating: double.parse(value.rating.toString()),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
