import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/account_summary_controller.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  AccountSummaryView({super.key});
  @override
  final controller = Get.put(AccountSummaryController());
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              0.01.vspace,
              Center(
                child: Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
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
                            backgroundColor: ColorConst.NeutralVariant.shade20,
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
                            primary: false,
                            shrinkWrap: true,
                            itemCount: 5,
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
                          const DelegateTile(
                            isDelegated: true,
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

class DelegateTile extends StatelessWidget {
  final bool isDelegated;
  const DelegateTile({
    Key? key,
    required this.isDelegated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff958e99).withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Rewards\n',
                      style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: isDelegated ? '10 ' : '0.00 ',
                          style: headlineSmall.copyWith(
                            color: isDelegated
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.bottom,
                            child: Visibility(
                              replacement: SvgPicture.asset(
                                "${PathConst.HOME_PAGE.SVG}xtz.svg",
                                height: 20,
                                width: 15,
                              ),
                              visible: isDelegated,
                              child: GestureDetector(
                                onTap: () => Get.bottomSheet(
                                    const ReDelegatePage(),
                                    isScrollControlled: true,
                                    enableDrag: true),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      "${PathConst.HOME_PAGE.SVG}xtz.svg",
                                      height: 20,
                                      width: 15,
                                    ),
                                    0.01.hspace,
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            )),
                        TextSpan(
                          text: isDelegated ? '\n\$23' : '\n\$0.00',
                          style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60,
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
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: isDelegated ? '15 ' : '0.0 ',
                          style: headlineSmall.copyWith(
                            color: isDelegated
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                        TextSpan(text: 'D', style: headlineSmall),
                        TextSpan(
                          text: isDelegated ? '\n1.2 cycles' : '\n\$0.0 cycles',
                          style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 0.032.height,
                width: 0.25.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.Neutral.shade30,
                ),
                child: Center(
                  child: Text(
                    isDelegated ? 'Earning 8% APR' : 'Earn 5% APR',
                    textAlign: TextAlign.center,
                    style: labelSmall.copyWith(
                      color: ColorConst.Neutral.shade70,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: isDelegated
                    ? () => Get.bottomSheet(
                        const DelegateSelectBaker(isScrollable: true),
                        isScrollControlled: true,
                        enableDrag: true)
                    : () => Get.bottomSheet(NaanBottomSheet(
                          height: 0.3.height,
                          bottomSheetWidgets: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Get 5% APR on your Tez\n',
                                style: headlineSmall,
                                children: [
                                  WidgetSpan(child: 0.04.vspace),
                                  TextSpan(
                                    text:
                                        'Your funds are neither locked nor frozen and do not move anywhere. You can spend them at\nany time and without any delay',
                                    style: bodySmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60),
                                  ),
                                ],
                              ),
                            ),
                            0.04.vspace,
                            SolidButton(
                                title: 'Delegate',
                                onPressed: () =>
                                    Get.to(() => const DelegateSelectBaker())
                                        ?.whenComplete(() => Get.back()))
                          ],
                        )),
                child: Container(
                  height: 0.032.height,
                  width: 0.25.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.Primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isDelegated ? 'Re-delegate' : 'Delegate',
                        style: labelSmall,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
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
    );
  }
}

class ReDelegatePage extends StatelessWidget {
  const ReDelegatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.95.height,
      width: 1.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        gradient: GradConst.GradientBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.01.vspace,
          Center(
            child: Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
          ),
          0.02.vspace,
          Center(
            child: Text(
              'Rewards',
              style: titleMedium,
            ),
          ),
          0.02.vspace,
          const Center(child: ReDelegateTile()),
          Padding(
            padding: EdgeInsets.all(14.sp),
            child: Text('Rewards', style: titleMedium),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 0.63.height,
                width: 0.94.width,
                child: ListView.builder(
                  itemCount: 6,
                  primary: false,
                  shrinkWrap: false,
                  itemBuilder: (_, index) => const DelegateRewardsTile(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReDelegateTile extends StatelessWidget {
  const ReDelegateTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.94.width,
      height: 0.16.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff958e99).withOpacity(0.2),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 0.04.width, vertical: 0.01.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset(
                  'assets/temp/delegate_baker.png',
                  fit: BoxFit.cover,
                  width: 40.sp,
                  height: 40.sp,
                ),
              ),
              0.02.hspace,
              RichText(
                  text: TextSpan(
                      text: 'MyTezosBaking\n',
                      style: labelMedium,
                      children: [
                    TextSpan(
                      text: 'tz1d6....pVok8',
                      style: labelSmall.copyWith(color: ColorConst.Primary),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.copy,
                          color: ColorConst.Primary,
                          size: 10,
                        ),
                        iconSize: 10,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ])),
              const Spacer(),
              SolidButton(
                height: 0.03.height,
                width: 0.24.width,
                child: Text('Redelegate', style: labelSmall),
                onPressed: () => Get.bottomSheet(
                        const DelegateSelectBaker(
                          isScrollable: true,
                        ),
                        enableDrag: true,
                        isScrollControlled: true)
                    .whenComplete(() => Get.back()),
              ),
            ],
          ),
          0.013.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Baker fee:\n',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade70),
                  children: [TextSpan(text: '14%', style: labelLarge)],
                ),
              ),
              0.12.hspace,
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Staking:\n',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade70),
                  children: [TextSpan(text: '116K', style: labelLarge)],
                ),
              ),
              0.12.hspace,
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Payout:\n',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade70),
                  children: [TextSpan(text: '30 Days', style: labelLarge)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DelegateRewardsTile extends StatelessWidget {
  const DelegateRewardsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 0.9.width,
      height: 0.2.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff958e99).withOpacity(0.2),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 0.04.width, vertical: 0.01.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset(
                  'assets/temp/delegate_baker.png',
                  fit: BoxFit.cover,
                  width: 40.sp,
                  height: 40.sp,
                ),
              ),
              0.02.hspace,
              RichText(
                  text: TextSpan(
                      text: 'MyTezosBaking\n',
                      style: labelMedium,
                      children: [
                    TextSpan(
                      text: 'tz1d6....pVok8',
                      style: labelSmall.copyWith(color: ColorConst.Primary),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.copy,
                          color: ColorConst.Primary,
                          size: 10,
                        ),
                        iconSize: 10,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ])),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '504',
                    style: labelSmall,
                  ),
                  const Icon(
                    Icons.hourglass_empty,
                    color: ColorConst.Primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          0.013.vspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Delegated:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '100 tez', style: labelLarge)],
                    ),
                  ),
                  0.12.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Rewards:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '2 tez', style: labelLarge)],
                    ),
                  ),
                  0.12.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Baker fee:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '14%', style: labelLarge)],
                    ),
                  ),
                ],
              ),
              0.013.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Expected Payout:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '10 tez', style: labelLarge)],
                    ),
                  ),
                  0.03.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Status\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: 'Pending', style: labelLarge)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
