import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/models/base_response_model.dart';
import 'package:pawlly/models/pet_note_model.dart';
import 'package:pawlly/modules/integracion/util/role_user.dart';
import 'package:pawlly/network/network_utils.dart';
import 'package:pawlly/utils/api_end_points.dart';
import 'package:pawlly/utils/app_common.dart';
import 'package:pawlly/utils/constants.dart';

// Este servicio no se está usando
class PetNoteServiceApis {
  final RoleUser roleUser = Get.put(RoleUser());

  static Future<List<NotePetModel>> getNoteApi({
    int page = 1,
    required int petId,
    int perPage = Constants.perPageItem,
    required List<NotePetModel> notes,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final petNoteRes = PetNoteRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getNote}?pet_id=$petId&per_page=$perPage&page=$page",
              method: HttpMethodType.GET)));
      if (page == 1) notes.clear();
      notes.addAll(petNoteRes.data);
      lastPageCallBack?.call(petNoteRes.data.length != perPage);
      return notes;
    } else {
      return [];
    }
  }

  static Future<BaseResponseModel> addNoteApi({
    required Map<String, dynamic> request
  }) async {
    return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(APIEndPoints.addNote, request: request, method: HttpMethodType.POST)
    ));
  }

  static Future<BaseResponseModel> deleteNote({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteNote}/$id",
            method: HttpMethodType.POST)));
  }
}
