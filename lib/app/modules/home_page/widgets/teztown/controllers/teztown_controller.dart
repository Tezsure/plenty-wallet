import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';

import 'teztown_model.dart';

class TeztownController extends GetxController {
  static String imageBaseUrl = "https://cdn.naan.app/spring_fever_images";
  @override
  Future<void> onInit() async {
    teztownData.value = await DataHandlerService().getTeztownData(teztownData);
    super.onInit();
  }

  Rx<TeztownModel> teztownData = TeztownModel().obs;
}
