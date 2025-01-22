import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/titulo.dart';
import 'package:pawlly/generated/config.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/modules/privacy_termns/screens/pages/terms_conditions.dart';
import 'package:pawlly/styles/styles.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AppScaffold(
      body: Container(
        padding: Styles.paddingAll,
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                locale.value.privacyPolicy,
                style: Styles.joinTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: ButtonDefaultWidget(
                  title: locale.value.privacyPolicy,
                  callback: () {
                    // TermsConditions();
                  },
                  defaultColor: const Color.fromARGB(255, 252, 146, 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: const Divider(
                  thickness: 0.5, // Make the line thicker
                  color: Color.fromARGB(
                      255, 182, 164, 137), // Change the line color
                ),
              ),
              Column(
                children: [
                  const NumTitle(
                    Title: '¡Políticas de Privacidad de ${Config.NameApp}',
                    Descripcion: '',
                  ),
                  const NumTitle(
                    Title: '1. Introducción',
                    Descripcion:
                        'En ${Config.NameApp}, respetamos su privacidad y estamos comprometidos con protegerla a través de nuestro cumplimiento de estas políticas.',
                  ),
                  const NumTitle(
                    Title: '2. Información que Recopilamos',
                    Descripcion:
                        'Podemos recopilar información personal que incluye, pero no se limita a, su nombre, dirección, correo electrónico, número de teléfono y detalles de pago.',
                  ),
                  const NumTitle(
                    Title: '3. Cómo Utilizamos su Información',
                    Descripcion:
                        'Utilizamos la información recopilada para procesar transacciones, proporcionar soporte al cliente, mejorar nuestros servicios y cumplir con obligaciones legales.',
                  ),
                  const NumTitle(
                    Title: '4. Compartir su Información',
                    Descripcion:
                        'No compartiremos su información personal con terceros, excepto como sea necesario para proporcionar nuestros servicios o como lo exija la ley.',
                  ),
                  const NumTitle(
                    Title: '5. Seguridad de la Información',
                    Descripcion:
                        'Implementamos medidas de seguridad para proteger su información personal contra el acceso no autorizado, alteración, divulgación o destrucción.',
                  ),
                  const NumTitle(
                    Title: '6. Sus Derechos',
                    Descripcion:
                        'Usted tiene derecho a acceder, corregir o eliminar su información personal que tenemos en archivo.',
                  ),
                  const NumTitle(
                    Title: '7. Cambios a las Políticas de Privacidad',
                    Descripcion:
                        'Nos reservamos el derecho de modificar estas políticas en cualquier momento. Cualquier cambio será efectivo inmediatamente después de su publicación en nuestro sitio web.',
                  ),
                  const NumTitle(
                    Title: '8. Contacto',
                    Descripcion:
                        'Si tiene preguntas o comentarios sobre estas políticas, por favor contáctenos en [correo electrónico/ número de teléfono].',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const ButtonDefaultWidget(
                      title: 'Regresar',
                      callback: callabak,
                      showDecoration: true,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void terminos_y_condiciones() {
  Get.toNamed(Routes.TERMSCONDITIONS);
  // Get.to(TermsConditions());
}

void callabak() {
  Get.back();
}
