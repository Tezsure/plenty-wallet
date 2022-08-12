import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';

class AccountWidget extends StatelessWidget {
  AccountWidget({Key? key}) : super(key: key);

  final ImportWalletPageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Visibility(
              visible: controller.isExpanded.isTrue,
              replacement: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        4,
                        (index) => accountWidget(),
                      ),
                    ),
                    if (!controller.isExpanded.value)
                      Column(
                        children: [
                          const Divider(
                            color: Color(0xff4a454e),
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.isExpanded.value = true;
                            },
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Show more accounts",
                                  style: labelMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              child: Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: ListView.separated(
                    itemBuilder: (context, index) => accountWidget(),
                    separatorBuilder: (context, index) => const Divider(
                        color: Color(0xff4a454e), height: 1, thickness: 1),
                    itemCount: 100,
                    shrinkWrap: true,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget accountWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 84,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
          ),
          0.05.hspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "tz1...qfDZg\n",
                style: bodySmall,
              ),
              Text(
                "20 tez",
                style: bodyLarge,
              ),
            ],
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.white),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
          )
        ],
      ),
    );
  }
}
