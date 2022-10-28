import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/styles/styles.dart';
import '../../../../custom_packages/custom_checkbox.dart';

class TokenCheckbox extends StatelessWidget {
  final List<AccountTokenModel> tokenModel;
  final double xtzPrice;
  final GestureTapCallback? onTap;
  final int tokenIndex;
  final void Function(bool?)? onCheckboxTap;
  final bool isEditable;
  final GestureTapCallback? onPinnedTap;
  final GestureTapCallback? onHiddenTap;
  const TokenCheckbox({
    super.key,
    required this.tokenModel,
    this.onTap,
    required this.tokenIndex,
    this.onCheckboxTap,
    this.isEditable = false,
    this.onPinnedTap,
    this.onHiddenTap,
    this.xtzPrice = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: GestureDetector(
        onTap: () {
          if (tokenModel[tokenIndex].isPinned) {
            onPinnedTap?.call();
          } else if (tokenModel[tokenIndex].isHidden) {
            onHiddenTap?.call();
          } else if (tokenModel[tokenIndex].isSelected) {
            onCheckboxTap?.call(false);
          } else {
            onCheckboxTap?.call(true);
          }
        },
        child: SizedBox(
          height: 50.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Row(
                  children: [
                    isEditable
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (tokenModel[tokenIndex].isPinned)
                                _isPinnedTokenSelector()
                              else if (tokenModel[tokenIndex].isHidden)
                                _isHiddenTokenSelector()
                              else
                                CustomCheckBox(
                                    margins: EdgeInsets.only(right: 10.sp),
                                    borderRadius: 12.sp,
                                    checkedIcon: Icons.done,
                                    borderWidth: 2,
                                    checkBoxIconSize: 12,
                                    checkBoxSize: 20.sp,
                                    borderColor: const Color(0xff1E1C1F),
                                    checkedIconColor: Colors.white,
                                    uncheckedFillColor: Colors.transparent,
                                    uncheckedIconColor: Colors.transparent,
                                    checkedFillColor:
                                        tokenModel[tokenIndex].isSelected
                                            ? ColorConst.Primary
                                            : const Color(0xff1E1C1F),
                                    value: tokenModel[tokenIndex].isSelected,
                                    onChanged: onCheckboxTap!),
                              _imageAvatar(),
                            ],
                          )
                        : _imageAvatar(),
                    0.03.hspace,
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tokenModel[tokenIndex].name!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: labelLarge.copyWith(
                                  letterSpacing: 0.5, height: 16 / 14)),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Text(
                              "${tokenModel[tokenIndex].balance.toStringAsFixed(6)} ${tokenModel[tokenIndex].symbol}",
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: labelMedium.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: ColorConst.NeutralVariant.shade60)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      r"$" +
                          (tokenModel[tokenIndex].name == "Tezos"
                                  ? tokenModel[tokenIndex].balance * xtzPrice
                                  : tokenModel[tokenIndex].balance *
                                      (tokenModel[tokenIndex].currentPrice! *
                                          xtzPrice))
                              .toStringAsFixed(6)
                              .removeTrailing0,
                      style: labelMedium.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageAvatar() => CircleAvatar(
        radius: 20.sp,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: tokenModel[tokenIndex].iconUrl!.startsWith("assets")
            ? Image.asset(
                tokenModel[tokenIndex].iconUrl!,
                fit: BoxFit.cover,
              )
            : tokenModel[tokenIndex].iconUrl!.endsWith(".svg")
                ? SvgPicture.network(
                    tokenModel[tokenIndex].iconUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(tokenModel[tokenIndex]
                                  .iconUrl!
                                  .startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${tokenModel[tokenIndex].iconUrl!.replaceAll("ipfs://", '')}"
                              : tokenModel[tokenIndex].iconUrl!)),
                    ),
                  ),
      );

  Widget _isPinnedTokenSelector() => Padding(
        padding: EdgeInsets.only(right: 10.sp),
        child: Container(
          height: 20.sp,
          width: 20.sp,
          decoration: BoxDecoration(
            color: const Color(0xff1E1C1F),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            Icons.star,
            color: ColorConst.Tertiary,
            size: 14.sp,
          ),
        ),
      );

  Widget _isHiddenTokenSelector() => Padding(
        padding: EdgeInsets.only(right: 10.sp),
        child: Container(
          height: 20.sp,
          width: 20.sp,
          decoration: BoxDecoration(
            color: const Color(0xff4A454E),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Transform.scale(
            scale: 1.2,
            child: SvgPicture.asset(
              "${PathConst.SVG}eye_hide.svg",
              color: ColorConst.NeutralVariant.shade70,
              height: 10.sp,
              width: 10.sp,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      );
}
