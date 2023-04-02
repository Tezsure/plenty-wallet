import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_model.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class TeztownDetailSheet extends StatefulWidget {
  const TeztownDetailSheet({super.key});

  @override
  State<TeztownDetailSheet> createState() => _TeztownDetailSheetState();
}

class _TeztownDetailSheetState extends State<TeztownDetailSheet> {
  final controller = Get.find<TeztownController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NaanBottomSheet(
        height: AppConstant.naanBottomSheetHeight,
        title: "Details",
        bottomSheetWidgets: [
          0.02.vspace,
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight - 0.02.height.arP,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final data = controller.teztownData.value.detailItems![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(data),
                    SizedBox(
                      height: 12.arP,
                    ),
                    Text(
                      data.title,
                      style: titleSmall,
                    ),
                    SizedBox(
                      height: 8.arP,
                    ),
                    HtmlWidget(data.description),
                    SizedBox(
                      height: 24.arP,
                    )
                  ],
                );
              },
              itemCount: controller.teztownData.value.detailItems?.length ?? 0,
            ),
          )
        ],
      );
    });
  }

  ClipRRect _buildImage(DetailItem data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.arP),
      child: Image.network(
        "${TeztownController.imageBaseUrl}/${data.image}",
        errorBuilder: (context, error, stackTrace) {
          return _buildShimmer();
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _buildShimmer();
        },
        width: 1.width,
        height: .6.width,
        fit: BoxFit.cover,
      ),
    );
  }

  SizedBox _buildShimmer() {
    return SizedBox(
      width: 1.width,
      height: .6.width,
      child: Shimmer.fromColors(
        baseColor: const Color(0xff474548),
        highlightColor: const Color(0xFF958E99).withOpacity(0.2),
        child: Container(
            decoration: BoxDecoration(
          color: const Color(0xff474548),
          borderRadius: BorderRadius.circular(
            8.arP,
          ),
        )),
      ),
    );
  }
}
