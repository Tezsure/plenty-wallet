import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class TransactionDetailsBottomSheet extends StatelessWidget {
  final TxHistoryModel transactionModel;

  const TransactionDetailsBottomSheet(
      {super.key, required this.transactionModel});

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
                  WidgetSpan(child: 0.02.vspace),
                  TextSpan(
                      text:
                          "${DateTime.parse(transactionModel.timestamp!).toLocal()}\n",
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60)),
                ]),
          ),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'assets/svg/tez.svg',
            height: 45.sp,
          ),
          visualDensity: VisualDensity.compact,
          title: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: ColorConst.NeutralVariant.shade60,
                size: 20.sp,
              ),
              Text(
                ' Received',
                style: labelMedium.copyWith(
                    color: ColorConst.NeutralVariant.shade60,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          subtitle: Text(
            'Tezos',
            style: labelLarge,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: ListTile(
                visualDensity: VisualDensity.compact,
                leading: Text("+18.267 tez", style: labelMedium),
                trailing: Text(
                  "\$23.21",
                  style: labelMedium,
                )),
          ),
        ),
        ListTile(
          leading: SvgPicture.asset('assets/svg/send.svg'),
          title: Text(
            'From',
            style: bodySmall.copyWith(
                color: ColorConst.NeutralVariant.shade60,
                fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            children: [
              Text(
                'tz1K...pkDZ',
                style: bodyMedium,
              ),
              0.02.hspace,
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton(
            position: PopupMenuPosition.under,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color(0xff421121),
            itemBuilder: (_) => <PopupMenuEntry>[
              if ("tz1ddgk4dgnk4tgdogo4oov4omo4".isValidWalletAddress) ...[
                CustomPopupMenuItem(
                  height: 51,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  onTap: () {
                    // Get.bottomSheet(
                    //   EditAccountBottomSheet(
                    //     accountIndex: index,
                    //   ),
                    //   isScrollControlled: true,
                    //   barrierColor: Colors.transparent,
                    // );
                  },
                  child: Text(
                    "Add to contacts",
                    style: labelMedium,
                  ),
                ),
              ] else ...[
                CustomPopupMenuItem(
                  height: 51,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  onTap: () {
                    // Get.bottomSheet(
                    //   EditAccountBottomSheet(
                    //     accountIndex: index,
                    //   ),
                    //   isScrollControlled: true,
                    //   barrierColor: Colors.transparent,
                    // );
                  },
                  child: Text(
                    "Edit Account",
                    style: labelMedium,
                  ),
                ),
                CustomPopupMenuDivider(
                  height: 1,
                  color: ColorConst.Neutral.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  thickness: 1,
                ),
                CustomPopupMenuItem(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  height: 51,
                  onTap: () {
                    // Get.bottomSheet(
                    //   removeAccountBottomSheet(index,
                    //       accountName:
                    //           widget.accounts[index].name!),
                    //   barrierColor: Colors.transparent,
                    // );
                  },
                  child: Text(
                    "Remove account",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                ),
              ],
            ],
            child: const Icon(
              Icons.more_horiz,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.015.height),
              width: 0.32.width,
              height: 0.03.height,
              decoration: BoxDecoration(
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
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
      ],
    );
  }
}
