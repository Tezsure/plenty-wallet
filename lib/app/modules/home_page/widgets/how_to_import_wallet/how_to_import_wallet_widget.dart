import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_1x1_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class HowToImportWalletWidget extends StatelessWidget {
  /// A widget that guides you through process of importing wallet
  const HowToImportWalletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WidgetWrapper2x1(
        appleYellow,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'How to\n',
                      style: semiboldTitle,
                    ),
                    TextSpan(
                      text: 'import a\n',
                      style: semiboldTitle.copyWith(
                          color: Colors.white.withOpacity(0.7)),
                    ),
                    TextSpan(
                      text: 'new wallet',
                      style: semiboldTitle.copyWith(
                          color: Colors.white.withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
