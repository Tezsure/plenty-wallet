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
  final AccountTokenModel tokenModel;
  final double xtzPrice;
  final GestureTapCallback? onTap;
  final void Function()? onCheckboxTap;
  final bool isEditable;
  const TokenCheckbox({
    super.key,
    required this.tokenModel,
    this.onTap,
    this.onCheckboxTap,
    this.isEditable = false,
    this.xtzPrice = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.aR),
      child: GestureDetector(
        onTap: onCheckboxTap,
        child: SizedBox(
          height: 50.aR,
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
                              if (tokenModel.isSelected)
                                _checkBox()
                              else if (tokenModel.isPinned)
                                _isPinnedTokenSelector()
                              else if (tokenModel.isHidden)
                                _isHiddenTokenSelector()
                              else
                                _checkBox(),
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
                          Text(tokenModel.name!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              style: labelLarge.copyWith(
                                  letterSpacing: 0.5.aR,
                                  fontSize: 14.aR,
                                  height: 16 / 14)),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Text(
                              "${tokenModel.balance.toStringAsFixed(6)} ${tokenModel.symbol}",
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: labelMedium.copyWith(
                                  fontSize: 12.aR,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConst.NeutralVariant.shade60)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      r"$" +
                          (tokenModel.name == "Tezos"
                                  ? tokenModel.balance * xtzPrice
                                  : tokenModel.balance *
                                      (tokenModel.currentPrice! * xtzPrice))
                              .toStringAsFixed(6)
                              .removeTrailing0,
                      style: labelMedium.copyWith(
                          fontSize: 12.aR, fontWeight: FontWeight.w400),
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

  Widget _checkBox() => CustomCheckBox(
      margins: EdgeInsets.only(right: 10.aR),
      borderRadius: 12.aR,
      checkedIcon: Icons.done,
      borderWidth: 2,
      checkBoxIconSize: 12.aR,
      checkBoxSize: 20.aR,
      borderColor: const Color(0xff1E1C1F),
      checkedIconColor: Colors.white,
      uncheckedFillColor: Colors.transparent,
      uncheckedIconColor: Colors.transparent,
      checkedFillColor:
          tokenModel.isSelected ? ColorConst.Primary : const Color(0xff1E1C1F),
      value: tokenModel.isSelected,
      onChanged: (v) => onCheckboxTap);

  Widget _imageAvatar() => CircleAvatar(
        radius: 20.aR,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: tokenModel.iconUrl!.startsWith("assets")
            ? Image.asset(
                tokenModel.iconUrl!,
                fit: BoxFit.cover,
              )
            : tokenModel.iconUrl!.endsWith(".svg")
                ? SvgPicture.network(
                    tokenModel.iconUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(tokenModel.iconUrl!
                                  .startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${tokenModel.iconUrl!.replaceAll("ipfs://", '')}"
                              : tokenModel.iconUrl!)),
                    ),
                  ),
      );

  Widget _isPinnedTokenSelector() => Padding(
        padding: EdgeInsets.only(right: 10.aR),
        child: Container(
          height: 20.aR,
          width: 20.aR,
          decoration: BoxDecoration(
            color: const Color(0xff1E1C1F),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            Icons.star,
            color: ColorConst.Tertiary,
            size: 14.aR,
          ),
        ),
      );

  Widget _isHiddenTokenSelector() => Padding(
        padding: EdgeInsets.only(right: 10.aR),
        child: Container(
          height: 20.aR,
          width: 20.aR,
          decoration: BoxDecoration(
            color: const Color(0xff4A454E),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Transform.scale(
            scale: 1.2,
            child: SvgPicture.asset(
              "${PathConst.SVG}eye_hide.svg",
              color: ColorConst.NeutralVariant.shade70,
              height: 10.aR,
              width: 10.aR,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      );
}
