import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import './storage/secure_local_storage.dart';
import './storage/hive_storage.dart';

enum Currency { usd, tez, eur, inr, aud }

enum Language { en, nl, fr }

class ServiceConfig {
  /// passcode derivation iterations <br>
  /// do not change this value
  static const int pbkdf2Iterations = 16182;

  /// Current selected node
  static String currentSelectedNode = "https://rpc.tzkt.io/mainnet";
  static NetworkType currentNetwork = NetworkType.mainnet;

  static String ipfsUrl = "https://ipfs.io/ipfs";

  // static String currencyApi = "https://api.exchangerate.host/latest?base=USD";

  static String admireArtUrl = "";

  static bool isIAFWidgetVisible = false;
  static bool isVCAWidgetVisible = false;
  static bool isTeztownWidgetVisible = false;

  static bool isTezQuakeWidgetVisible = false;

  static bool isAdmireArtWidgetVisible = false;

  static List nftClaimWidgets = [];

  static Currency currency = Currency.usd;
  static Language language = Language.en;

  static double inr = 0.0;
  static double eur = 0.0;
  static double aud = 0.0;

  /// Teztools api with endpoint for mainnet token prices
  static String tezToolsApi = "https://api.teztools.io/token/prices";

  static String plentyAnalytics =
      "https://api.analytics.plenty.network/analytics/tokens";

  static String thumbnailUris = "https://config.mainnet.plenty.network/tokens";

  /// Xtz price coingecko api with endpoint
  static String coingeckoApi =
      "https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=usd";

  static String tezPriceChart = "https://messari.io/asset/tezos";

  static String xtzPriceApi =
      "https://api.analytics.plenty.network/analytics/tokens/XTZ?historical=false";

  /// Rpc Node Selector
  static String nodeSelector = "https://cdn.naan.app/rpc-list";

  static String ipfsUrlApi = "https://cdn.naan.app/ipfs_url";

  static NftTokenModel randomVcaNft = NftTokenModel();

  static String tzktApiForToken(String pkh, String network) =>
      "https://api.${network}tzkt.io/v1/tokens/balances?account=$pkh&balance.ne=0&limit=10000&token.metadata.tags.null=true&token.metadata.creators.null=true&token.metadata.artifactUri.null=true&token.contract.ne=KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS";

  static String tzktApiForAccountTxs(String pkh,
      {int limit = 20,
      String lastId = "",
      String sort = "Descending",
      String network = "",
      String? query = ""}) {
    if ((query?.contains("sender") ?? false) &&
        (!query!.contains("delegation"))) {
      // receiver
      if (query?.contains("sender.ne") ?? false) {
        query = "$query&amount.gt=0&target=$pkh";
      }
      //sender
      else {
        query = "$query&amount.gt=0&sender=$pkh";
      }
      // query = "$query&type=transaction";
      return "https://api.${network}tzkt.io/v1/operations/transactions?limit=$limit&lastId=$lastId$query";
    }
    return "https://api.${network}tzkt.io/v1/accounts/$pkh/operations?limit=$limit&lastId=$lastId&sort=$sort${query ?? ""}";
  }

  static String tzktApiForTransfers(
      {required String address,
      String network = "mainnet",
      String? timeStamp,
      int limit = 20,
      String? query = ""}) {
    String host = "back.tzkt.io";
    if (network != "mainnet") {
      host = "api.${network}tzkt.io";
    }
    if (query?.contains("sender=") ?? false) {
      query = "${query!}&from=$address";
    } else {
      query = "${query ?? ""}&to=$address";
    }
    if (query?.contains("timestamp") ?? false) {
      return "https://$host/v1/tokens/transfers?sort.desc=timestamp&limit=$limit$query";
    } else {
      return "https://$host/v1/tokens/transfers?timestamp.ge=$timeStamp&sort.desc=timestamp&limit=$limit${query ?? ""}";
    } // return "https://api.${network}.tzkt.io/v1/tokens/transfers?transactionId=$id";
  }

  static String naanApis = "https://cdn.naan.app";

  static String springFeverApi = "https://burn.reveb.la/addresses";

  // Main storage keys
  static const String oldStorageName = "tezsure-wallet-storage-v1.0.0";
  static const String storageName = "naan_wallet_version_2.0.0";

