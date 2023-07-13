import 'package:cast/cast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/nft_gallery/controller/cast_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';

class CastDevicesSheet extends StatelessWidget {
  const CastDevicesSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CastScreenController());

    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 16.arP,
      title: "Cast Screen",
      bottomSheetWidgets: [
        FutureBuilder<List<CastDevice>>(
          future: CastDiscoveryService().search(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error.toString()}',
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: ColorConst.Primary,
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return Column(
                children: [
                  Center(
                    child: Text(
                      'No Chromecast found',
                      style: labelMedium,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: snapshot.data!.map((device) {
                return Obx(() {
                  return ListTile(
                    leading: const Icon(
                      Icons.cast_rounded,
                      color: Colors.white,
                      // size: 16.arP,
                    ),
                    title: Text(
                      device.name,
                      style: labelMedium,
                    ),
                    subtitle: Text(
                      controller.device.value?.serviceName != device.serviceName
                          ? ""
                          : "(Connected)",
                      style: labelSmall,
                    ),
                    onTap: () {
                      Get.put(CastScreenController()).connect(device);
                    },
                  );
                });
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
