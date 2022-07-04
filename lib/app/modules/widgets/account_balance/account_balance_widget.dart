import 'package:flutter/cupertino.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_1x1_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class AccountBalanceWidget extends StatelessWidget {
  ///A widget that displays account balance
  AccountBalanceWidget({Key? key}) : super(key: key);

  /// current selected account's name
  final String currentAccountName = "Account 1";

  /// current selected account's balacne
  final double currentAccountBalance = 254.25548493832;

  @override
  Widget build(BuildContext context) => WidgetWrapper2x1(
        appleBlack,
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentAccountName,
                style: body12,
              ),
              5.vspace,
              Text(
                "\$${currentAccountBalance.toStringAsFixed(2)}",
                style: headingBold20,
              ),
            ],
          ),
        ),
      );
}
