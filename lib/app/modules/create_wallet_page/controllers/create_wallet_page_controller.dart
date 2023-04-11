import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3auth.dart';
import 'package:web3auth_flutter/enums.dart';

class CreateWalletPageController extends GetxController {
  @override
  void onInit() {
    Web3Auth.initPlatformState();
    super.onInit();
  }

  login({required Provider socialAppName}) {
    // CommonFunctions.bottomSheet(
    //   NaanBottomSheet(
    //     height: 420.arP,
    //     bottomSheetHorizontalPadding: 32.arP,
    //     bottomSheetWidgets: [
    //       0.04.vspace,
    //       Align(
    //         alignment: Alignment.center,
    //         child: LottieBuilder.asset(
    //           '${PathConst.SEND_PAGE}lottie/failed.json',
    //           height: 68,
    //           width: 68,
    //           repeat: false,
    //         ),
    //       ),
    //       0.02.vspace,
    //       Align(
    //         alignment: Alignment.center,
    //         child: Text(
    //           'Temporary Maintenance',
    //           style: titleLarge,
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       0.01.vspace,
    //       Align(
    //         alignment: Alignment.center,
    //         child: Text(
    //           'We apologize for the inconvenience, but the social login feature is currently undergoing maintenance and will not be functional for the next few days. \n\nIt will be available again in our upcoming update. If you have any questions or need assistance, please feel free to connect with the Naan team on Discord at',
    //           textAlign: TextAlign.center,
    //           style:
    //               labelSmall.copyWith(color: ColorConst.NeutralVariant.shade70),
    //         ),
    //       ),
    //       0.01.vspace,
    //       BouncingWidget(
    //         onPressed: () {
    //           launchUrl(Uri.parse('https://discord.gg/wpcNRsBbxy'));
    //         },
    //         child: Align(
    //           alignment: Alignment.center,
    //           child: Text(
    //             'https://discord.gg/wpcNRsBbxy',
    //             textAlign: TextAlign.center,
    //             style: labelSmall.copyWith(
    //                 color: ColorConst.Primary,
    //                 decoration: TextDecoration.underline),
    //           ),
    //         ),
    //       ),
    //       0.03.vspace,
    //       SolidButton(
    //         title: 'Done',
    //         textColor: Colors.white,
    //         onPressed: () {
    //           Get.back();
    //         },
    //       ),
    //       0.04.vspace,
    //     ],
    //   ),
    // );
    return Web3Auth.login(socialAppName: socialAppName);
  }
}
