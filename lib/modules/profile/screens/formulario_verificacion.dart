import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/input_select.dart';
import 'package:pawlly/modules/components/input_text.dart';
import 'package:pawlly/modules/components/regresr_components.dart';
import 'package:pawlly/modules/components/style.dart';
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
                          prefiIcon: const Icon(
                            Icons.person,
                            color: Styles.iconColorBack,
                          ),
                          initialValue:
                              AuthServiceApis.dataCurrentUser.firstName,
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
                          prefiIcon: const Icon(
                            Icons.person,
                            color: Styles.iconColorBack,
                          ),
                          initialValue:
                              AuthServiceApis.dataCurrentUser.lastName,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: InputSelect(
                            onChanged: (value) {},
                            label: 'Áreas de especialización',
                            placeholder: 'Áreas de especialización',
                            TextColor: Colors.black,
                            prefiIcon: const Icon(
                              Icons.person,
                              color: Styles.iconColorBack,
                            ),
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
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: ButtonDefaultWidget(
                          callback: () {},
                          title: 'Evnviar',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
