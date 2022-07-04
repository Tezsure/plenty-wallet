import 'dart:math';

// import 'package:naan_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:naan_wallet/models/token_tx_model.dart';

enum TOKEN_TYPE {
  FA1,
  FA2,
}
enum TypeModel { TOKEN, NFT }

class TokensModel {
  String? contract;
  String? network;
  int? level;
  int? tokenId;
  String? symbol;
  String? name;
  int? decimals;
  String? description;
  String? artifactUri;
  String? displayUri;
  String? thumbnailUri;
  bool? isTransferable;
  List<dynamic>? creators;
  List<dynamic>? tags;
  List<Formats>? formats;
  String? balance;
  String? price;
  TOKEN_TYPE? type;
  TypeModel? tokenType;
  String? exprDex;
  String? dexContractAddress;
  List<TokenTxModel>? tokenTxlist;
  String? iconUrl;
  String? priceChange;

  TokensModel(
      {this.contract,
      this.network,
      this.level,
      this.tokenId,
      this.symbol,
      this.name,
      this.decimals,
      this.description,
      this.artifactUri,
      this.thumbnailUri,
      this.isTransferable,
      this.creators,
      this.tags,
      this.formats,
      this.balance,
      this.priceChange});

  TokensModel.fromJsonBase(Map<String, dynamic> json) {
    contract = json['contract'];
    network = json['network'];
    level = json['level'];
    tokenId = json['token_id'];
    symbol = json['symbol'];
    name = json['name'];
    decimals = json['decimals'];
    description = json['description'];
    artifactUri = json['artifact_uri'];
    displayUri = json['display_uri'];
    thumbnailUri = json['thumbnail_uri'];
    isTransferable = json['is_transferable'];
    price = json['price'] ?? '0.0';
    creators =
        json['creators'] != null ? json['creators'].cast<String>() : <String>[];
    tags = json['tags'] != null ? json['tags'].cast<String>() : <String>[];
    if (json['formats'] != null) {
      formats = <Formats>[];
      json['formats'].forEach((v) {
        formats?.add(new Formats.fromJson(v));
      });
    }
    balance = json['balance'];
    if (balance!.endsWith('.')) balance = balance! + '0';
    if ((artifactUri != null && artifactUri!.isNotEmpty) ||
        (creators != null && creators!.isNotEmpty) ||
        (formats != null && formats!.isNotEmpty) ||
        decimals == 0) tokenType = TypeModel.NFT;
    if (artifactUri != null &&
        artifactUri!.isNotEmpty &&
        artifactUri!.startsWith("ipfs"))
      iconUrl = 'https://cloudflare-ipfs.com/ipfs/${artifactUri!.substring(7)}';
    else if (displayUri != null &&
        displayUri!.isNotEmpty &&
        displayUri!.startsWith("ipfs")) {
      if (tokenType == null) {
        tokenType = TypeModel.TOKEN;
      }
      iconUrl = 'https://cloudflare-ipfs.com/ipfs/${displayUri!.substring(7)}';
    } else if (tokenType == TypeModel.NFT && iconUrl == null) {
      iconUrl = 'https://services.tzkt.io/v1/avatars/$contract';
    } else {
      tokenType = TypeModel.TOKEN;
      if (thumbnailUri != null &&
          thumbnailUri!.isNotEmpty &&
          thumbnailUri!.startsWith("ipfs"))
        iconUrl =
            'https://cloudflare-ipfs.com/ipfs/${thumbnailUri!.substring(7)}';
      else if (thumbnailUri != null &&
          thumbnailUri!.isNotEmpty &&
          thumbnailUri!.startsWith("http"))
        iconUrl = thumbnailUri;
      else
        iconUrl = 'https://services.tzkt.io/v1/avatars/$contract';
    }
  }

