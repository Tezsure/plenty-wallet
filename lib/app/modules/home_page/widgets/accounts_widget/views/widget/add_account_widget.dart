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
          padding: EdgeInsets.zero,
          height: 0.26.height,
          width: 1.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConst.Primary,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0.09.width, top: 0.09.height),
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
                    0.02.hspace,
                    Text(
                      'Add Account',
                      style: labelSmall,
                    ),
                  ],
                ),
              ),
              0.010.vspace,
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
