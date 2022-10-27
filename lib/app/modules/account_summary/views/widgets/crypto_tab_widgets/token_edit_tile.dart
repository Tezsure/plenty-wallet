import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../controllers/account_summary_controller.dart';
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
      children: [
        Visibility(
          visible: isEditable ?? false,
          replacement: showEditButton!
              ? const SizedBox()
              : GestureDetector(
                  onTap: viewAll,
                  child: Container(
                    height: 28.sp,
                    width: expandedTokenList ? 70.sp : 58.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff1e1c1f),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: expandedTokenList
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          expandedTokenList ? 'Less' : 'All',
                          style: labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        0.002.hspace,
                        Icon(
                          expandedTokenList
                              ? Icons.keyboard_arrow_down
                              : Icons.arrow_forward_ios,
                          color: ColorConst.NeutralVariant.shade60,
                          size: expandedTokenList ? 20.sp : 12.sp,
                        )
                      ],
                    ),
                  ),
                ),
          child: Row(
            children: [
              0.02.hspace,
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
        expandedTokenList
            ? GestureDetector(
                onTap: onEditTap,
                child: Container(
                  height: 28.sp,
                  width: isEditable ?? false ? 60.sp : 50.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
            : showEditButton!
                ? GestureDetector(
                    onTap: onEditTap,
                    child: Container(
                      height: 28.sp,
                      width: 60.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isEditable ?? false
                            ? ColorConst.Primary
                            : const Color(0xff1e1c1f),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isEditable ?? false ? 'Done' : 'Edit',
                        style: labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
      ],
    );
  }
}
