import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';

class TestNetworkBottomSheet extends StatelessWidget {
  const TestNetworkBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${PathConst.SETTINGS_PAGE.SVG}node.svg",
              width: 45.arP,
            ),
            Text(
              "Connection Failed",
              style: titleSmall.copyWith(color: ColorConst.Error),
            ),
            Text(
              "You are connecting from an account on test net.\nThis feature supports  only main net connection. ",
              style: labelMedium.copyWith(color: ColorConst.textGrey1),
            ),
            Text(
              "Select Network",
              style: labelMedium.copyWith(color: ColorConst.textGrey1),
            )
          ],
        )
      ],
    );
  }
}
