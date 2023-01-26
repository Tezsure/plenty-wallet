// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NaanAnalytics {
  static const address = "address";
  static final NaanAnalytics _singleton = NaanAnalytics._internal();
  static late FirebaseAnalytics _analytics;

  factory NaanAnalytics() => _singleton;

  NaanAnalytics._internal() {
    _analytics = FirebaseAnalytics.instance;
  }
  Future<void> setupAnalytics() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    await _analytics.setDefaultEventParameters({
      'version': version,
      'buildNumber': buildNumber,
      'packageName': packageName,
      'appName': appName
    });
  }

  static void logEvent(String name, {Map<String, dynamic>? param}) async {
    try {
      await _analytics.logEvent(name: name, parameters: param);
    } catch (e) {}
  }

  FirebaseAnalytics getAnalytics() {
    return _analytics;
  }
}

class NaanAnalyticsEvents {
  //done
  static const String GET_STARTED = "get_started_click";
  //done
  static const String CREATE_NEW_ACCOUNT = "create_new_account";
  //done
  static const String ALREADY_HAVE_ACCOUNT = "already_have_account";
  //done
  static const String SOCIAL_LOGIN = "social_login";
  //done
  static const String SKIP_LOGIN = "skip_login";
  //done
  static const String BIOMETRIC_ENABLE = "biometric_enable_click";
  //done
  static const String BIOMETRIC_SKIP = "biometric_skip_click";
  static const String ACCOUNT_IMAGE_PICK_AVATAR = "account_image_pick_avatar";
  static const String ACCOUNT_IMAGE_SELECT_LIBRARY =
      "account_image_select_library";
  //done
  static const String BACKUP_FROM_HOME = "backup_from_home";
  //done
  static const String BACKUP_SKIP = "backup_skip";
  //done
  static const String VIEW_SEED_PHRASE = "view_seed_phrase";
  //done
  static const String VIEW_PRIVATE_KEY = "view_private_key";
  //done
  static const String BACKUP_SUCCESSFUL = "backup_successful";
  //done
  static const String BUY_TEZ_CLICKED = "buy_tez_clicked";
  //done
  static const String DELEGATE_WIDGET_CLICK = "delegate_widget_click";
  //done
  static const String DELEGATE_FROM_WALLET = "delegate_from_wallet";
  //done
  static const String REDELEGATE = "redelegate";
  //done
  static const String DELEGATE_TRANSACTION_SUBMITTED =
      "delegate_transaction_submitted";
  //done
  // static const String MY_GALLERY_CLICK = "my_galler_click";
  //done
  static const String RESET_NAAN = "reset_naan";
  //done
  static const String CHANGE_NODE = "change_node";
  //done
  static const String ADD_CUSTOM_RPC = "add_custom_rpc";
  //done
  static const String CHANGE_NETWORK = "change_network";
  //done
  static const String REMOVE_ACCOUNT = "remove_account";
  //done
  static const String EDIT_ACCOUNT = "edit_account";
  //done
  static const String SEND_TRANSACTION = "send_transaction";
  //done
  // static const String CREATE_NFT_GALLERY = "create_nft_gallery";
  // //done
  // static const String EDIT_NFT_GALLERY = "edit_nft_gallery";
  // //done
  // static const String REMOVE_NFT_GALLERY = "remove_nft_gallery";
  static const String DAPP_CLICK = "dapp_click";
}
