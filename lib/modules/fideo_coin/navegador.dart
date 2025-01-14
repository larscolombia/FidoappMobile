import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppBrowserModal extends StatelessWidget {
  final String url;

  const InAppBrowserModal({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos un AlertDialog para mostrar el contenido del navegador
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        height: 500, // puedes ajustar la altura según tus necesidades
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
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el modal
          },
          child: const Text("Cerrar"),
        )
      ],
    );
  }
}
