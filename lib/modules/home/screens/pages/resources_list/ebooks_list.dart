import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/components/input_busqueda.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/home/screens/explore/libro_detalles.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/modules/integracion/model/libros/libros_model.dart';
import 'package:pawlly/styles/recursos.dart';

class EbooksList extends StatelessWidget {
  EbooksList({super.key});
  final EBookController controller = Get.put(EBookController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 380,
        child: Column(
          children: [
            SizedBox(
              width: 380,
              child: InputBusqueda(onChanged: (value) {
                controller.filterEBooks(value);

                print('search: $value');
              }),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Obx(() {
                if (controller.ebooks.value.isEmpty) {
                  return Center(
                    child: RecargaComponente(
                      callback: () {
                        print(controller.ebooks.value.length);
                        controller.fetchEBooks();
                        print('Recargar');
                      },
                    ),
                  );
                }

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Dos columnas
                        crossAxisSpacing:
                            15, // Espacio horizontal entre elementos
                        mainAxisSpacing: 10, // Espacio vertical entre filas
                        childAspectRatio:
                            0.7, // Ajuste de la proporción de los elementos
                      ),
                      itemCount: controller.filteredEBooks.length,
                      itemBuilder: (context, index) {
                        final book = controller.filteredEBooks[index];
                        return GestureDetector(
                          onTap: () {
                            controller.selectEBookById("${book.id}");
                            Get.to(() => LibroDetalles());
                          },
                          child: BooksComponents(ebook: book),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    RecargaComponente(
                      callback: () {
                        controller.fetchEBooks();
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksComponents extends StatelessWidget {
  const BooksComponents({
    super.key,
    required this.ebook,
  });

  final EBook ebook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 278, // Ajusta la altura del contenedor
      width: 148,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Recursos.ColorBorderSuave,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 146,
              width: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                child: ebook.coverImage != null
                    ? Image.network(
                        ebook.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/default_book.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/default_book.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Text(
                  ebook.title!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.2,
                    fontFamily: 'Lato',
                    fontSize: constraints.maxWidth *
                        0.095, // Ajusta el tamaño de la fuente según el ancho del contenedor
                    fontWeight: FontWeight.w700,
                    color: const Color(0XFF383838),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Añadir cualquier otro contenido aquí
        ],
      ),
    );
  }
}
