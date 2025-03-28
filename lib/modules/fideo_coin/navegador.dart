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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height:
                MediaQuery.of(context).size.height * 0.8, // 80% de la pantalla
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: WebUri(url)),
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        domStorageEnabled: true,
                      ),
                    ),
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
