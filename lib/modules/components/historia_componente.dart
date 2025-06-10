import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlly/components/button_default_widget.dart';
import 'package:pawlly/modules/components/style.dart';

class HistoriaMascotaComponent extends StatelessWidget {
  const HistoriaMascotaComponent({
    super.key,
    required this.reportName,
    required this.categoryName,
    required this.applicationDate,
    required this.callback,
    this.id,
  });
  final String? reportName;
  final String? categoryName;
  final String? applicationDate;
  final String? id;
  final void Function()? callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              reportName ?? "Sin nombre",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Categoría: ${categoryName ?? 'N/A'}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Styles.iconColorBack,
            ),
          ),
          Text(
            'Fecha: ${applicationDate ?? 'No disponible'}',
            style: const TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          id != null
              ? Text(
                  'Informe: Nro. $id',
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                )
              : const SizedBox(),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonDefaultWidget(
              title: 'Abrir >',
              callback: callback,
              heigthButtom: 46,
            ),
          ),
        ],
      ),
    );
  }
}
