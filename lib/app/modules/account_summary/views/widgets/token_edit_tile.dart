import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../controllers/account_summary_controller.dart';
import 'edit_button.dart';

class TokenEditTile extends GetView<AccountSummaryController> {
  final GestureTapCallback? viewAll;
  final bool expandedTokenList;
  final GestureTapCallback? onEditTap;
  final bool? isEditable;
  final bool? isAnyTokenSelected;
  final GestureTapCallback? onHideTap;
  final GestureTapCallback? onPinTap;

  const TokenEditTile({
    super.key,
    this.viewAll,
    required this.expandedTokenList,
    this.onEditTap,
    this.isEditable = false,
    this.isAnyTokenSelected = false,
    this.onHideTap,
    this.onPinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: isEditable ?? false,
          replacement: GestureDetector(
            onTap: viewAll,
            child: Container(
              height: 24,
              width: expandedTokenList ? 55 : 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorConst.NeutralVariant.shade30,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    expandedTokenList ? 'Less' : 'All',
                    style: labelSmall,
                  ),
                  Icon(
                    expandedTokenList
                        ? Icons.keyboard_arrow_up
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: expandedTokenList ? 14 : 10,
                  )
                ],
              ),
            ),
          ),
          child: Row(
            children: [
              0.02.hspace,
              EditButtons(
                  buttonName: 'Pin',
                  isDone: isAnyTokenSelected ?? false,
                  onTap: onPinTap),
              0.02.hspace,
              EditButtons(
                buttonName: 'Hide',
                isDone: isAnyTokenSelected ?? false,
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
                  height: 24,
                  width: isEditable ?? false ? 55 : 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isEditable ?? false
                        ? ColorConst.Primary
                        : ColorConst.NeutralVariant.shade30,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isEditable ?? false ? 'Done' : 'Edit',
                    style: labelSmall,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
