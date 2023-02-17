import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_expansion_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class TransactionDetailSheet extends StatelessWidget {
  final TokenInfo tokenInfo;
  const TransactionDetailSheet({super.key, required this.tokenInfo});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        SizedBox(
          child: Column(),
        )
      ],
    );
  }

  Widget tiles() {
    return NaanExpansionTile(
        title: contactTile(ContactModel(
            name: "name",
            address: "address",
            imagePath: 'assets/svg/send.svg')));
  }

  Widget contactTile(ContactModel? contact) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 22.aR,
          child: contact != null
              ? SvgPicture.asset(
                  contact.imagePath,
                )
              : SvgPicture.asset(
                  'assets/svg/send.svg',
                ),
        ),
        0.02.hspace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "From",
              style: bodySmall.copyWith(
                  fontSize: 12.aR,
                  color: ColorConst.NeutralVariant.shade60,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  contact?.name ?? contact?.address ?? "",
                  style: bodyMedium.copyWith(
                      fontSize: 14.aR, letterSpacing: 0.5.aR),
                ),
                0.02.hspace,
                BouncingWidget(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: contact!.address));
                    Get.rawSnackbar(
                      maxWidth: 0.45.width,
                      backgroundColor: Colors.transparent,
                      snackPosition: SnackPosition.BOTTOM,
                      snackStyle: SnackStyle.FLOATING,
                      padding: const EdgeInsets.only(bottom: 60),
                      messageText: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: ColorConst.Neutral.shade10,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Copied to clipboard",
                              style: labelSmall,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    '${PathConst.SVG}copy.svg',
                    color: Colors.white,
                    fit: BoxFit.contain,
                    height: 16.arP,
                  ),
                ),
              ],
            ),
          ],
        ),
        // const Spacer(),
      ],
    );
  }
}
