import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
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

  const TokenEditTile(
      {super.key,
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
      this.isTokenPinnedColor = false});

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
              : GestureDetector(
                  onTap: viewAll,
                  child: AnimatedContainer(
                    margin: EdgeInsets.symmetric(vertical: 12.sp),
                    duration: const Duration(milliseconds: 200),
                    height: 30.sp,
                    width: expandedTokenList ? 70.sp : 63.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.sp),
                      color: const Color(0xff1e1c1f),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          expandedTokenList ? 'Less' : 'All',
                          style: labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              height: 16 / 14,
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        AnimatedRotation(
                          turns: controller.expandTokenList.isTrue ? 1 / 4 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorConst.NeutralVariant.shade60,
                            size: 20.sp,
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
              0.02.hspace,
              EditButtons(
                buttonName: isAnyTokenHidden! ? 'Hide' : 'Unhide',
                isDone: isTokenHiddenColor!,
                onTap: onHideTap,
              ),
            ],
          ),
        ),
        const Spacer(),
        expandedTokenList || showEditButton!
            ? GestureDetector(
                onTap: onEditTap,
                child: AnimatedContainer(
                  margin: EdgeInsets.symmetric(vertical: 12.sp),
                  duration: const Duration(milliseconds: 200),
                  height: 30.sp,
                  width: isEditable ?? false ? 60.sp : 50.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: isEditable ?? false
                        ? ColorConst.Primary
                        : const Color(0xff1e1c1f),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isEditable ?? false ? 'Done' : 'Edit',
                    style: labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEditable ?? false
                            ? Colors.white
                            : ColorConst.NeutralVariant.shade60),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
