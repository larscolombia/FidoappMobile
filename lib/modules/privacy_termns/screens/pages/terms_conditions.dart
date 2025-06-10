import 'package:flutter/material.dart';
import 'package:pawlly/components/app_scaffold.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/generated/config.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/modules/privacy_termns/screens/pages/privacy_policy.dart';
import 'package:pawlly/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return AppScaffold(
      body: Container(
        padding: Styles.paddingAll,
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _launchTermsUrl,
                behavior: HitTestBehavior.translucent, // para asegurar que el toque funcione
                child: Text(
                  locale.value.termsAndConditionsTitle,
                  style: Styles.joinTitle, // sin subrayado ni color azul
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: const Divider(
                  thickness: 0.5, // Make the line thicker
                  color: Color.fromARGB(255, 182, 164, 137), // Change the line color
                ),
              ),
              const NumTitle(
                Title: 'Términos y condiciones del uso de ${Config.NameApp}',
                Descripcion: '',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchTermsUrl() async {
    final url = Uri.parse('https://www.myfidoapp.com/privacidad');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // abre en el navegador externo
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }
}

class NumTitle extends StatelessWidget {
  final String Title;
  final String Descripcion;
  const NumTitle({super.key, required this.Title, required this.Descripcion});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(children: [
      Container(
        width: width,
        margin: const EdgeInsets.only(top: 20),
        child: Text(
          Title,
          textAlign: TextAlign.start,
          style: const TextStyle(fontFamily: 'Lato', color: Color.fromRGBO(83, 82, 81, 1), fontSize: 14.00, fontWeight: FontWeight.w800),
        ),
      ),
      SizedBox(
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
