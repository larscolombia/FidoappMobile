import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';

class InAppBrowserModal extends StatelessWidget {
  final String url;

  const InAppBrowserModal({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 500, // puedes ajustar la altura según tus necesidades
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(url)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                ),
                onConsoleMessage: (controller, consoleMessage) {
                  print("Consola Web: ${consoleMessage.message}");
                },
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
            },
            child: Expanded(
              child: ButtonDefaultWidget(
                title: 'Cerrar',
                defaultColor:
                    const Color(0xFFFC9214), // Color de fondo del botón
                textColor: Styles.whiteColor, // Color del texto del botón
                heigthButtom: 48, // Altura del botón
                borderSize: 12, // Tamaño del borde
                showDecoration: true, // Mostrar decoración
              ),
            ),
          ),
        ],
      ),
    );
  }
}
