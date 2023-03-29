import 'dart:convert';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';

const demoJsonDataBanners = """
[
  {
    "name":"Yupana Finance",
    "title":"Madfish Launches YUPANA.FINANCE",
    "type":"banner",
    "dapps":[
      
    ],
    "tag": "NEW LAUNCH",
    "description": "Built to securely lend and borrow digital assets via smart contracts.",
    "bannerImage" : "https://cdn.discordapp.com/attachments/1021333306912026684/1049644496264105994/Rectangle_4539.png"
  }
]
""";

const demoJsonDapps = """
{
  "Yupana Finance": {
    "name": "Yupana Finance",
    "logo": "https://yupana.finance/favicon-32x32.png",
    "url": "https://yupana.finance",
    "backgroundImage": "https://cdn.discordapp.com/attachments/1021333306912026684/1049644496264105994/Rectangle_4539.png",
    "description": "Yupana.Finance is an open-source, decentralized, and non-custodial liquidity protocol built to securely lend and borrow digital assets via smart contracts.",
    "discord": "https://discord.gg/6Z2Y4Y4",
    "twitter": "https://twitter.com/yupanafinance",
    "telegram": "https://t.me/yupanafinance"
  }
}
""";

class DappsPageController extends GetxController {
  RxList<DappBannerModel> dappBanners = RxList.empty();
  RxMap<String, DappModel> dapps = <String, DappModel>{}.obs;

  @override
  void onInit() {
    super.onInit();

    DataHandlerService().getDappsAndStore(
      dappBanners: dappBanners,
      dapps: dapps,
    );

    // dapps = jsonDecode(demoJsonDapps).map<String, DappModel>(
    //     (key, json) => MapEntry(key.toString(), DappModel.fromJson(json)));
    // dappBanners.value = jsonDecode(demoJsonDataBanners)
    //     .map<DappBannerModel>((json) => DappBannerModel.fromJson(json))
    //     .toList();
  }
}
