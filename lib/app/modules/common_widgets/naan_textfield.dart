import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NaanTextfield extends StatelessWidget {
  const NaanTextfield({Key? key, this.controller}) : super(key: key);
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextField(
            controller: controller,
            cursorColor: ColorConst.Primary,
            style: bodyMedium,
            decoration: InputDecoration(
                hintStyle:
                    bodyMedium.apply(color: Colors.white.withOpacity(0.2)),
                hintText: "Account",
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
