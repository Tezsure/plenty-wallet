import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'add_contact_sheet.dart';

class AddContactButton extends StatelessWidget {
  final String contactName;
  const AddContactButton({super.key, required this.contactName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          AddContactBottomSheet(contactName: contactName),
  
          barrierColor: Colors.black.withOpacity(0.2),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.CONTACTS_PAGE}svg/add_contact.svg",
            fit: BoxFit.scaleDown,
            color: ColorConst.Primary,
            height: 16,
          ),
          0.02.hspace,
          Text(
            "Save",
            style: labelMedium.apply(color: ColorConst.Primary),
          )
        ],
      ),
    );
  }
}
