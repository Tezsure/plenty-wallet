import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../controllers/home_page_controller.dart';

class NftClaimWidget extends StatelessWidget {
  final Map campaign;
  const NftClaimWidget({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        Get.find<HomePageController>().openScanner();
      },
      child: HomeWidgetFrame(
        width: 1.width,
        child: SizedBox(
/*           decoration: BoxDecoration(
            gradient: blueGradientLight,
          ), */
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: CachedNetworkImage(
                  imageUrl:
                      "${ServiceConfig.naanApis}/campaigns_images/${campaign['banner']}",
                  fit: BoxFit.cover,
                  // cacheHeight: 335,
                  // cacheWidth: 709,
                ),
              ),
/*               Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}tez_quake_bottom.png",
                    fit: BoxFit.cover,
                    width: 0.5.width,
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
