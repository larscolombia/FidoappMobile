import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/controller/comentarios/ranting_controller.dart';
import 'package:pawlly/modules/pet_owner_profile/controllers/pet_owner_profile_controller.dart';
import 'package:pawlly/styles/styles.dart';

class ProfileDetails extends StatefulWidget {
  final PetOwnerProfileController controller;
  final UserProfileController profileController;
  final String id;

  const ProfileDetails({
    Key? key,
    required this.controller,
    required this.profileController,
    required this.id,
  }) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late final CommentController comentariosController =
      Get.put(CommentController());

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
    return Obx(() {
      if (widget.profileController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Column(
        children: [
          Container(
            padding: Styles.paddingAll,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      // Lógica para ir al perfil de usuario
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Styles.iconColorBack,
                      size: 20,
                    ),
                  ),
                ),
                if (widget.profileController.user.value.address != null &&
                    widget.profileController.user.value.address!.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Styles.primaryColor,
                            size: 20,
                          ),
                          Text(
                            widget.profileController.user.value.address ?? "",
                            style: const TextStyle(
                              color: Styles.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: Styles.paddingAll,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.profileController.user.value.firstName ?? "",
                          style: Styles.dashboardTitle20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: Styles.paddingAll,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.profileController.user.value.firstName ?? "",
                            style: Styles.dashboardTitle20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          widget.profileController.user.value.userType == "user"
              ? SizedBox.shrink()
              : Text(
                  widget.profileController.user.value.userType == "vet"
                      ? "Veterinario"
                      : "Entrenador",
                  style: const TextStyle(
                    color: Color(0xff555555),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
          const SizedBox(height: 10),
          widget.profileController.user.value.userType == "user"
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating:
                          comentariosController.calculateAverageRating(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemSize: 20.0,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Styles.iconColorBack,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.controller.rating.value.toString(),
                      style: Styles.secondTextTitle,
                    ),
                  ],
                ),
        ],
      );
    });
  }
}
