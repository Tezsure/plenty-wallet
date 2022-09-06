import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/account_summary_controller.dart';
import 'widgets/delegate_tile.dart';
import 'widgets/token_edit_tile.dart';

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
                    isScrollable: true,
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
                  const CryptoTabPage(),
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
}

class CryptoTabPage extends GetView<AccountSummaryController> {
  const CryptoTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Visibility(
                  visible: controller.pinnedTokenList.isNotEmpty,
                  replacement: const SizedBox(),
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.pinnedTokenList.length,
                    itemBuilder: (_, index) => tokenWidget(
                      tokenModel: controller.pinnedTokenList,
                      tokenIndex: index,
                    ),
                  ),
                )),
            0.03.vspace,
            Text(
              'All Tokens',
              style: labelLarge.copyWith(color: ColorConst.Primary.shade95),
            ),
            Obx(
              () => ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: controller.expandTokenList.value
                    ? controller.tokens.length
                    : 3,
                itemBuilder: (_, index) => tokenWidget(
                  tokenModel: controller.tokens,
                  tokenIndex: index,
                  onCheckboxTap: (value) {
                    controller
                      ..tokens[index].isSelected = value ?? false
                      ..tokens.refresh();
                  },
                ),
              ),
            ),
            0.03.vspace,
            Obx(
              () => TokenEditTile(
                viewAll: () => controller.expandTokenList.value =
                    !controller.expandTokenList.value,
                expandedTokenList: controller.expandTokenList.value,
                isEditable: controller.isEditable.value,
                onEditTap: () =>
                    controller.isEditable.value = !controller.isEditable.value,
                isAnyTokenSelected: controller.tokens.any(
                  (element) => element.isSelected,
                ),
                onPinTap: () {
                  controller
                    ..pinnedTokenList.addAll(
                      controller.tokens.where(
                        (element) => element.isSelected,
                      ),
                    )
                    ..tokens.removeWhere(
                      (element) => element.isSelected,
                    )
                    ..pinnedTokenList.forEach((element) {
                      element.isPinned = true;
                    })
                    ..tokens.refresh()
                    ..pinnedTokenList.refresh()
                    ..isEditable.value = false;
                },
                onHideTap: () {
                  List<TokenModel> hiddenToken =
                      controller.tokens.where((e) => e.isSelected).toList();

                  controller
                    ..tokens.removeWhere(
                      (element) => element.isSelected,
                    )
                    ..tokens.addAll(hiddenToken)
                    ..tokens.refresh()
                    ..isEditable.value = false;
                },
              ),
            ),
            0.03.vspace,
            Text(
              'Delegate',
              style: labelLarge.copyWith(color: ColorConst.Primary.shade95),
            ),
            0.02.vspace,
            const DelegateTile(
              isDelegated: true,
            ),
            0.02.vspace
          ],
        ),
      ),
    );
  }

  Padding tokenWidget({
    required List<TokenModel> tokenModel,
    GestureTapCallback? onTap,
    required int tokenIndex,
    void Function(bool?)? onCheckboxTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 0.06.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                trailing: Container(
                  height: 0.03.height,
                  width: 0.14.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  child: Text(
                    "\$${tokenModel[tokenIndex].balance}",
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ),
                leading: Obx(() => Visibility(
                      visible: controller.isEditable.value,
                      replacement: Visibility(
                        visible: tokenModel[tokenIndex].isPinned,
                        replacement: CircleAvatar(
                          radius: 22,
                          backgroundColor: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          child: SvgPicture.asset(
                            tokenModel[tokenIndex].imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: SizedBox(
                          width: 0.2.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 20.sp,
                                width: 20.sp,
                                decoration: BoxDecoration(
                                  color: ColorConst.NeutralVariant.shade40,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: ColorConst.Tertiary,
                                  size: 14.sp,
                                ),
                              ),
                              0.025.hspace,
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: ColorConst
                                    .NeutralVariant.shade60
                                    .withOpacity(0.2),
                                child: SvgPicture.asset(
                                  tokenModel[tokenIndex].imagePath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: tokenModel[tokenIndex].isSelected,
                            replacement: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: tokenModel[tokenIndex].isSelected,
                              onChanged: onCheckboxTap,
                              fillColor: MaterialStateProperty.all<Color>(
                                  tokenModel[tokenIndex].isSelected
                                      ? ColorConst.Primary
                                      : ColorConst.NeutralVariant.shade40),
                            ),
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: tokenModel[tokenIndex].isSelected,
                              onChanged: onCheckboxTap,
                              fillColor: MaterialStateProperty.all<Color>(
                                  tokenModel[tokenIndex].isSelected
                                      ? ColorConst.Primary
                                      : ColorConst.NeutralVariant.shade40),
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            child: SvgPicture.asset(
                              tokenModel[tokenIndex].imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    )),
                title: Text(
                  tokenModel[tokenIndex].tokenName,
                  style: labelSmall,
                ),
                subtitle: Text(
                  "${tokenModel[tokenIndex].price}",
                  style: labelSmall.apply(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                ),
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
