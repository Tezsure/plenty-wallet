import 'package:plenty_wallet/app/data/services/service_models/tx_history_model.dart';

import '../../../../utils/constants/path_const.dart';

class TokenInfo {
  final String name;
  final String imageUrl;
  final bool isNft;
  final bool skip;
  final double tokenAmount;
  final double dollarAmount;
  final String tokenSymbol;
  final String lastId;
  final AliasAddress? source;
  final AliasAddress? destination;
  final bool isSent;
  final TxHistoryModel? token;
  final bool isDelegated;
  final String? nftContractAddress;
  final String? nftTokenId;
  final String? hash;
  final bool? isHashSame;
  final DateTime? timeStamp;

  final List<TokenInfo> internalOperation;

  TokenInfo({
    this.name = "",
    this.imageUrl = "${PathConst.ASSETS}tezos_logo.png",
    this.isNft = false,
    this.skip = false,
    this.dollarAmount = 0,
    this.tokenSymbol = "tez",
    this.tokenAmount = 0,
    this.lastId = "",
    this.token,
    this.source,
    this.hash,
    this.destination,
    this.internalOperation = const [],
    this.isDelegated = false,
    this.nftContractAddress,
    this.nftTokenId,
    this.isSent = false,
    this.isHashSame = false,
    this.timeStamp,
  });

  TokenInfo copyWith({
    String? name,
    String? imageUrl,
    String? hash,
    bool? isNft,
    AliasAddress? source,
    AliasAddress? destination,
    bool? skip,
    double? tokenAmount,
    double? dollarAmount,
    String? tokenSymbol,
    String? lastId,
    bool? isReceived,
    bool? isSent,
    TxHistoryModel? token,
    bool? isDelegated,
    String? address,
    String? nftTokenId,
    bool? isHashSame,
    List<TokenInfo>? internalOperation,
  }) {
    return TokenInfo(
        name: name ?? this.name,
        hash: hash ?? this.hash,
        imageUrl: imageUrl ?? this.imageUrl,
        isNft: isNft ?? this.isNft,
        skip: skip ?? this.skip,
        tokenAmount: tokenAmount ?? this.tokenAmount,
        dollarAmount: dollarAmount ?? this.dollarAmount,
        tokenSymbol: tokenSymbol ?? this.tokenSymbol,
        source: source ?? this.source,
        destination: destination ?? this.destination,
        lastId: lastId ?? this.lastId,
        isSent: isSent ?? this.isSent,
        token: token ?? this.token,
        isDelegated: isDelegated ?? this.isDelegated,
        nftContractAddress: address ?? nftContractAddress,
        nftTokenId: nftTokenId ?? this.nftTokenId,
        isHashSame: isHashSame ?? this.isHashSame,
        internalOperation: internalOperation ?? this.internalOperation,
        timeStamp: timeStamp ?? timeStamp);
  }
}
