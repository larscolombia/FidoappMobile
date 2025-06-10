class ProductoPayModel {
  String precio;
  String nombreProducto;
  String imagen;
  String descripcion;
  String slug;
  int id;
  ProductoPayModel({
    required this.precio,
    required this.nombreProducto,
    required this.imagen,
    required this.descripcion,
    required this.slug,
    required this.id,
  });

  factory ProductoPayModel.fromJson(Map<String, dynamic> json) {
    return ProductoPayModel(
      precio: json['precio'],
      nombreProducto: json['nombre_producto'],
      imagen: json['imagen'],
      descripcion: json['descripcion'],
      slug: json['slug'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'precio': precio,
      'nombre_producto': nombreProducto,
      'imagen': imagen,
      'descripcion': descripcion,
      'slug': slug,
    };
  }
}
