import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class NaanAppBar extends StatelessWidget {
  final Function? onBack;
  final String? pageName, backButtonName;

  /// App bar with back button and page name
  NaanAppBar(
      {required this.onBack,
      required this.pageName,
      required this.backButtonName});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onBack!();
        },
        child: Container(
          height: 40,
          width: 1.width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                child: Container(
                  height: 40,
                  padding: EdgeInsets.only(right: 12),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_outlined,
                        color: blue,
                        size: 16,
                      ),
                      Text(
                        backButtonName!,
                        style:
                            blue16Text700.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  pageName!,
                  style: bold16,
                ),
              ),
            ],
          ),
        ),
      );
}
