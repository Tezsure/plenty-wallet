import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/dapps_page_controller.dart';

class DappsPageView extends GetView<DappsPageController> {
  const DappsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DappsPageController());
    return Container(
      height: 0.95.height,
      width: 1.width,
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 0.05.height : 0.02.height,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.black),
      child: Column(
        children: [
          0.005.vspace,
          Container(
            height: 5,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () => Get.back(),
                iconSize: 20,
                icon: const Icon(Icons.arrow_back_ios_new)),
            title: Text(
              'Dapps',
              style: titleMedium,
            ),
            centerTitle: true,
          ),
          0.01.vspace,
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Container(
                            height: 0.13.width,
                            width: 0.13.width,
                            alignment: Alignment.bottomRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(controller
                                      .dapps[index].image
                                      .toString())),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            controller.dapps[index].name
                                                .toString(),
                                            style: titleSmall.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          controller.dapps[index].description,
                                          style: bodySmall.copyWith(
                                              color: ColorConst.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff1E1C1F)),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.back();
                                          Get.bottomSheet(
                                              const DappBrowserView(),
                                              enterBottomSheetDuration:
                                                  const Duration(
                                                      milliseconds: 180),
                                              exitBottomSheetDuration:
                                                  const Duration(
                                                      milliseconds: 150),
                                              barrierColor: Colors.white
                                                  .withOpacity(0.09),
                                              settings: RouteSettings(
                                                  arguments: controller
                                                      .dapps[index].url),
                                              isScrollControlled: true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            'Launch',
                                            style: bodyMedium.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff958E99)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                color: Color(0xff1E1C1F),
                                thickness: 1,
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: controller.dapps.length),
          ),
        ],
      ),
    );
  }
}
