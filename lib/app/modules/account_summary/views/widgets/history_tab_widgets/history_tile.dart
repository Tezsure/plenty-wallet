import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/constants/path_const.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../../../../utils/utils.dart';
import '../../account_summary_view.dart';

class HistoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final HistoryStatus status;
  const HistoryTile({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.03.width, vertical: 0.003.height),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
                radius: 20.sp,
                backgroundColor: ColorConst.Tertiary,
                child: SvgPicture.asset('${PathConst.SVG}tez.svg')),
            title: Text(
              status == HistoryStatus.inProgress
                  ? '- - Sending'
                  : status.name.capitalizeFirst ?? '',
              style: labelMedium.copyWith(
                color: status == HistoryStatus.inProgress
                    ? ColorConst.Primary.shade60
                    : Colors.white,
              ),
            ),
            subtitle: Text(
              tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  text: status == HistoryStatus.receive
                      ? '+18.267\n'
                      : '-18.267\n',
                  style: labelMedium.copyWith(
                    color: status == HistoryStatus.receive
                        ? ColorConst.naanCustomColor
                        : Colors.white,
                  ),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                        text: '\$23.21',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
