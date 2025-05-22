import 'package:flutter/material.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppBrowserModal extends StatefulWidget {
  // Cambiado a StatefulWidget
  final String url;

  const InAppBrowserModal({Key? key, required this.url}) : super(key: key);

  @override
  State<InAppBrowserModal> createState() => _InAppBrowserModalState();
}

class _InAppBrowserModalState extends State<InAppBrowserModal> {
  late final WebViewController controller; // Declarado como late final

  @override
  void initState() {
    super.initState();
    controller = WebViewController() // Inicializado en initState
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url)); // Usando widget.url
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height:
                MediaQuery.sizeOf(context).height * 0.8, // 80% de la pantalla
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: WebViewWidget(
                        controller:
                            controller), // Usando el controller inicializado
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: ButtonDefaultWidget(
                      title: 'Cerrar',
                      defaultColor: const Color(0xFFFC9214),
                      textColor: Styles.whiteColor,
                      heigthButtom: 48,
                      borderSize: 12,
                      showDecoration: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
