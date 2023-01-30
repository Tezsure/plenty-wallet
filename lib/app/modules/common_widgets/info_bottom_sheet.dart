import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/mock/mock_data.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class InfoBottomSheet extends StatelessWidget {
  const InfoBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
        height: AppConstant.naanBottomSheetHeight,
        blurRadius: 5,
        initialChildSize: 0.89,
        minChildSize: 0.89,
        maxChildSize: 0.89,
        gradientStartingOpacity: 1,
        isDraggableBottomSheet: true,
        title: 'Introduction to crypto wallet',
        draggableListBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.arP),
            child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${MockData.walletInfo.keys.elementAt(index)}\n',
                  style: titleSmall,
                  children: [
                    TextSpan(
                      text:
                          "\n${MockData.walletInfo.values.elementAt(index)}\n",
                      style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
