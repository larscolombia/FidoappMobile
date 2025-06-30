import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/models/pet_type_model.dart';
import 'package:pawlly/network/network_utils.dart';
import 'package:pawlly/utils/api_end_points.dart';

// Este servicio no se está usando
class PetTypesServiceApis {
  static Future<PetTypeRes> getPetTypeApi() async {
    return PetTypeRes.fromJson(await handleResponse(await buildHttpResponse(
      APIEndPoints.getPetTypeList,
      method: HttpMethodType.GET)
    ));
  }
}
