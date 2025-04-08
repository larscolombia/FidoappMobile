import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/components/avatar_comentario.dart';
import 'package:pawlly/modules/components/baner_comentarios.dart';
import 'package:pawlly/modules/components/boton_compartir.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/helper/helper.dart';
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/home/screens/explore/show/video_player.dart';
import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

// CursoVideo
class CursoVideo extends StatefulWidget {
  final String videoId;
  final String cursoId;
  final String name;
  final String description;
  final String image;
  final String duration;
  final String price;
  final String difficulty;
  final String videoUrl;
  final String tipovideo;
  final String? dateCreated;

  CursoVideo({
    super.key,
    required this.videoId,
    required this.cursoId,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.price,
    required this.difficulty,
    required this.videoUrl,
    required this.tipovideo,
    this.dateCreated,
  });

  @override
  State<CursoVideo> createState() => _CursoVideoState();
}

class _CursoVideoState extends State<CursoVideo> {
  final CommentController _commentController = Get.put(CommentController());

  var cursoController = Get.put(CursoUsuarioController());

  @override
  void initState() {
    if (widget.tipovideo == "blogs") {
      _commentController.fetchComments(widget.cursoId, "blog");
      _commentController.updateField('blog_id', widget.cursoId);
    } else if (widget.tipovideo == "video") {
      _commentController.fetchComments(widget.cursoId, "video");
      _commentController.updateField(
          'course_platform_video_id', widget.cursoId);
    }
    _commentController.visualizaciones(widget.cursoId);
  }

  @override
  Widget build(BuildContext context) {
    // Llamamos a la función fetchComments solo después de que el widget se haya construido
    var width = MediaQuery.of(context).size.width;
    var margen = Helper.margenDefault;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        child: Column(
          children: [
            // Contenedor para el video
            Container(
              height: width,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: VideoPlayerScreen(
                videoUrl: widget.videoUrl,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Helper.paddingDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Barra de regreso y título
                      SizedBox(
                        height: margen,
                      ),
                      SizedBox(
                        width: width,
                        child: BarraBack(
                          fontFamily: 'Lato',
                          titulo: widget.name,
                          color: Colors.black,
                          callback: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(
                        height: margen,
                      ),
                      // Fecha de creación
                      SizedBox(
                        width: width,
                        child: Row(
                          children: [
                            Text(
                              Helper.formatDateToSpanish(widget.dateCreated),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontFamily: "lato",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Obx(
                              () => Text(
                                " | ${_commentController.visualizacion} visualizaciones",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: "lato",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Descripción
                      SizedBox(
                        width: width,
                        child: const Text(
                          "Descripción",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "lato",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: width,
                        child: Text(
                          widget.description,
                          style: Styles.textDescription,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botón de compartir
                      /**
                        SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: BotonCompartir(
                          modo: "compartir",
                          onCompartir: () {
                          // Nombre de la aplicación
                          final String appName = "Balance Dog";
                          // Título del video a compartir
                          final String videoTitle = widget.name;

                          // URL que se compartirá
                          final String shareableUrl = widget.videoUrl;

                          // Construye el mensaje que se compartirá, incluyendo título y URL
                          final String shareMessage =
                            "¡Mira \"$videoTitle\" en $appName!\n\n"
                            "$shareableUrl";

                          // Usa el plugin share_plus para mostrar el diálogo de compartir
                          Share.share(
                            shareMessage,
                            subject: "Video de Balance Dog: $videoTitle",
                          );
                          },
                        ),
                        ),*/
                      SizedBox(height: margen),
                      // Comentario (InputTextWithIcon) solo envuelto en Obx si es necesario
                      /**
                      if (widget.tipovideo == "video")
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: GestureDetector(
                              onTap: () {
                                print(
                                    'tipo de video ${widget.tipovideo} :: ${widget.videoId}');
                                cursoController.updateVideoAsWatched(
                                  userId: AuthServiceApis.dataCurrentUser.id,
                                  coursePlatformId: int.parse(widget.cursoId),
                                  coursePlatformVideoId:
                                      int.parse(widget.cursoId),
                                  watched: true,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    'assets/icons/palomiar.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const SizedBox(
                                    child: Text('Marcar como visto'),
                                  ),
                                ],
                              )),
                        ),
                       */
                      SizedBox(height: margen),
                      Obx(() {
                        if (_commentController.isComentarioPosrLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: [
                            Estadisticas(
                              comentarios:
                                  '${_commentController.comments.length} ',
                              calificacion:
                                  "${_commentController.calculateAverageRating().toStringAsFixed(2)}",
                              avatars: _commentController.getTopAvatars(),
                            ),
                            SizedBox(height: margen),
                            BanerComentarios(
                              eventTextChanged: (value) {
                                _commentController.updateField(
                                    'review_msg', value);
                              },
                              titulo: 'Tu experiencia',
                              onRatingUpdate: (rating) {
                                _commentController.updateField(
                                    'rating', rating);
                              },
                              onEvento: () {
                                _commentController.updateField(
                                    'course_platform_video_id', widget.cursoId);
                                if (widget.tipovideo == 'video') {
                                  _commentController.postComment(
                                      'video', context);
                                } else {
                                  _commentController.postComment(
                                      'blog', context);
                                }

                                setState(() {
                                  if (widget.tipovideo == "blogs") {
                                    _commentController.fetchComments(
                                        widget.cursoId, "blog");
                                    _commentController.updateField(
                                        'blog_id', widget.cursoId);
                                  } else if (widget.tipovideo == "video") {
                                    _commentController.fetchComments(
                                        widget.cursoId, "video");
                                    _commentController.updateField(
                                        'course_platform_video_id',
                                        widget.cursoId);
                                  }
                                });
                              },
                            ),
                            /** 
                            SizedBox(
                              width: 305,
                              child: InputTextWithIcon(
                                hintText: 'Escribe un comentario',
                                iconPath: 'assets/icons/send.png',
                                iconPosition: IconPosition.right,
                                height: 60.0,
                                onChanged: (value) {
                                  _commentController.updateField(
                                      'review_msg', value);
                                },
                                callbackButton: true,
                                onButtonPressed: () {
                                  if (tipovideo == "video") {
                                    _commentController.postComment('video');
                                  } else {
                                    _commentController.postComment('blog');
                                  }
                                },
                              ),
                            ),*/
                          ],
                        );
                      }),
                      SizedBox(height: margen),
                      // Título "Comentarios"
                      SizedBox(
                        width: width,
                        child: const Text(
                          'Comentarios',
                          style: Styles.TextTitulo,
                        ),
                      ),
                      SizedBox(height: margen),
                      // Listado de comentarios envuelto en Obx
                      Obx(() {
                        if (_commentController.comments.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay comentarios.',
                              style: TextStyle(
                                color: Color(0xFF959595),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        if (_commentController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _commentController.comments.map((value) {
                              print('comentarios value ${value.reviewMsg}');
                              return AvatarComentarios(
                                avatar: value.userAvatar,
                                name: value.userFullName,
                                date: "Fecha",
                                comment: value.reviewMsg,
                                rating: double.parse(value.rating.toString()),
                              );
                            }).toList(),
                          ),
                        );
                      }),
                      SizedBox(height: 10),
                      // Componente para recargar comentarios
                      RecargaComponente(
                        callback: () {
                          if (widget.tipovideo == "blogs") {
                            _commentController.fetchComments(
                                widget.cursoId, "blog");
                          }
                          if (widget.tipovideo == "video") {
                            _commentController.fetchComments(
                                widget.cursoId, "video");
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
