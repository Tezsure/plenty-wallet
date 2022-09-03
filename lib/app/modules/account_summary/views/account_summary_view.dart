import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/account_summary_controller.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  const AccountSummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 1.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/temp/account_profile.png',
                    fit: BoxFit.contain,
                    height: 40,
                    width: 40,
                  ),
                  title: SizedBox(
                    height: 20,
                    width: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'My Main Account',
                          style: labelMedium,
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'.addressShortner(),
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  trailing: SizedBox(
                    height: 20,
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.content_copy_outlined,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.qr_code_scanner_sharp,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                0.02.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('254.00', style: headlineSmall),
                    const SizedBox(width: 5),
                    SvgPicture.asset(
                      "${PathConst.HOME_PAGE.SVG}xtz.svg",
                      height: 20,
                      width: 15,
                    )
                  ],
                ),
                0.03.vspace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: CircleAvatar(
                                  backgroundColor:
                                      ColorConst.NeutralVariant.shade20,
                                  radius: 15,
                                  child: Text('\$',
                                      style: TextStyle(
                                          color: ColorConst.Primary.shade90)))),
                          const WidgetSpan(
                            child: SizedBox(
                              width: 8,
                            ),
                          ),
                          TextSpan(
                              text: 'Buy',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
                        ],
                      ),
                    ),
                    0.10.hspace,
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: CircleAvatar(
                              backgroundColor:
                                  ColorConst.NeutralVariant.shade20,
                              radius: 15,
                              child: Icon(
                                Icons.arrow_upward,
                                color: ColorConst.Primary.shade90,
                                size: 20,
                              ),
                            ),
                          ),
                          const WidgetSpan(
                            child: SizedBox(
                              width: 8,
                            ),
                          ),
                          TextSpan(
                              text: 'Send',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
                        ],
                      ),
                    ),
                    0.10.hspace,
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: CircleAvatar(
                                backgroundColor:
                                    ColorConst.NeutralVariant.shade20,
                                radius: 15,
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: ColorConst.Primary.shade90,
                                  size: 20,
                                ),
                              )),
                          const WidgetSpan(
                            child: SizedBox(
                              width: 8,
                            ),
                          ),
                          TextSpan(
                              text: 'Receive',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
                        ],
                      ),
                    ),
                  ],
                ),
                0.03.vspace,
                Divider(
                  height: 20,
                  color: ColorConst.NeutralVariant.shade20,
                  endIndent: 20,
                  indent: 20,
                ),
                SizedBox(
                  height: 50,
                  child: TabBar(
                      labelColor: ColorConst.Primary.shade95,
                      indicatorColor: ColorConst.Primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      enableFeedback: true,
                      unselectedLabelColor: ColorConst.NeutralVariant.shade60,
                      tabs: const [
                        Tab(text: "Crypto"),
                        Tab(text: "NFTs"),
                        Tab(text: "History"),
                      ]),
                ),
                Expanded(
                  child: TabBarView(children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (_, index) =>
                                  tokenWidget(controller.tokens[index], () {}),
                            ),
                            0.03.vspace,
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 24,
                                width: false ? 55 : 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: ColorConst.NeutralVariant.shade30,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      false ? 'Less' : 'All',
                                      style: labelSmall,
                                    ),
                                    const Icon(
                                      false
                                          ? Icons.keyboard_arrow_up
                                          : Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            0.03.vspace,
                            Text(
                              'Delegate',
                              style: labelLarge.copyWith(
                                  color: ColorConst.Primary.shade95),
                            ),
                            0.02.vspace,
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xff958e99).withOpacity(0.2),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Rewards\n',
                                              style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade60,
                                              ),
                                              children: [
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    height: 30,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '0.00 ',
                                                  style: headlineSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant.shade60,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .bottom,
                                                    child: SvgPicture.asset(
                                                      "${PathConst.HOME_PAGE.SVG}xtz.svg",
                                                      height: 20,
                                                      width: 15,
                                                    )),
                                                TextSpan(
                                                  text: '\n\$0.00',
                                                  style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant.shade60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.end,
                                            text: TextSpan(
                                              text: 'Payout\n',
                                              style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade60,
                                              ),
                                              children: [
                                                const WidgetSpan(
                                                  child: SizedBox(
                                                    height: 30,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '0.0 ',
                                                  style: headlineSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant.shade60,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: 'D',
                                                    style: headlineSmall),
                                                TextSpan(
                                                  text: '\n\$0.0 cycles',
                                                  style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant.shade60,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                    color: ColorConst.Neutral.shade30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ColorConst.Neutral.shade30,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Earn 5% APR',
                                            textAlign: TextAlign.center,
                                            style: labelSmall.copyWith(
                                              color: ColorConst.Neutral.shade70,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Get.bottomSheet(NaanBottomSheet(
                                          height: 0.3.height,
                                          bottomSheetWidgets: [
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text:
                                                    'Get 5% APR on your Tez\n',
                                                style: headlineSmall,
                                                children: [
                                                  WidgetSpan(
                                                      child: 0.04.vspace),
                                                  TextSpan(
                                                    text:
                                                        'Your funds are neither locked nor frozen and do not move anywhere. You can spend them at\nany time and without any delay',
                                                    style: bodySmall.copyWith(
                                                        color: ColorConst
                                                            .NeutralVariant
                                                            .shade60),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            0.04.vspace,
                                            SolidButton(
                                              title: 'Delegate',
                                              onPressed: () {},
                                            )
                                          ],
                                        )),
                                        child: Container(
                                          height: 25,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: ColorConst.Primary,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Delegate',
                                                style: labelSmall,
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: Colors.white,
                                                size: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            0.02.vspace
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding tokenWidget(
    TokenModel tokenModel,
    GestureTapCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 0.06.height,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          trailing: Container(
            height: 0.03.height,
            width: 0.14.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text(
              "\$${tokenModel.balance}",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: SvgPicture.asset(
              tokenModel.imagePath,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            tokenModel.tokenName,
            style: labelSmall,
          ),
          subtitle: Text(
            "${tokenModel.price}",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
