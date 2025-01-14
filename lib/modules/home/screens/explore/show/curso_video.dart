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
import 'package:pawlly/modules/home/screens/explore/show/cursos_detalles.dart';
import 'package:pawlly/modules/home/screens/explore/show/video_player.dart';
import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/curso_usuario_controller.dart';
import 'package:pawlly/modules/integracion/controller/cursos/cursos_controller.dart';
import 'package:pawlly/services/auth_service_apis.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

// CursoVideo
class CursoVideo extends StatelessWidget {
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

  final CommentController _commentController = Get.put(CommentController());
  var cursoController = Get.put(CursoUsuarioController());
  @override
  Widget build(BuildContext context) {
    // Llamamos a la función fetchComments solo después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tipovideo == "blogs") {
        _commentController.fetchComments(cursoId, "blog");
        _commentController.updateField('blog_id', cursoId);
      } else if (tipovideo == "video") {
        _commentController.fetchComments(cursoId, "video");
        _commentController.updateField('course_platform_video_id', cursoId);
      }
    });
    print('videourl $videoId');
    return Scaffold(
      body: Column(
        children: [
          // Contenedor para el video
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: VideoPlayerScreen(
              videoUrl: videoUrl,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Barra de regreso y título
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: BarraBack(
                        titulo: name,
                        color: Colors.black,
                        callback: () {
                          Get.back();
                        },
                      ),
                    ),
                    // Fecha de creación
                    SizedBox(
                      width: 305,
                      child: Text(
                        dateCreated ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: "lato",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Descripción
                    const SizedBox(
                      width: 305,
                      child: Text(
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
                      width: 305,
                      child: Text(description, style: Styles.textDescription),
                    ),
                    const SizedBox(height: 20),
                    // Botón de compartir
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: BotonCompartir(
                        modo: "compartir",
                        onCompartir: () {
                          Share.share(
                            '¡Hola! Este es un mensaje compartido desde mi app Flutter.',
                            subject: 'Compartir Mensaje',
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Comentario (InputTextWithIcon) solo envuelto en Obx si es necesario
                    if (tipovideo == "video")
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: GestureDetector(
                            onTap: () {
                              print('tipo de video ${tipovideo} :: $videoId');
                              cursoController.updateVideoAsWatched(
                                userId: AuthServiceApis.dataCurrentUser.id,
                                coursePlatformId: int.parse(cursoId),
                                coursePlatformVideoId: int.parse(cursoId),
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
                                  child: Text('Marca como visto'),
                                ),
                              ],
                            )),
                      ),
                    const SizedBox(height: 20),
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
                          ),
                          const SizedBox(height: 20),
                          BanerComentarios(
                            eventTextChanged: (value) {
                              _commentController.updateField(
                                  'review_msg', value);
                            },
                            titulo: 'Tu experiencia',
                            onRatingUpdate: (rating) {
                              _commentController.updateField('rating', rating);
                            },
                            onEvento: () {
                              _commentController.updateField(
                                  'course_platform_video_id', cursoId);
                              if (tipovideo == 'video') {
                                _commentController.postComment(
                                    'video', context);
                              } else {
                                _commentController.postComment('blog', context);
                              }
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
                    const SizedBox(height: 20),
                    // Título "Comentarios"
                    const SizedBox(
                      width: 304,
                      child: Text(
                        'Comentarios',
                        style: Styles.TextTitulo,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Listado de comentarios envuelto en Obx
                    Obx(() {
                      if (_commentController.comments.isEmpty) {
                        return const Center(
                          child: Text('No hay comentarios'),
                        );
                      }
                      if (_commentController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
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
                    const SizedBox(height: 20),
                    // Componente para recargar comentarios
                    RecargaComponente(
                      callback: () {
                        if (tipovideo == "blogs") {
                          _commentController.fetchComments(cursoId, "blog");
                        }
                        if (tipovideo == "video") {
                          _commentController.fetchComments(cursoId, "video");
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
    );
  }
}
