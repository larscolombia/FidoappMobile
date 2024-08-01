import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/titulo.dart';
import 'package:pawlly/routes/app_pages.dart';
import 'package:pawlly/screens_demo/privacy_policy.dart';
import 'package:pawlly/styles/styles.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

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
                'Términos y Condiciones',
                style: Styles.joinTitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ButtonDefaultWidget(
                  title: 'Términos y condiciones',
                  callback: () {
                    Get.toNamed(Routes.TERMSCONDITIONS);
                    // PrivacyPolicy();
                  },
                  defaultColor: Color.fromARGB(255, 252, 146, 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: ButtonDefaultWidget(
                  title: 'Políticas de privacidad',
                  callback: () {
                    Get.toNamed(Routes.PRIVACYPOLICY);
                    // PrivacyPolicy();
                  },
                  defaultColor: Color.fromARGB(255, 255, 255, 255),
                  border: BorderSide(color: Color.fromARGB(255, 247, 133, 28)),
                  textColor: Color.fromARGB(78, 0, 0, 50),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              const Divider(
                height: 16,
                color: Styles.greyDivider,
                thickness: 1,
              ),
              SizedBox(
                height: 26,
              ),
              Container(
                width: width,
                child: const Text(
                  'Términos y condiciones del uso de la App',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(83, 82, 81, 1),
                    fontSize: 14.00,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const NumTitle(
                Title: '1. Aceptación de los Términos ',
                Descripcion:
                    "Al descargar o utilizar la aplicación Fido App, usted acepta estar sujeto a estos términos y condiciones (T&C). Si no está de acuerdo con alguno de los términos, no descargue ni utilice esta aplicación.",
              ),
              const NumTitle(
                Title: '2. Cambios y Modificaciones',
                Descripcion:
                    "Fido App se reserva el derecho de modificar estos T&C en cualquier momento. Los cambios entrarán en vigor inmediatamente después de su publicación en la aplicación o en nuestro sitio web.",
              ),
              const NumTitle(
                Title: '3. Licencia de Uso',
                Descripcion:
                    "Se le concede una licencia limitada, no exclusiva e intransferible para utilizar Fido App únicamente para fines personales y no comerciales, sujeta a estos T&C.",
              ),
              const NumTitle(
                Title: '4. Propiedad Intelectual ',
                Descripcion:
                    "Todo el contenido de Fido App, incluyendo textos, gráficos, logos y software, es propiedad de “AppEjemplo” o sus licenciantes y está protegido por leyes de propiedad intelectual.",
              ),
              const NumTitle(
                Title: '4. Propiedad Intelectual ',
                Descripcion:
                    "Todo el contenido de Fido App, incluyendo textos, gráficos, logos y software, es propiedad de “AppEjemplo” o sus licenciantes y está protegido por leyes de propiedad intelectual.",
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: ButtonDefaultWidget(
                    title: 'Regresar',
                    callback: callabak,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class NumTitle extends StatelessWidget {
  final String Title;
  final String Descripcion;
  const NumTitle({super.key, required this.Title, required this.Descripcion});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(children: [
      Container(
        width: width,
        margin: EdgeInsets.only(top: 20),
        child: Text(
          Title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontFamily: 'Lato',
              color: Color.fromRGBO(83, 82, 81, 1),
              fontSize: 14.00,
              fontWeight: FontWeight.w800),
        ),
      ),
      Container(
          width: width,
          child: Text(
            Descripcion,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color.fromRGBO(83, 82, 81, 1),
              fontSize: 13.00,
              fontWeight: FontWeight.w500,
            ),
          ))
    ]);
  }
}
