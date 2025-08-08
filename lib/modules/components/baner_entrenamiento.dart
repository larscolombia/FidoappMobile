import 'package:flutter/material.dart';
import 'package:pawlly/styles/recursos.dart';
import 'package:pawlly/styles/styles.dart';

class BanerEntrenamiento extends StatefulWidget {
  BanerEntrenamiento({
    super.key,
    required this.imagen,
    this.normalizedProgress = 0.0,
    required this.nombre,
    this.dificultad,
    this.ishorizontal = false,
    required this.callback,
  });

  final String imagen;
  final String nombre;
  final String? dificultad;
  final double normalizedProgress;
  final bool ishorizontal;
  final void Function()? callback;

  @override
  State<BanerEntrenamiento> createState() => _BanerEntrenamientoState();
}

class _BanerEntrenamientoState extends State<BanerEntrenamiento> {
  bool _isLoading = false;

  void _handlePressed() {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    widget.callback?.call();
  }

  String dificultadValue(String dificultad) {
    switch (dificultad) {
      case '1':
        return 'Fácil';
      case '2':
        return 'Media';
      case '3':
        return 'Difícil';
      default:
        return 'Difícil';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    // Ajuste dinámico del ancho de la imagen basado en el ancho de la pantalla
    // para diferentes orientaciones (horizontal o vertical)
    final double imageWidth =
        widget.ishorizontal ? screenWidth * 0.30 : screenWidth * 0.35;
    final double imageHeight =
        imageWidth * (122 / 131); // Mantiene la proporción de la imagen

    // Define la proporción de aspecto para el contenedor principal
    double aspectRatio = 118 / 131;
    // Define un ancho mínimo y máximo para el contenedor principal para evitar que sea demasiado pequeño o grande
    double minWidth = 150; // Aumenté el mínimo para pantallas más pequeñas
    double maxWidth = 350; // Aumenté el máximo para pantallas más grandes

    // Calcula el ancho del contenedor principal basado en un porcentaje del ancho de la pantalla,
    // pero limitado por el ancho mínimo y máximo definidos
    double width = (screenWidth * 0.40).clamp(minWidth,
        maxWidth); // Aumenté el porcentaje para ocupar más espacio en pantallas pequeñas
    double height = width / aspectRatio;

    return Container(
      margin: const EdgeInsets.only(
          bottom: 8), // Aumenté el margen inferior para más espacio vertical
      padding: const EdgeInsets.all(
          12), // Reduje el padding para dar más espacio al texto en pantallas pequeñas
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius:
            BorderRadius.circular(10), // Aumenté ligeramente el radio del borde
        border: Border.all(
          color: const Color(0xffEAEAEA),
          width: 1,
        ),
      ),
      // Fila principal que contiene la imagen y la información del curso
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Alinea los elementos al inicio para mejor visualización en textos largos
        children: [
          // Contenedor para la imagen del curso
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            // Widget para recortar la imagen con bordes redondeados
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.72),
              // Widget para mostrar la imagen desde la red
              child: Image.network(
                widget.imagen,
                fit: BoxFit
                    .cover, // Asegura que la imagen cubra todo el contenedor sin deformarse
                // Widget que muestra un indicador de progreso mientras se carga la imagen
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      color: Styles
                          .iconColorBack, // Color del indicador de progreso
                    ),
                  );
                },
                // Widget que muestra una imagen de error en caso de que la carga de la imagen falle
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/404.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          // Espacio expandido para la información del curso, permitiendo que se expanda horizontalmente
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(left: 10), // Reduje el margen izquierdo
              // Ajuste dinámico de la altura del contenedor de información
              height: imageHeight + 9,
              // Columna que organiza la información del curso verticalmente
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dificultad del curso
                  Text(
                    dificultadValue(widget.dificultad ?? ''),
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize:
                          11, // Reduje el tamaño de fuente para pantallas más pequeñas
                      fontWeight: FontWeight.w400,
                      color: Styles.iconColorBack,
                    ),
                  ),

                  // Nombre del curso, envuelto en un Flexible para permitir que se ajuste al espacio disponible
                  Flexible(
                    child: Text(
                      widget.nombre,
                      maxLines: 2, // Limita el nombre a 2 líneas
                      overflow: TextOverflow
                          .ellipsis, // Muestra puntos suspensivos si el texto excede el límite
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize:
                            13, // Reduje el tamaño de fuente para pantallas más pequeñas
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF383838),
                      ),
                    ),
                  ),
                  const Text(
                    'Progreso:',
                    style: TextStyle(
                      fontSize:
                          11, // Reduje el tamaño de fuente para pantallas más pequeñas
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF383838),
                      fontFamily: Recursos.fuente1,
                    ),
                  ),
                  // Fila para el indicador de progreso y el porcentaje
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Indicador de progreso lineal con ancho dinámico
                      SizedBox(
                        width: imageWidth *
                            0.7, // Reduje el ancho del indicador de progreso
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(27.0),
                          child: LinearProgressIndicator(
                            value: widget.normalizedProgress,
                            backgroundColor: const Color(0XFFECECEC),
                            color: Styles.iconColorBack,
                            minHeight:
                                5, // Reduje la altura del indicador de progreso
                            borderRadius: BorderRadius.circular(27.0),
                          ),
                        ),
                      ),
                      // Porcentaje de progreso
                      Text(
                        '${(widget.normalizedProgress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize:
                              11, // Reduje el tamaño de fuente para pantallas más pequeñas
                          fontWeight: FontWeight.w800,
                          color: Styles.iconColorBack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03), // Reduje el espacio inferior

                  // Botón "Seguir viendo"
                  SizedBox(
                    height: 28, // Reduje la altura del botón
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal:
                              25, // Reduje el padding horizontal del botón
                          vertical: 5, // Reduje el padding vertical del botón
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Texto del botón
                        children: [
                          if (_isLoading)
                            const SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          else
                            const Text(
                              'Seguir viendo',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