  // Accounts storage keys
  static const String accountsStorage = "${storageName}_accounts_storage";

  static const claimNftAPI = "https://expo.api.naan.app/api/v1/";

  /// append with publicKeyHash while saving or reading
  static const String accountTokensStorage =
      "${storageName}_account_tokens_storage";

  static const String nftPatch = "${storageName}_nft_patch";

  /// append with publicKeyHash while saving or reading
  static const String accountsSecretStorage =
      "${storageName}_account_secret_storage";
  static const String watchAccountsStorage =
      "${storageName}_gallery_accounts_storage";

  static const String galleryStorage = "${storageName}_nft_gallery_storage";

  //Network
  static const String networkStorage = "${storageName}_network_type";
  static const String nodeStorage = "${storageName}_node_network";
  static const String customRpcStorage = "${storageName}_custom_network";

  // auth
  static const String passCodeStorage = "${storageName}_password";
  static const String biometricAuthStorage = "${storageName}_biometricAuth";
  static const String betaTagStorage = "${storageName}_beta_tag";

  // xtz price and token price
  static const String currencySelectedStorage = "${storageName}_currency";
  static const String languageSelectedStorage = "${storageName}_language";
  static const String xtzPriceStorage = "${storageName}_xtz_price";
  static const String inrPriceStorage = "${storageName}_inr";
  static const String eurPriceStorage = "${storageName}_eur";
  static const String audPriceStorage = "${storageName}_aud";
  static const String dayChangeStorage = "${storageName}_24_hr_change";
  static const String tokenPricesStorage = "${storageName}_token_prices";

  // nfts storage name append with user address
  static const String nftStorage = "${storageName}_nfts";

  // contact storage
  static const String contactStorage = "${storageName}_contacts";

  // tx history storage name append with user address
  static const String txHistoryStorage = "${storageName}_tx_history";

  // dapps
  static const String dappsStorage = "${storageName}_dapps";
// events
  static const String eventsStorage = "${storageName}_events";
  static const String vcaEventsStorage = "${storageName}_vca_events";
  // dapps banner
  static const String dappsBannerStorage = "${storageName}_dapps_banner";

  // lockEndTimeStorage
  static const String lockEndTimeStorage = "${storageName}_lock_end_time";

  // totalWrongAttempts
  static const String totalWrongAttemptsStorage =
      "${storageName}_total_wrong_attempts";

  // safetyResetStorage
  static const String safetyResetStorage = "${storageName}_safety_reset";

  // user xtz balances, token balances and nfts
  // static const String accountXtzBalances =
  //     "${storageName}_account_xtz_balances";

  /// Flutter Secure Storage instance </br>
  /// Android it uses keyStore to encrypt the data </br>
  /// Ios it uses Keychain to encrypt the data
  // static const FlutterSecureStorage localStorage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(
  //     encryptedSharedPreferences: true,
  //   ),
  //   iOptions: IOSOptions(
  //     accessibility: KeychainAccessibility.passcode,
  //   ),
  // );

  static SecureLocalStorage secureLocalStorage = SecureLocalStorage()..init();