  TokensModel.fromJson(Map<String, dynamic> json) {
    contract = json['token']['contract']['address'];
    // network = json['network'];
    // level = json['level'];
    if (json['token']['standard'] != 'fa1.2')
      tokenId = int.parse(json['token']['tokenId'] ?? '0');
    // try {
    //   tokenId = json['token_id'];
    // } catch (e) {
    //   tokenId = 0;
    // }
    symbol = json['token']['metadata']['symbol'];
    name = json['token']['metadata']['name'];
    decimals = int.parse(json['token']['metadata']['decimals']);
    // description = json['description'];
    // artifactUri = json['artifact_uri'];
    // displayUri = json['display_uri'];
    // thumbnailUri = json['thumbnail_uri'];
    // isTransferable = json['is_transferable'];
    price = json['price'] ?? '0.0';
    creators =
        json['creators'] != null ? json['creators'].cast<String>() : <String>[];
    tags = json['tags'] != null ? json['tags'].cast<String>() : <String>[];
    if (json['formats'] != null) {
      formats = <Formats>[];
      json['formats'].forEach((v) {
        formats!.add(new Formats.fromJson(v));
      });
    }
    balance = json['balance'];
    if (balance!.endsWith('.')) balance = balance! + '0';
    if ((artifactUri != null && artifactUri!.isNotEmpty) ||
        (creators != null && creators!.isNotEmpty) ||
        (formats != null && formats!.isNotEmpty) ||
        decimals == 0) tokenType = TypeModel.NFT;
    if (artifactUri != null &&
        artifactUri!.isNotEmpty &&
        artifactUri!.startsWith("ipfs"))
      iconUrl = 'https://cloudflare-ipfs.com/ipfs/${artifactUri!.substring(7)}';
    else if (displayUri != null &&
        displayUri!.isNotEmpty &&
        displayUri!.startsWith("ipfs")) {
      if (tokenType == null) {
        tokenType = TypeModel.TOKEN;
        if (int.parse(balance!) != 0 && decimals != null)
          balance = (int.parse(balance!) / pow(10, decimals!))
              .toStringAsFixed(decimals!)
              .replaceAll(RegExp(r'0*$'), '');
      }

      iconUrl = 'https://cloudflare-ipfs.com/ipfs/${displayUri!.substring(7)}';
    } else if (tokenType == TypeModel.NFT && iconUrl == null) {
      iconUrl = 'https://services.tzkt.io/v1/avatars/$contract';
    } else {
      tokenType = TypeModel.TOKEN;
      if (balance!.startsWith('-')) balance = '0';
      var balanceTrimLength = 0;
      if (balance!.length > 18) {
        var _b = balance!.substring(0, 18);
        balanceTrimLength = balance!.length - _b.length;
        balance = _b;
      }
      if (int.parse(balance!) != 0 && decimals != null)
        balance = (int.parse(balance!) / pow(10, decimals! - balanceTrimLength))
            .toStringAsFixed(decimals!)
            .replaceAll(RegExp(r'0*$'), '');
      if (thumbnailUri != null &&
          thumbnailUri!.isNotEmpty &&
          thumbnailUri!.startsWith("ipfs"))
        iconUrl =
            'https://cloudflare-ipfs.com/ipfs/${thumbnailUri!.substring(7)}';
      else if (thumbnailUri != null &&
          thumbnailUri!.isNotEmpty &&
          thumbnailUri!.startsWith("http"))
        iconUrl = thumbnailUri;
      else
        iconUrl = 'https://services.tzkt.io/v1/avatars/$contract';
    }
  }

  Future<String> getTokenPrice() async {
    return price!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contract'] = this.contract;
    data['network'] = this.network;
    data['level'] = this.level;
    data['token_id'] = this.tokenId;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['decimals'] = this.decimals;
    data['description'] = this.description;
    data['artifact_uri'] = this.artifactUri;
    data['thumbnail_uri'] = this.thumbnailUri;
    data['is_transferable'] = this.isTransferable;
    data['creators'] = this.creators;
    data['tags'] = this.tags;
    data['price'] = this.price;
    if (this.formats != null) {
      data['formats'] = this.formats!.map((v) => v.toJson()).toList();
    }
    data['balance'] = this.balance;
    return data;
  }
}

class Formats {
  String? mimeType;
  String? uri;

  Formats({this.mimeType, this.uri});

  Formats.fromJson(Map<String, dynamic> json) {
    mimeType = json['mimeType'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mimeType'] = this.mimeType;
    data['uri'] = this.uri;
    return data;
  }
}
