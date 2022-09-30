import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';

class DappModel {
  final String? name;
  final String? imgUrl;
  NetworkType? networkType;

  DappModel({this.name, this.networkType, this.imgUrl});
}
