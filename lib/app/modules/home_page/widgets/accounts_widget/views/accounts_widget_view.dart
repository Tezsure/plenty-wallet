import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/accounts_widget_controller.dart';

class AccountsWidget extends GetView<AccountsWidgetController> {
  const AccountsWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AccountsWidgetController());
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Wallets',
          style: titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
        ),
        13.vspace,
        SizedBox(
          width: 1.width,
          height: 0.3.height,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.accountsList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) =>
                  index == controller.accountsList.length - 1
                      ? const AddAccountWidget()
                      : const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: AccountsContainer(),
                        )),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.hspace,
              SizedBox(
                height: 10,
                width: 0.55.width,
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.accountsList.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: ((context, index) => index ==
                          controller.accountsList.length - 1
                      ? Icon(
                          Icons.add,
                          color: index == controller.accountsList.length
                              ? Colors.white
                              : ColorConst.NeutralVariant.shade20,
                          size: 10,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == 0
                                    ? Colors.white
                                    : ColorConst.NeutralVariant.shade40),
                          ),
                        )),
                ),
              ),
              const Spacer(),
              Text(
                'learn account',
                style: labelSmall.copyWith(color: ColorConst.Neutral.shade95),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddAccountWidget extends StatelessWidget {
  const AddAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConst.Primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 37.0, top: 66),
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
                    6.hspace,
                    Text(
                      'Add Account',
                      style: labelSmall,
                    ),
                  ],
                ),
              ),
              16.vspace,
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

class AccountsContainer extends StatelessWidget {
  const AccountsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'assets/svg/accounts/account_1.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: const Alignment(-0.05, 0),
                end: const Alignment(1.5, 0),
                colors: [
                  ColorConst.Primary.shade50,
                  // const Color(0xff9961EC),
                  const Color(0xff4E4D4D).withOpacity(0),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 31.0, top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Account One',
                    style: labelSmall,
                  ),
                  10.hspace,
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 8,
                    minRadius: 8,
                  )
                ],
              ),
              8.vspace,
              Row(
                children: [
                  Text(
                    'tz...fDzg',
                    style: bodySmall,
                  ),
                  1.hspace,
                  const Icon(
                    Icons.copy,
                    size: 11,
                    color: Colors.white,
                  ),
                ],
              ),
              15.vspace,
              Row(
                children: [
                  Text(
                    '252.25',
                    style: headlineSmall,
                  ),
                  10.hspace,
                  SvgPicture.asset(
                    'assets/svg/path.svg',
                    color: Colors.white,
                    height: 20,
                    width: 15,
                  ),
                ],
              ),
              17.vspace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(),
                    elevation: 1,
                    padding: const EdgeInsets.all(8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    enableFeedback: true,
                    onPressed: () {},
                    fillColor: ColorConst.Primary.shade0,
                    shape: const CircleBorder(side: BorderSide.none),
                    child: const Icon(
                      Icons.turn_right_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  16.hspace,
                  Transform.rotate(
                    angle: -math.pi / 1,
                    child: RawMaterialButton(
                      enableFeedback: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      elevation: 1,
                      onPressed: () {},
                      fillColor: ColorConst.Primary.shade0,
                      shape: const CircleBorder(side: BorderSide.none),
                      child: const Icon(
                        Icons.turn_right_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
