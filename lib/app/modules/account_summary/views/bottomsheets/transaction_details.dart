import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TransactionDetailsBottomSheet extends StatelessWidget {
  const TransactionDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 50,
      width: 1.width,
      height: 0.42.height,
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 1,
      bottomSheetWidgets: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Transaction Details\n',
                style: titleMedium,
                children: [
                  WidgetSpan(child: 0.03.vspace),
                  TextSpan(
                      text: '15/08/2022 19:50\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60)),
                  WidgetSpan(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 0.015.height),
                        width: 0.32.width,
                        height: 0.03.height,
                        decoration: BoxDecoration(
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('view on tzkt.io',
                                style: labelSmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60)),
                            Icon(
                              Icons.open_in_new_rounded,
                              size: 12.sp,
                              color: ColorConst.NeutralVariant.shade60,
                            )
                          ],
                        )),
                  ),
                ]),
          ),
        ),
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(
            '+18.267',
            style: headlineSmall.copyWith(color: ColorConst.naanCustomColor),
          ),
          subtitle: Text(
            '\$23.21',
            style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
          ),
          trailing: SvgPicture.asset(
            'assets/svg/tez.svg',
            height: 45.sp,
          ),
        ),
        ListTile(
            leading: Container(
              height: 0.03.height,
              width: 0.1.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
              child: Center(
                child: Text(
                  'from',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ),
            trailing: SvgPicture.asset('assets/svg/chevron_down.svg')),
        ListTile(
            title: Row(
              children: [
                Text(
                  'tz1K...pkDZ',
                  style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
                ),
                0.02.hspace,
                Icon(
                  Icons.copy,
                  color: ColorConst.Primary.shade60,
                  size: 16.sp,
                ),
              ],
            ),
            trailing: SvgPicture.asset('assets/svg/send.svg')),
        0.02.vspace,
      ],
    );
  }
}
