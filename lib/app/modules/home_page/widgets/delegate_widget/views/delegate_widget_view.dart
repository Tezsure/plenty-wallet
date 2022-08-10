import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/delegate_widget_controller.dart';
import '../widgets/delegate_baker.dart';

class DelegateWidget extends GetView<DelegateWidgetController> {
  const DelegateWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DelegateWidgetController());
    return SizedBox(
      width: 0.92.width,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Delegate',
                style: titleSmall.copyWith(
                    color: ColorConst.NeutralVariant.shade50),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('learn',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade50)),
                    0.01.hspace,
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: ColorConst.NeutralVariant.shade50,
                    )
                  ],
                ),
              ),
            ],
          ),
          0.010.vspace,
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 0.92.width,
              height: 0.4.height,
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svg/delegate.svg',
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: 'Delegate your ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 24.sp,
                            ),
                            children: [
                              WidgetSpan(
                                  style: const TextStyle(),
                                  alignment: PlaceholderAlignment.middle,
                                  child: SvgPicture.asset(
                                    'assets/svg/path.svg',
                                    color: Colors.white,
                                    height: 20,
                                    width: 15,
                                  )),
                              TextSpan(
                                  text: '\nand earn',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 22.sp)),
                              TextSpan(
                                  text: ' 5% APR',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.sp)),
                            ],
                          ),
                        ),
                        0.010.vspace,
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35.0, right: 35, top: 20, bottom: 12),
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: controller.textEditingController,
                              onChanged: ((value) =>
                                  controller.onTextChanged(value)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                counterStyle: const TextStyle(
                                    backgroundColor: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none),
                                hintText:
                                    'Enter address or domain name of baker',
                                hintStyle: bodySmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade70),
                                labelStyle: labelSmall,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Get.to(() => const DelegateSelectBaker()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() => Text(
                                  controller.bakerAddress.value.isEmpty
                                      ? 'View baker list'
                                      : 'Or Select baker',
                                  style: labelSmall)),
                              0.02.hspace,
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        0.020.vspace,
                        Obx(() => MaterialButton(
                              elevation: 0,
                              onPressed: () {},
                              disabledColor: ColorConst.Primary.shade50,
                              color: controller.bakerAddress.isNotEmpty
                                  ? Colors.black
                                  : ColorConst.Primary.shade50,
                              splashColor: ColorConst.Primary.shade60,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Delegate',
                                  style: titleSmall.apply(
                                      color: controller.bakerAddress.isNotEmpty
                                          ? Colors.white
                                          : ColorConst.Primary.shade20),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
