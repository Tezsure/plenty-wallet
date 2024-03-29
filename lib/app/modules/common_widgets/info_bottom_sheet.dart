import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/mock/mock_data.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class InfoBottomSheet extends StatelessWidget {
  final bool isWatchAddress;
  const InfoBottomSheet({
    Key? key,
    this.isWatchAddress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight,
      titleAlignment: Alignment.centerLeft,
      title: isWatchAddress ? 'Watch addresses' : 'Introduction to Crypto',
      // blurRadius: 5,
      // isDraggableBottomSheet: true,
      // title: 'Introduction to crypto wallet',
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 0.02.vspace,
              // Text(
              //   isWatchAddress ? 'Watch addresses' : 'Introduction to Crypto',
              //   textAlign: TextAlign.center,
              //   style: titleLarge,
              // ),
              0.02.vspace,
              Expanded(
                child: RawScrollbar(
                    radius: const Radius.circular(2),
                    trackRadius: const Radius.circular(2),
                    thickness: 4,
                    thumbVisibility: false,
                    thumbColor: ColorConst.NeutralVariant.shade60,
                    trackColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    trackBorderColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    child: ListView.builder(
                      shrinkWrap: true,
                      // controller: scrollController,
                      physics: AppConstant.scrollPhysics,
                      itemCount: isWatchAddress ? 4 : 6,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 16.arP),
                          child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: isWatchAddress
                                    ? '${MockData.watchAddress.keys.elementAt(index).tr}\n'
                                    : '${MockData.walletInfo.keys.elementAt(index).tr}\n',
                                style: titleSmall,
                                children: [
                                  TextSpan(
                                    text: isWatchAddress
                                        ? "\n${MockData.watchAddress.values.elementAt(index).tr}\n"
                                        : "\n${MockData.walletInfo.values.elementAt(index).tr}\n",
                                    style: bodySmall.copyWith(
                                      color: ColorConst.NeutralVariant.shade60,
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
