import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/constants/constants.dart';
import '../../common_widgets/back_button.dart';
import '../../common_widgets/bouncing_widget.dart';
import '../controllers/events_controller.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(EventsController());
    return NaanBottomSheet(
      title: "Events",
      action: Padding(
        padding: EdgeInsets.only(right: 16.arP),
        child: closeButton(),
      ),
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetHeight - 56.arP,
          child: Column(
            children: [
              0.02.vspace,
            ],
          ),
        ),
      ],
    );
  }
}
