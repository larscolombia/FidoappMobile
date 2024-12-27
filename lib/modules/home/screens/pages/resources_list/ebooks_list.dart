import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawlly/modules/components/input_text_icon.dart';
import 'package:pawlly/modules/components/recarga_componente.dart';
import 'package:pawlly/modules/components/style.dart';
import 'package:pawlly/modules/home/screens/explore/libro_detalles.dart';
import 'package:pawlly/modules/integracion/controller/libros/libros_controller.dart';
import 'package:pawlly/modules/integracion/model/libros/libros_model.dart';

class EbooksList extends StatelessWidget {
  EbooksList({super.key});
  final EBookController controller = Get.put(EBookController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 305,
        child: Column(
          children: [
            SizedBox(
              width: 305,
              child: InputTextWithIcon(
                hintText: 'Realiza tu búsqueda',
                iconPath: 'assets/icons/search.png',
                iconPosition: IconPosition.left,
                height: 60.0, // Altura personalizada
                onChanged: (value) {
                  controller.filterEBooks(value);

                  print('search: $value');
                },
              ),
            ),
            const SizedBox(height: 16),
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
                            16, // Espacio horizontal entre elementos
                        mainAxisSpacing: 16, // Espacio vertical entre filas
                        childAspectRatio:
                            0.5, // Ajuste de la proporción de los elementos
                      ),
                      itemCount: controller.filteredEBooks.length,
                      itemBuilder: (context, index) {
                        final book = controller.ebooks[index];
                        return GestureDetector(
                          onTap: () {
                            controller.selectEBookById("${book.id}");

                            Get.to(LibroDetalles());
                          },
                          child: BooksComponents(petItem: book),
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
    required this.petItem,
  });

  final EBook petItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 278, // Altura original
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 102, 95, 95),
          width: 0.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Center(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: petItem.coverImage != null
                    ? Image.network(
                        petItem.coverImage!,
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
          // Nombre del producto (máximo 3 líneas)
          Text(
            petItem.description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Precio y tipo de producto (libro o artículo)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Precio',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Styles.iconColorBack,
                ),
              ),
              Text(
                '${petItem.price} \$ ',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Styles.iconColorBack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
