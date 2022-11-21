import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class BakerFilterBottomSheet extends StatelessWidget {
  const BakerFilterBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 0.3.height,
      title: 'Set baker by:',
      titleAlignment: Alignment.center,
      titleStyle: labelLarge,
      bottomSheetWidgets: [
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    type: MaterialType.transparency,
                    elevation: 0,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      onTap: () {},
                      splashColor: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        height: 51,
                        alignment: Alignment.center,
                        child: Text(
                          "Rank",
                          style: labelMedium,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  Material(
                    color: Colors.transparent,
                    type: MaterialType.transparency,
                    elevation: 0,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      onTap: () {},
                      splashColor: Colors.transparent,
                      child: Container(
                        width: double.infinity,
                        height: 51,
                        alignment: Alignment.center,
                        child: Text(
                          "Fees",
                          style: labelMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