  // init on splash screen
  static HiveStorage hiveStorage = HiveStorage();

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
    DataHandlerService.singleton = null;
    try {
      await secureLocalStorage.deleteAll();
      await hiveStorage.deleteAll();
    } catch (e) {
      debugPrint(e.toString());
    }
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
    events {
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
      marketplace_event_type
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
  static const String collectionQuery = r'''
query GetCollectionNFT($address: String!) {
  token(
    where: {holders: {holder_address: {_eq: $address}}}
    order_by: {timestamp: desc}
    limit: 50
  ) {
    display_uri
    fa_contract
    token_id
  }
}

''';
  static const String gQuery = r'''
    query GetNftForUser($address: String!) {
      token(where: {holders: {holder_address: {_eq: $address}, token: {}, quantity:{_gt:"0"}}, fa_contract: {_neq: "KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS"}, decimals:{_lte:"0"}}) {
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
        events {
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
          marketplace_event_type
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

  static const String gQueryFast = r'''
    query GetNftForUser($address: String!, $offset: Int) {
      token(
        where: {holders: {holder_address: {_eq: $address}, token: {}, quantity:{_gt:"0"}}, fa_contract: {_neq: "KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS"}, decimals:{_lte:"0"}}
        offset: $offset
        ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
          logo
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';

  static const String getContractQuery = r'''
    query GetContracts($address: String!, $offset: Int) {
      token(
        where: {holders: {holder_address: {_eq: $address}, quantity: {_gt: "0"}}, decimals: {_lte: "0"}}
        distinct_on: fa_contract
        offset: $offset
      ) {
        fa_contract
      }
    }
''';

  static const String getNftsFromContracts = r'''
    query FetchColl($holders: [String!], $contracts: [String!], $offset: Int) {
      token(
        where: {fa_contract : {_in: $contracts}, token_id: {_neq: ""},holders:{holder_address:{_in:$holders}, quantity:{_gt:"0"}}}
        offset: $offset
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
          logo
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';

  static const String getNftsFromPks = r'''
    query NftsFromPks($pks: [bigint!], $offset: Int) {
      token(
        where: {pk : {_in: $pks}, token_id: {_neq: ""}},
        offset: $offset
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
          logo
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';

  static const String searchQueryFromPks = r'''
    query NftsFromPks($pks: [bigint!], $offset: Int, $query: String!) {
      token(
        where: {pk : {_in: $pks}, token_id: {_neq: ""},  _or: [{ name: {_iregex:$query} },{ creators: {holder:{alias:{_iregex:$query}}} }, { fa:{name:{_iregex:$query}} },{fa_contract:{_eq:$query} }, ]},
        offset: $offset
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
          logo
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';
  static const String searchQueryFromAddress = r'''
    query NftsFromAddress($address: String!, $offset: Int, $query: String!) {
      token(
        where: {holders: {holder_address: {_eq: $address}, token: {}, quantity:{_gt:"0"}}, token_id: {_neq: ""},  _or: [{ name: {_iregex:$query} },{ creators: {holder:{alias:{_iregex:$query}}} }, { fa:{name:{_iregex:$query}} },{fa_contract:{_eq:$query} }, ]},
        offset: $offset
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
          logo
        }
        token_id
        holders(where: {holder_address: {_eq: $address}, quantity: {_gt: "0"}}) 
        {
          quantity
          holder_address
        }
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';

  static const String randomNfts = r'''
    query FetchColl($holders: [String!], $contracts: [String!], $offset: Int) {
      token(
        where: {fa_contract : {_in: $contracts}, token_id: {_neq: ""},holders:{holder_address:{_in:$holders}, quantity:{_gt:"0"}}}
        limit: 100
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';

  static const String getNFTfromPk = r'''
    query GetNftForUser($pk:bigint, $addresses: [String!]) {
      token(where: {pk:{_eq:$pk}}) {
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
        holders(where: {holder_address: {_in: $addresses}, quantity: {_gt: "0"}} limit:1) {
          quantity
          holder_address
        }
        events {
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
          marketplace_event_type
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

  static const String getNFTfromPkwithoutHolder = r'''
    query GetNftForUser($pk:bigint) {
      token(where: {pk:{_eq:$pk}}) {
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
        holders(limit:1) {
          quantity
          holder_address
        }
        events {
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
          marketplace_event_type
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

  static const String getNFTFromContractWithoutHolder = r'''
    query GetNftForUser($address: String!, $tokenId: String!) {
      token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
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
        holders(limit:1) {
          quantity
          holder_address
        }
        events {
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
          marketplace_event_type
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

  static const String getNFTFromCollectionWithoutHolder = r'''
    query GetNftForUser($address: String!, $tokenId: String!) {
      token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
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
        holders(limit:1) {
          quantity
          holder_address
        }
        events {
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
          marketplace_event_type
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

  static const String searchQuery = r'''
    query FetchColl($holders: [String!], $contracts: [String!], $offset: Int, $query: String!) {
      token(
        where: {fa_contract : {_in: $contracts}, token_id: {_neq: ""},holders:{holder_address:{_in:$holders}, quantity:{_gt:"0"}}, _or: [{ name: {_iregex:$query} }, { fa:{name:{_iregex:$query}} },{fa_contract:{_eq:$query} }, ] }
        
        offset: $offset
      ) {
        name
        pk
        fa_contract
        display_uri
        fa{
          name
        }
        token_id
        creators {
          creator_address
          token_pk
          holder {
            alias
            address
          }
        }
      }
    }
''';
}
