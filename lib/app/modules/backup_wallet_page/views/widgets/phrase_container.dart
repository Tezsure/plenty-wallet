import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';

class PhraseContainer extends StatelessWidget {
  final int index;
  final String phrase;
  const PhraseContainer({
    Key? key,
    required this.index,
    required this.phrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 130,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConst.NeutralVariant.shade60,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        25.hspace,
        Text(
          '${index + 1}',
          textAlign: TextAlign.center,
          style: labelMedium.copyWith(
            color: ColorConst.NeutralVariant.shade60,
            letterSpacing: 0,
          ),
        ),
        VerticalDivider(
          color: ColorConst.NeutralVariant.shade60,
          thickness: 2,
          width: 20,
        ),
        Text(
          phrase,
          style: labelMedium.copyWith(letterSpacing: 0),
        )
      ]),
    );
  }
}
