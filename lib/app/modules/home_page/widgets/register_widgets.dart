import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/info_stories/models/story_page/views/story_page_view.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/material_Tap.dart';
import 'account_balance/account_balance_widget.dart';
import 'dapp_search_widget/dapp_search_widget.dart';
import 'how_to_import_wallet/how_to_import_wallet_widget.dart';
import 'nft/nft_widget.dart';
import 'tez_balance_widget/tez_balance_widget.dart';
import 'tezos_headline/tezos_headline_widget.dart';
import 'token_balance/token_balance_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  StoryPageView(
    profileImagePath: MockData.naanInfoStory.values.toList(),
    storyTitle: MockData.naanInfoStory.keys.toList(),
  ),
  // const ActionButtonGroupWidget(),
  const AccountWidgets(),
  const CommunityProducts(),
  const HowToImportWalletWidget(),
  AccountBalanceWidget(),
  TokenBalanceWidget(),
  const DelegateWidget(),
  const NftWidget(),
  TezBalanceWidget(),
  const DappSearchWidget(),
  TezosHeadlineWidget(),
];

class CommunityProducts extends StatelessWidget {
  const CommunityProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.2.height,
      width: 1.width,
      child: Stack(
        children: [
          ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 165,
                      width: 0.85.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff343131),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 10,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AccountWidgets extends StatelessWidget {
  const AccountWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Wallets',
          style: titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
        ),
        13.vspace,
        SizedBox(
          width: 1.width,
          height: 0.3.height,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) => index == 10 - 1
                  ? const AddAccountWidget()
                  : const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: AccountsContainer(),
                    )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            10.hspace,
            SizedBox(
              height: 10,
              width: 0.55.width,
              child: ListView.builder(
                itemCount: 20,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: ((context, index) => index ==
                        20 - 1 //TODO Change with the last of the list
                    ? Icon(
                        Icons.add,
                        color: index ==
                                20 -
                                    1 // TODO Change with last element of the list
                            ? Colors.white
                            : ColorConst.NeutralVariant.shade20,
                        size: 10,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      )),
              ),
            ),
            const Spacer(),
            Text(
              'learn account',
              style: labelSmall.copyWith(color: ColorConst.Neutral.shade95),
            ),
          ],
        ),
      ],
    );
  }
}

