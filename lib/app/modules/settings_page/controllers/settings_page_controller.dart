import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/dapp_model.dart';
import 'package:naan_wallet/app/modules/settings_page/models/node_model.dart';

class SettingsPageController extends GetxController {
  RxBool backup = true.obs;
  RxBool fingerprint = false.obs;

  Rx<NetworkType> networkType = NetworkType.mainNet.obs;
  RxList<NodeModel> nodes = <NodeModel>[].obs;
  Rx<NodeModel> selectedNode =
      NodeModel(title: "title1", address: "address1").obs;
  RxList<DappModel> dapps = List.generate(
      4,
      (index) => DappModel(
          imgUrl: "", name: "dapp", networkType: NetworkType.mainNet)).obs;

  switchFingerprint(bool value) => fingerprint.value = value;
  switchbackup() => backup.value = !backup.value;

  SettingsPageController() {
    nodes.value = List.generate(5,
        (index) => NodeModel(title: "title$index", address: "address$index"));

    selectedNode.value = nodes[0];
  }

  
}
