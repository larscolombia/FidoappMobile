import 'package:get/get.dart';
import 'package:pawlly/modules/integracion/model/balance/producto_pay_model.dart';

class ProductoPayController extends GetxController {
  var selectedProduct = ProductoPayModel(
    precio: "",
    nombreProducto: "nombre del producto",
    imagen: "",
    descripcion: "descripcion del producto",
    slug: "libro",
    id: 0,
  ).obs;
  void setProduct(ProductoPayModel product) {
    selectedProduct.value = product;
  }
}
