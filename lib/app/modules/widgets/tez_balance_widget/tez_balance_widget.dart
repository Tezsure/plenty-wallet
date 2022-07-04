import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_1x1_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class TezBalanceWidget extends StatelessWidget {
  /// A widget that displays tezos  balance
  TezBalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WidgetWrapper2x1(
        appleBlack,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tez",
                    style: headingBold20,
                  ),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/home_page/arrow_up.png",
                    height: 16,
                  ),
                  8.hspace,
                  Text(
                    "0,03%",
                    style: bold14,
                  ),
                ],
              ),
              4.vspace,
              Text(
                "\$254.25",
                style: headingBold20,
              ),
            ],
          ),
        ),
      );
}
