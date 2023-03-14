import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import 'edit_button.dart';

class TokenEditTile extends GetView<AccountSummaryController> {
  final GestureTapCallback? viewAll;
  final bool expandedTokenList;
  final GestureTapCallback? onEditTap;
  final bool? isEditable;
  final GestureTapCallback? onHideTap;
  final GestureTapCallback? onPinTap;
  final bool? isAnyTokenHidden;
  final bool? showEditButton;
  final bool? isAnyTokenPinned;
  final bool? isTokenPinnedColor;
  final bool? isTokenHiddenColor;
  final bool? showHideButton;

  const TokenEditTile({
    super.key,
    this.viewAll,
    required this.expandedTokenList,
    this.onEditTap,
    this.isEditable = false,
    this.isAnyTokenHidden = false,
    this.isAnyTokenPinned = false,
    this.onHideTap,
    this.onPinTap,
    this.showEditButton = false,
    this.isTokenHiddenColor = false,
    this.isTokenPinnedColor = false,
    this.showHideButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: isEditable ?? false,
          replacement: showEditButton!
              ? const SizedBox()
              : BouncingWidget(
                  onPressed: viewAll,
                  child: AnimatedContainer(
                    margin: EdgeInsets.symmetric(vertical: 12.aR),
                    duration: const Duration(milliseconds: 200),
                    height: 30.aR,
                    width: expandedTokenList ? 70.aR : 63.aR,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.aR),
                      color: const Color(0xff1e1c1f),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.arP,
                        ),
                        Text(
                          (expandedTokenList ? 'Less' : 'All').tr,
                          style: labelLarge.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        AnimatedRotation(
                          turns: controller.expandTokenList.isTrue ? 1 / 4 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorConst.NeutralVariant.shade60,
                            size: 20.aR,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditButtons(
                  buttonName: isAnyTokenPinned! ? 'Pin' : 'Unpin',
                  isDone: isTokenPinnedColor!,
                  onTap: onPinTap),
              if (showHideButton!) ...[
                0.02.hspace,
                EditButtons(
                  buttonName: isAnyTokenHidden! ? 'Hide' : 'Unhide',
                  isDone: isTokenHiddenColor!,
                  onTap: onHideTap,
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        expandedTokenList || showEditButton!
            ? BouncingWidget(
                onPressed: onEditTap,
                child: AnimatedContainer(
                  margin: EdgeInsets.symmetric(vertical: 12.aR),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.aR, horizontal: 16.arP),
                  duration: const Duration(milliseconds: 200),
                  // height: 30.aR,
                  // width: isEditable ?? false ? 60.aR : 50.aR,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.aR),
                    color: isEditable ?? false
                        ? ColorConst.Primary
                        : const Color(0xff1e1c1f),
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      (isEditable ?? false ? 'Done' : 'Edit').tr,
                      style: labelLarge.copyWith(
                          color: isEditable ?? false
                              ? Colors.white
                              : ColorConst.NeutralVariant.shade60),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
