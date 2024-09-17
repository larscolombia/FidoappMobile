import 'package:flutter/material.dart';
import 'package:pawlly/styles/styles.dart';

class ExploreInput extends StatelessWidget {
  final List<Map<String, dynamic>> petDataList = [
    {
      "image": null, // Sin imagen para probar la ruta local
      "name": "Cuidados para Perros: Guía Completa",
      "isBook": true,
      "price": "\$12.99",
    },
    {
      "image": "https://example.com/petbook2.png",
      "name": "Entrenamiento Canino: Mejores Técnicas",
      "isBook": true,
      "price": "\$15.50",
    },
    {
      "image": "https://example.com/petbook3.png",
      "name": "Nutrición Saludable para Gatos y Perros",
      "isBook": true,
      "price": "\$10.00",
    },
  ];

  ExploreInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input de búsqueda con lupa
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Buscar productos para mascotas",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Styles.greyTextColor, width: 1),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        // Lista de productos para mascotas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: petDataList.map((petItem) {
              return GestureDetector(
                onTap: () {
                  // Acción al tocar un producto o libro
                  print('Nombre del producto: ${petItem['name']}');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width *
                      0.35, // Ancho más pequeño
                  decoration: BoxDecoration(
                    color: Styles.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Styles.greyTextColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen del producto
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: petItem['image'] != null
                              ? Image.network(
                                  petItem['image'],
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
                      SizedBox(height: 8),
                      // Nombre del producto (máximo 3 líneas)
                      Text(
                        petItem['name'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Styles.greyTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Precio y tipo de producto (libro o artículo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Producto',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Styles.iconColorBack,
                            ),
                          ),
                          Text(
                            petItem['price'],
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Styles.iconColorBack,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
        // Ver más sección
        GestureDetector(
          onTap: () {
            print('Ver más de esta sección');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Ver más de esta sección',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Styles.iconColorBack,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Styles.iconColorBack,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
