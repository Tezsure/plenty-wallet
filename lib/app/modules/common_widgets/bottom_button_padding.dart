import 'package:flutter/material.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class BottomButtonPadding extends StatelessWidget {
  const BottomButtonPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        0.016.vspace,
        const SafeArea(
          child: SizedBox.shrink(),
        )
      ],
    );
  }
}
