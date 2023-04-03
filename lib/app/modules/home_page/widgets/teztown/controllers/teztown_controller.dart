import 'dart:convert';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';

import 'teztown_model.dart';

class TeztownController extends GetxController {
  static String imageBaseUrl = "https://cdn.naan.app/spring_fever_images";
  @override
  Future<void> onInit() async {
    teztownData.value = await getTeztownData();
    super.onInit();
  }

  Rx<TeztownModel> teztownData = TeztownModel().obs;

  Future<TeztownModel> getTeztownData() async {
    var response = await HttpService.performGetRequest(
        "https://cdn.naan.app/spring_fever");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return teztownModelFromJson(response);
    }

    return TeztownModel();
  }
}
