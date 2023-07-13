import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/contact_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import 'add_contact_sheet.dart';

class AddContactButton extends StatelessWidget {
  final ContactModel contactModel;
  const AddContactButton({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
            AddContactBottomSheet(contactModel: contactModel),
            fullscreen: true);
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
            "Save".tr,
            style: labelMedium.apply(color: ColorConst.Primary),
          )
        ],
      ),
    );
  }
}
