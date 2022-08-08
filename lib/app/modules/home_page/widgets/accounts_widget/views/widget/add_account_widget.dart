import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../../utils/colors/colors.dart';
import '../../../../../../../utils/styles/styles.dart';

class AddAccountWidget extends StatelessWidget {
  const AddAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 0.9.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConst.Primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 37.0, top: 66),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConst.Primary.shade60,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                    6.hspace,
                    Text(
                      'Add Account',
                      style: labelSmall,
                    ),
                  ],
                ),
              ),
              16.vspace,
              Text(
                'Create new account and add to\nthe stack ',
                style: labelSmall,
              )
            ],
          ),
        ),
      ],
    );
  }
}
