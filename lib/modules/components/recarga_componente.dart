import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Asegúrate de importar el paquete
import 'package:pawlly/components/safe_inkwell.dart';

class RecargaComponente extends StatefulWidget {
  const RecargaComponente({
    super.key,
    this.callback,
    this.callbackAsync,
    this.titulo = 'Cargar más',
    this.loadingText = 'Cargando…',
  this.cooldown = const Duration(milliseconds: 800),
  });

  final VoidCallback? callback;
  final Future<void> Function()? callbackAsync;
  final String titulo;
  final String loadingText;
  /// Tiempo mínimo tras finalizar una carga para aceptar otro tap
  final Duration cooldown;

  @override
  State<RecargaComponente> createState() => _RecargaComponenteState();
}

class _RecargaComponenteState extends State<RecargaComponente> {
  bool _loading = false;
  DateTime? _lastActionEnd;

  Future<void> _handleAsyncTap() async {
    if (widget.callbackAsync == null) return;
    // Bloquea si sigue en cooldown
    if (_loading) return;
    if (_lastActionEnd != null && DateTime.now().difference(_lastActionEnd!) < widget.cooldown) {
      return; // ignorar tap ansioso
    }
    if (mounted) setState(() => _loading = true);
    try {
      await widget.callbackAsync!.call();
    } finally {
      _lastActionEnd = DateTime.now();
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool useAsync = widget.callbackAsync != null;
    return SafeInkWell(
      onTap: useAsync ? null : widget.callback,
      onTapAsync: useAsync ? _handleAsyncTap : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_loading)
            SizedBox(
              height: 18,
              width: 18,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFC9214)),
              ),
            )
          else
            SvgPicture.asset(
              "assets/icons/svg/refresh-2.svg", // Ruta del archivo SVG
              height: 18, // Puedes ajustar el tamaño si lo necesitas
              width: 18,
            ),
          const SizedBox(width: 10),
          Text(
            _loading ? widget.loadingText : widget.titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFC9214),
            ),
          ),
        ],
      ),
    );
  }
}
