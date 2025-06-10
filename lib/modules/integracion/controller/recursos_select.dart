import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ModelRecursosSelect {
  int tipo = 0;

  ModelRecursosSelect(
    this.tipo,
  );
}

class RecursosSelect extends GetxController {
  Rx<int> tipo = 0.obs;

  void onChange(Rx<int> tipo) {
    this.tipo = tipo;
  }

  void ver(value) {
    print("$value === $value");
    print("${value == value}");
  }
}
