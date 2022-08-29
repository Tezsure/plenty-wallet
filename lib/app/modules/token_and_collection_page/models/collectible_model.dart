import 'package:naan_wallet/app/modules/token_and_collection_page/models/nft_model.dart';

class CollectibleModel {
  final String name;
  final List<NFTmodel> nfts;
  final String collectibleProfilePath;

  CollectibleModel({
    required this.name,
    required this.nfts,
    required this.collectibleProfilePath,
  });
}
