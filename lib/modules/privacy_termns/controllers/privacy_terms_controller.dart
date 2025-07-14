import 'package:get/get.dart';
import 'package:pawlly/generated/config.dart';

class PrivacyTermsController extends GetxController {
  var selectedTab =
      0.obs; // 0: Políticas de Privacidad, 1: Términos y Condiciones
  var title = ''.obs;
  var content = <NumTitleData>[].obs;

  final List<NumTitleData> privacyPolicyContent = [
    NumTitleData(
      title: '¡Políticas de Privacidad de ${Config.NameApp}!',
      description: '',
    ),
    NumTitleData(
      title: '1. Introducción',
      description:
          'En ${Config.NameApp}, respetamos su privacidad y estamos comprometidos con protegerla a través de nuestro cumplimiento de estas políticas.',
    ),
    NumTitleData(
      title: '2. Información que Recopilamos',
      description:
          'Podemos recopilar información personal que incluye, pero no se limita a, su nombre, dirección, correo electrónico, número de teléfono y detalles de pago.',
    ),
    NumTitleData(
      title: '3. Cómo Utilizamos su Información',
      description:
          'Utilizamos la información recopilada para procesar transacciones, proporcionar soporte al cliente, mejorar nuestros servicios y cumplir con obligaciones legales.',
    ),
    NumTitleData(
      title: '4. Compartir su Información',
      description:
          'No compartiremos su información personal con terceros, excepto como sea necesario para proporcionar nuestros servicios o como lo exija la ley.',
    ),
    NumTitleData(
      title: '5. Seguridad de la Información',
      description:
          'Implementamos medidas de seguridad para proteger su información personal contra el acceso no autorizado, alteración, divulgación o destrucción.',
    ),
    NumTitleData(
      title: '6. Sus Derechos',
      description:
          'Usted tiene derecho a acceder, corregir o eliminar su información personal que tenemos en archivo.',
    ),
    NumTitleData(
      title: '7. Cambios a las Políticas de Privacidad',
      description:
          'Nos reservamos el derecho de modificar estas políticas en cualquier momento. Cualquier cambio será efectivo inmediatamente después de su publicación en nuestro sitio web.',
    ),
    NumTitleData(
      title: '8. Contacto',
      description:
          'Si tiene preguntas o comentarios sobre estas políticas, por favor contáctenos en https://www.myfidoapp.com/.',
    ),
    // Agrega aquí cualquier otro ítem necesario
  ];

  final List<NumTitleData> termsConditionsContent = [
    NumTitleData(
      title: 'Términos y condiciones del uso de ${Config.NameApp}',
      description: '',
    ),
    NumTitleData(
      title: '1. Aceptación de los Términos',
      description:
          "Al descargar o utilizar la aplicación Fido App, usted acepta estar sujeto a estos términos y condiciones (T&C). Si no está de acuerdo con alguno de los términos, no descargue ni utilice esta aplicación.",
    ),
    NumTitleData(
      title: '2. Cambios y Modificaciones',
      description:
          "Fido App se reserva el derecho de modificar estos T&C en cualquier momento. Los cambios entrarán en vigor inmediatamente después de su publicación en la aplicación o en nuestro sitio web.",
    ),
    NumTitleData(
      title: '3. Licencia de Uso',
      description:
          "Se le concede una licencia limitada, no exclusiva e intransferible para utilizar Fido App únicamente para fines personales y no comerciales, sujeta a estos T&C.",
    ),
    NumTitleData(
      title: '4. Propiedad Intelectual',
      description:
          "Todo el contenido de Fido App, incluyendo textos, gráficos, logos y software, es propiedad de “AppEjemplo” o sus licenciantes y está protegido por leyes de propiedad intelectual.",
    ),
    // Asegúrate de eliminar los ítems duplicados o innecesarios.
    // Aquí puedes agregar más datos si es necesario
  ];

  @override
  void onInit() {
    super.onInit();
    // Inicializa `selectedTab` a 1
    changeTab(1); // Llama al método para configurar el tab inicial
  }

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 0) {
      title.value = 'Políticas de Privacidad';
      content.value = privacyPolicyContent;
    } else {
      title.value = 'Términos y Condiciones';
      content.value = termsConditionsContent;
    }
  }
}

class NumTitleData {
  final String title;
  final String description;

  NumTitleData({required this.title, required this.description});
}
