import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/avatar_comentario.dart';
import 'package:pawlly/modules/components/baner_comentarios.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/styles/recursos.dart';

class CommentsSection extends StatefulWidget {
  final String id;
  final bool expert;

  const CommentsSection({super.key, required this.id, this.expert = true});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final CommentController comentariosController = Get.put(CommentController());

  @override
  void initState() {
    super.initState();

    // Cargar comentarios
    comentariosController.fetchComments(widget.id, "user").then((_) {
      setState(() {}); // Actualizar la UI después de cargar los datos
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final GlobalKey _commentsKey = GlobalKey();

    return Obx(() {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar estadísticas solo cuando haya comentarios

            Padding(
              padding: Styles.paddingAll,
              child: Center(
                child: Estadisticas(
                    comentarios: comentariosController.comments.length.toString(),
                    calificacion: '${comentariosController.calculateAverageRating()}',
                    avatars: comentariosController.getTopAvatars(),
                    onComentariosPressed: () {
                      Scrollable.ensureVisible(
                        _commentsKey.currentContext!,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    }),
              ),
            ),
            const SizedBox(height: 10),
            if (widget.expert)
              Padding(
                padding: Styles.paddingAll,
                child: BanerComentarios(
                  eventTextChanged: (value) {
                    comentariosController.updateField('review_msg', value);
                  },
                  titulo: 'Tu experiencia',
                  onRatingUpdate: (rating) {
                    comentariosController.updateField('rating', rating);
                  },
                  onEvento: () async {
                    comentariosController.updateField('employee_id', widget.id);
                    await comentariosController.postComment('user', context);
                  },
                ),
              ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: Styles.paddingAll,
                width: MediaQuery.sizeOf(context).width,
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
            const SizedBox(height: 5),
            Center(
              child: Container(
                padding: Styles.paddingAll,
                width: MediaQuery.sizeOf(context).width,
                child: const Divider(color: Recursos.ColorBorderSuave, thickness: 1),
              ),
            ),
            Center(
              child: Container(
                key: _commentsKey,
                padding: Styles.paddingAll,
                width: MediaQuery.sizeOf(context).width,
                child: Obx(() {
                  if (comentariosController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: comentariosController.comments.map((value) {
                        return Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: AvatarComentarios(
                            avatar: value.userAvatar ?? "https://www.thewall360.com/uploadImages/ExtImages/images1/def-638240706028967470.jpg",
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
            const SizedBox(height: 40),
            Center(
              child: RecargaComponente(
                callbackAsync: () async {
                  await comentariosController.fetchComments(widget.id, "user");
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }
}
