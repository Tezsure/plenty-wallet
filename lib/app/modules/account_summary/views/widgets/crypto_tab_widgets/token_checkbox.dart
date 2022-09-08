import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/constants/path_const.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../../../data/services/service_models/token_model.dart';

class TokenCheckbox extends StatelessWidget {
  final List<TokenModel> tokenModel;
  final GestureTapCallback? onTap;
  final int tokenIndex;
  final void Function(bool?)? onCheckboxTap;
  final bool isEditable;
  const TokenCheckbox({
    super.key,
    required this.tokenModel,
    this.onTap,
    required this.tokenIndex,
    this.onCheckboxTap,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
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
                leading: isEditable
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (tokenModel[tokenIndex].isSelected) ...[
                            if (tokenModel[tokenIndex].isPinned)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
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
                              )
                            else if (tokenModel[tokenIndex].isHidden)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
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
                                    height: 10,
                                    width: 10,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            else
                              Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: tokenModel[tokenIndex].isSelected,
                                onChanged: onCheckboxTap,
                                fillColor: MaterialStateProperty.all<Color>(
                                    tokenModel[tokenIndex].isSelected
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade40),
                              ),
                          ] else
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: tokenModel[tokenIndex].isSelected,
                              onChanged: onCheckboxTap,
                              fillColor: MaterialStateProperty.all<Color>(
                                  tokenModel[tokenIndex].isSelected
                                      ? ColorConst.Primary
                                      : ColorConst.NeutralVariant.shade40),
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
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                        child: SvgPicture.asset(
                          tokenModel[tokenIndex].imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
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
