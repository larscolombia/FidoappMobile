import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/profile/screens/perfil_publico.dart';
import 'package:pawlly/modules/profile/screens/profile_screen.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class FormularioVerificacion extends StatelessWidget {
  const FormularioVerificacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Styles.colorContainer,
            ),
            child: const Center(
              child: Text(
                'Formulario de Verificación',
                style: Styles.TextTituloBlack,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: BarraBack(
                            titulo: 'Verificación Profesional',
                            callback: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) {},
                            label: 'Nombre',
                            placeholder: '',
                            placeholderFontFamily: 'lato',
                            prefiIcon: const Icon(
                              Icons.person,
                              color: Styles.iconColorBack,
                            ),
                            initialValue:
                                AuthServiceApis.dataCurrentUser.firstName,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) {},
                            label: 'Nombre',
                            placeholder: '',
                            prefiIcon: const Icon(
                              Icons.person,
                              color: Styles.iconColorBack,
                            ),
                            initialValue:
                                AuthServiceApis.dataCurrentUser.lastName,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) {},
                            label: 'Descripción sobre ti',
                            placeholder: '',
                            isTextArea: true,
                            initialValue: "",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Divider(
                              height: 1,
                              color: const Color.fromRGBO(158, 158, 158, 1)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputSelect(
                              onChanged: (value) {},
                              label: 'Áreas de especialización',
                              placeholder: 'Áreas de especialización',
                              TextColor: Colors.black,
                              prefiIcon: 'assets/icons/genero.png',
                              items: const [
                                DropdownMenuItem(
                                  value: 'vet',
                                  child: Text('Veterinario'),
                                ),
                                DropdownMenuItem(
                                  value: 'user',
                                  child: Text('Usuario'),
                                ),
                                DropdownMenuItem(
                                  value: 'trainer',
                                  child: Text('Entrenador'),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      /** 
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            isFilePicker: true,
                            onChanged: (value) {},
                            label:
                                'Título, certificación profesional o record de notas',
                            placeholder: '',
                            prefiIcon: const Icon(
                              Icons.file_copy_rounded,
                              color: Styles.iconColorBack,
                            ),
                          ),
                        ),
                      ),
                     
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            onChanged: (value) {},
                            label: 'Nro. de validación del certificado',
                            placeholder: '',
                            prefiIcon: const Icon(
                              Icons.card_travel_rounded,
                              color: Styles.iconColorBack,
                            ),
                            initialValue: '#',
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: InputText(
                            isFilePicker: true,
                            onChanged: (value) {},
                            label: 'Curriculum con experiencia profesional',
                            placeholder: '',
                            prefiIcon: const Icon(
                              Icons.file_copy_rounded,
                              color: Styles.iconColorBack,
                            ),
                          ),
                        ),
                      ),
                       */
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: ButtonDefaultWidget(
                                callback: () {
                                  Get.to(PublicProfilePage());
                                },
                                title: 'Previsualizar Perfil >',
                                defaultColor: Styles.fiveColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: ButtonDefaultWidget(
                                callback: () {},
                                title: 'Finalizar',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
