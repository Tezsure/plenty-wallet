import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/constants/path_const.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 48.sp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  isEditable
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (tokenModel[tokenIndex].isPinned)
                              GestureDetector(
                                onTap: onPinnedTap,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.sp, right: 10.sp),
                                  child: Container(
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
                                ),
                              )
                            else if (tokenModel[tokenIndex].isHidden)
                              GestureDetector(
                                onTap: onHiddenTap,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.sp, right: 10.sp),
                                  child: Container(
                                    height: 20.sp,
                                    width: 20.sp,
                                    decoration: BoxDecoration(
                                      color: ColorConst.NeutralVariant.shade40,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SvgPicture.asset(
                                      "${PathConst.HOME_PAGE.SVG}eye_hide.svg",
                                      color: ColorConst.NeutralVariant.shade70,
                                      height: 10.sp,
                                      width: 10.sp,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Transform.scale(
                                  scale: 1.sp,
                                  child: Checkbox(
                                    shape: const CircleBorder(),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    value: tokenModel[tokenIndex].isSelected,
                                    onChanged: onCheckboxTap,
                                    fillColor: MaterialStateProperty.all<Color>(
                                        tokenModel[tokenIndex].isSelected
                                            ? ColorConst.Primary
                                            : const Color(0xff1E1C1F)),
                                  ),
                                ),
                              ),
                            CircleAvatar(
                              radius: 20.sp,
                              backgroundColor: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.2),
                              child: tokenModel[tokenIndex]
                                      .iconUrl!
                                      .startsWith("assets")
                                  ? Image.asset(
                                      tokenModel[tokenIndex].iconUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : tokenModel[tokenIndex]
                                          .iconUrl!
                                          .endsWith(".svg")
                                      ? SvgPicture.network(
                                          tokenModel[tokenIndex].iconUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(tokenModel[
                                                            tokenIndex]
                                                        .iconUrl!
                                                        .startsWith("ipfs")
                                                    ? "https://ipfs.io/ipfs/${tokenModel[tokenIndex].iconUrl!.replaceAll("ipfs://", '')}"
                                                    : tokenModel[tokenIndex]
                                                        .iconUrl!)),
                                          ),
                                        ),
                            ),
                          ],
                        )
                      : CircleAvatar(
                          radius: 20.sp,
                          backgroundColor: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          child: tokenModel[tokenIndex]
                                  .iconUrl!
                                  .startsWith("assets")
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
                                            image: NetworkImage(tokenModel[
                                                        tokenIndex]
                                                    .iconUrl!
                                                    .startsWith("ipfs")
                                                ? "https://ipfs.io/ipfs/${tokenModel[tokenIndex].iconUrl!.replaceAll("ipfs://", '')}"
                                                : tokenModel[tokenIndex]
                                                    .iconUrl!)),
                                      ),
                                    ),
                        ),
                  0.03.hspace,
                  RichText(
                      text: TextSpan(
                          text: "${tokenModel[tokenIndex].name!}\n",
                          style: labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: tokenModel[tokenIndex].name!.length > 25
                                  ? 12.sp
                                  : 14.sp),
                          children: [
                        WidgetSpan(child: 0.025.vspace),
                        TextSpan(
                            text:
                                "${tokenModel[tokenIndex].balance.toStringAsFixed(6)} ${tokenModel[tokenIndex].symbol}",
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60)),
                      ])),
                  const Spacer(),
                  Text(
                    r"$" +
                        (tokenModel[tokenIndex].name == "Tezos"
                                ? xtzPrice
                                : (tokenModel[tokenIndex].currentPrice! *
                                    xtzPrice))
                            .toStringAsFixed(6)
                            .removeTrailing0,
                    style: labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
