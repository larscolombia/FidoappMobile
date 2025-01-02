import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawlly/configs.dart';
import 'package:pawlly/modules/integracion/model/transaccion/transaction_model.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class TransactionController extends GetxController {
  var transactions = <Transaction>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchTransactions();
    super.onInit();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(
            '${BASE_URL}wallet-transactions?user_id=${AuthServiceApis.dataCurrentUser.id}'),
        headers: {
          'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
          'Content-Type': 'application/json',
        },
      );
      print('transacciones ${jsonEncode(response.body)}');
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success']) {
          List<dynamic> data = jsonResponse['data'];
          print('transacciones ${jsonEncode(data)}');
          transactions.value =
              data.map((json) => Transaction.fromJson(json)).toList();
        } else {
          print(
              'Error en la respuesta del servidor: ${jsonResponse['message']}');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción capturada: $e');
    } finally {
      isLoading(false);
    }
  }
}
