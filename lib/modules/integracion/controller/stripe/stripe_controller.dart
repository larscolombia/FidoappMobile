import 'dart:convert';

import 'package:get/get.dart';
import 'package:pawlly/configs.dart';
import 'package:pawlly/services/auth_service_apis.dart';

class StripeController extends GetxController {
  // ignore: non_constant_identifier_names
  var url_pago_stripe = "".obs;
  var url = "${BASE_URL}checkout";

  get http => null;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> GetUrlPayment(String amount) async {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${AuthServiceApis.dataCurrentUser.apiToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "user_id": AuthServiceApis.dataCurrentUser.id,
        "amount": amount,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('url stripe ${data['url']}');
    }
  }
}
