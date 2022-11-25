import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class ServiceConfig {
  // TODO: Add support for testnet on all apis

  /// Current selected node
  static String currentSelectedNode =
      "https://tezos-prod.cryptonomic-infra.tech:443";

  /// Teztools api with endpoint for mainnet token prices
  static String tezToolsApi = "https://api.teztools.io/token/prices";

  /// Xtz price coingecko api with endpoint
  static String coingeckoApi =
      "https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=usd";

  /// Rpc Node Selector
  static String nodeSelector = "rpc_node/rpc_node.json";

  static String tzktApiForToken(String pkh) =>
      "https://api.tzkt.io/v1/tokens/balances?account=$pkh&balance.ne=0&limit=10000&token.metadata.tags.null=true&token.metadata.creators.null=true&token.metadata.artifactUri.null=true";

  static String tzktApiForAccountTxs(String pkh,
          {int limit = 20, String lastId = "", String sort = "Descending"}) =>
      "https://api.tzkt.io/v1/accounts/$pkh/operations?limit=$limit&lastId=$lastId&sort=$sort";

  // Main storage keys
  static const String oldStorageName = "tezsure-wallet-storage-v1.0.0";
  static const String storageName = "naan_wallet_version_2.0.0";

  // Accounts storage keys
  static const String accountsStorage = "${storageName}_accounts_storage";

  /// append with publicKeyHash while saving or reading
  static const String accountTokensStorage =
      "${storageName}_account_tokens_storage";

  /// append with publicKeyHash while saving or reading
  static const String accountsSecretStorage =
      "${storageName}_account_secret_storage";
  static const String watchAccountsStorage =
      "${storageName}_gallery_accounts_storage";

  static const String galleryStorage = "${storageName}_nft_gallery_storage";

  // auth
  static const String passCodeStorage = "${storageName}_password";
  static const String biometricAuthStorage = "${storageName}_biometricAuth";

  // xtz price and token price
  static const String xtzPriceStorage = "${storageName}_xtz_price";
  static const String tokenPricesStorage = "${storageName}_token_prices";

  // nfts storage name append with user address
  static const String nftStorage = "${storageName}_nfts";

  // contact storage
  static const String contactStorage = "${storageName}_contacts";

  // tx history storage name append with user address
  static const String txHistoryStorage = "${storageName}_tx_history";

  // user xtz balances, token balances and nfts
  // static const String accountXtzBalances =
  //     "${storageName}_account_xtz_balances";

  /// Flutter Secure Storage instance </br>
  /// Android it uses keyStore to encrypt the data </br>
  /// Ios it uses Keychain to encrypt the data
  static const FlutterSecureStorage localStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const List<String> allAssetsProfileImages = <String>[
    "${PathConst.PROFILE_IMAGES}1.png",
    "${PathConst.PROFILE_IMAGES}2.png",
    "${PathConst.PROFILE_IMAGES}3.png",
    "${PathConst.PROFILE_IMAGES}4.png",
    "${PathConst.PROFILE_IMAGES}5.png",
    "${PathConst.PROFILE_IMAGES}6.png",
    "${PathConst.PROFILE_IMAGES}7.png",
    "${PathConst.PROFILE_IMAGES}8.png",
    "${PathConst.PROFILE_IMAGES}9.png",
    "${PathConst.PROFILE_IMAGES}10.png",
    "${PathConst.PROFILE_IMAGES}11.png",
  ];

  /// Clear the local storage
  Future<void> clearStorage() async {
    await localStorage.deleteAll();
  }

  static const String cQuery = r'''
  query getCreator ($address: String!) {
  holder_by_pk(address: $address) {
    alias
    description
    logo
    tzdomain
    address
    }
  }
  ''';

  static const String nftQuery = r'''
    query getNFT($address: String!, $token_id: String!) {
      token(where: {token_id: {_eq: $token_id}, fa_contract: {_eq: $address}}) {
 artifact_uri
    description
    display_uri
    lowest_ask
    level
    mime
    pk
    royalties {
      id
      decimals
      amount
    }
    supply
    thumbnail_uri
    timestamp
    fa_contract
    token_id
    name
    creators {
      creator_address
      token_pk
       holder {
        alias
        address
      }
    }
    holders(where: {holder_address: {_eq: $address}, quantity: {_gt: "0"}}) {
      quantity
      holder_address
    }
    events(where: {recipient: {address: {_eq: $address}}, event_type: {}}) {
      id
      fa_contract
      price
      recipient_address
      timestamp
      creator {
        address
        alias
      }
      event_type
      amount
    }
    fa {
      name
      collection_type
      logo
      floor_price
      contract
      description
    }
    metadata
  
    }
  }
  ''';

  static const String gQuery = r'''
        query GetNftForUser($address: String!) {
  token(where: {holders: {holder: {address: {_eq: $address}}, token: {}}, fa_contract: {_neq: "KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS"}}) {
    artifact_uri
    description
    display_uri
    lowest_ask
    level
    mime
    pk
    royalties {
      id
      decimals
      amount
    }
    supply
    thumbnail_uri
    timestamp
    fa_contract
    token_id
    name
    creators {
      creator_address
      token_pk
      holder {
        alias
        address
      }
    }
    holders(where: {holder_address: {_eq: $address}, quantity: {_gt: "0"}}) {
      quantity
      holder_address
    }
    events(where: {recipient: {address: {_eq: $address}}, event_type: {}}) {
      id
      fa_contract
      price
      recipient_address
      timestamp
      creator {
        address
        alias
      }
      event_type
      amount
    }
    fa {
      name
      collection_type
      logo
      floor_price
      contract
    }
    metadata
  }
}
''';
}