class AddAccountWidget extends StatelessWidget {
  const AddAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConst.Primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 37.0, top: 66),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConst.Primary.shade60,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                  6.hspace,
                  Text(
                    'Add Account',
                    style: labelSmall,
                  ),
                ],
              ),
              16.vspace,
              Text(
                'Create new account and add to\nthe stack ',
                style: labelSmall,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AccountsContainer extends StatelessWidget {
  const AccountsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'assets/svg/accounts/account_1.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: const Alignment(-0.05, 0),
                end: const Alignment(1.5, 0),
                colors: [
                  ColorConst.Primary.shade50,
                  // const Color(0xff9961EC),
                  const Color(0xff4E4D4D).withOpacity(0),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 31.0, top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Account One',
                    style: labelSmall,
                  ),
                  10.hspace,
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 8,
                    minRadius: 8,
                  )
                ],
              ),
              8.vspace,
              Row(
                children: [
                  Text(
                    'tz...fDzg',
                    style: bodySmall,
                  ),
                  1.hspace,
                  const Icon(
                    Icons.copy,
                    size: 11,
                    color: Colors.white,
                  ),
                ],
              ),
              15.vspace,
              Row(
                children: [
                  Text(
                    '252.25',
                    style: headlineSmall,
                  ),
                  10.hspace,
                  SvgPicture.asset(
                    'assets/svg/path.svg',
                    color: Colors.white,
                    height: 20,
                    width: 15,
                  ),
                ],
              ),
              17.vspace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(),
                    elevation: 1,
                    padding: const EdgeInsets.all(8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    enableFeedback: true,
                    onPressed: () {},
                    fillColor: ColorConst.Primary.shade0,
                    shape: const CircleBorder(side: BorderSide.none),
                    child: const Icon(
                      Icons.turn_right_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  16.hspace,
                  Transform.rotate(
                    angle: -math.pi / 1,
                    child: RawMaterialButton(
                      enableFeedback: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      elevation: 1,
                      onPressed: () {},
                      fillColor: ColorConst.Primary.shade0,
                      shape: const CircleBorder(side: BorderSide.none),
                      child: const Icon(
                        Icons.turn_right_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DelegateWidget extends StatelessWidget {
  const DelegateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Delegate',
              style:
                  titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('learn',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade50)),
                  4.hspace,
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: ColorConst.NeutralVariant.shade50,
                  )
                ],
              ),
            ),
          ],
        ),
        10.vspace,
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 1.width,
            height: 0.4.height,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/svg/delegate.svg',
                  fit: BoxFit.fill,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Delegate your ',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24.sp,
                          ),
                          children: [
                            WidgetSpan(
                                style: const TextStyle(),
                                alignment: PlaceholderAlignment.middle,
                                child: SvgPicture.asset(
                                  'assets/svg/path.svg',
                                  color: Colors.white,
                                  height: 20,
                                  width: 15,
                                )),
                            TextSpan(
                                text: '\nand earn',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 22.sp)),
                            TextSpan(
                                text: ' 5% APR',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp)),
                          ],
                        ),
                      ),
                      10.vspace,
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 35.0, right: 35, top: 20, bottom: 12),
                        child: SizedBox(
                          height: 40,
                          width: 1.width,
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterStyle: const TextStyle(
                                  backgroundColor: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              hintText: 'Enter address or domain name of baker',
                              hintStyle: bodySmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70),
                              labelStyle: labelSmall,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const DelegateSelectBaker()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('View baker list', style: labelSmall),
                            6.hspace,
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      20.vspace,
                      SolidButton(
                        width: 200,
                        height: 40,
                        disabledButtonColor: ColorConst.Primary.shade50,
                        title: 'Delegate',
                        textColor: ColorConst.Primary.shade20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DelegateSelectBaker extends StatelessWidget {
  const DelegateSelectBaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Material(
        child: Container(
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                    onPressed: () => Get.back(),
                    shape: const CircleBorder(
                      side: BorderSide.none,
                    ),
                    color: ColorConst.Primary,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60, right: 32, left: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delegate to Recommended Bakers',
                      style: labelLarge,
                    ),
                    12.vspace,
                    Text(
                        'Select a Baker you want to delegate funds to.\nThis list is powered by Tezos-nodes.com',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60)),
                    12.vspace,
                    SizedBox(
                      height: 52,
                      width: 1.width,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          prefixIcon: Icon(
                            Icons.search,
                            color: ColorConst.NeutralVariant.shade60,
                            size: 22,
                          ),
                          counterStyle:
                              const TextStyle(backgroundColor: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none),
                          hintText: 'Search baker',
                          hintStyle: bodySmall.copyWith(
                              color: ColorConst.NeutralVariant.shade70),
                          labelStyle: labelSmall,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        text: TextSpan(
                            text: 'Sort by',
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60),
                            children: [
                              TextSpan(
                                  text: ' Rank',
                                  style:
                                      labelSmall.copyWith(color: Colors.white)),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: IconButton(
                                  splashRadius: 10,
                                  enableFeedback: true,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  onPressed: () =>
                                      Get.bottomSheet(NaanBottomSheet(
                                    height: 0.3.height,
                                    title: 'Set baker by:',
                                    titleAlignment: Alignment.center,
                                    titleStyle: labelLarge,
                                    bottomSheetWidgets: [
                                      Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: ColorConst
                                                  .NeutralVariant.shade60
                                                  .withOpacity(0.2),
                                            ),
                                            child: Column(
                                              children: [
                                                materialTap(
                                                  onPressed: () {},
                                                  noSplash: true,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 51,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Rank",
                                                      style: labelMedium,
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  color: Color(0xff4a454e),
                                                  height: 1,
                                                  thickness: 1,
                                                ),
                                                materialTap(
                                                  onPressed: () {},
                                                  noSplash: true,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 51,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Fees",
                                                      style: labelMedium,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: ColorConst.Primary,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    2.vspace,
                    Container(
                      height: 0.5.height,
                      width: 1.width,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                                  colors: [
                                const Color(0xff100919),
                                const Color(0xff100919).withOpacity(0),
                              ],
                                  begin: const Alignment(0, 1),
                                  end: const Alignment(0, 0.7))
                              .createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 6,
                            cacheExtent: 4,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    width: 338,
                                    height: 108,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff958e99)
                                          .withOpacity(0.2),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor:
                                                  ColorConst.Primary,
                                              radius: 12,
                                            ),
                                            6.hspace,
                                            Text(
                                              'MyTezosBaking',
                                              style: labelMedium,
                                            ),
                                            const Spacer(),
                                            Text(
                                              'tz1d6....pVok8',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst.Primary),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.copy,
                                                color: ColorConst.Primary,
                                                size: 12,
                                              ),
                                              iconSize: 12,
                                              constraints:
                                                  const BoxConstraints(),
                                            )
                                          ],
                                        ),
                                        13.vspace,
                                        Row(
                                          children: [
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Baker fee:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '14%',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                            31.hspace,
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Staking:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '116K',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                            31.hspace,
                                            RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text: 'Payout:\n',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70),
                                                children: [
                                                  TextSpan(
                                                      text: '30 Days*',
                                                      style: labelLarge)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    2.vspace,
                    Text(
                      '*All payout periods are converted from cycle to days.\n1 cycle = approx. 2.5 days',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 32.0, left: 32, right: 32),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SolidButton(
                    height: 0.06.height,
                    width: 0.75.width,
                    title: 'Next',
                    textColor: ColorConst.NeutralVariant.shade60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
