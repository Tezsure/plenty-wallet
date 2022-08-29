import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/contact_page_controller.dart';

class ContactPageView extends StatelessWidget {
  ContactPageView({Key? key, required this.pageController}) : super(key: key);

  final controller = Get.put<ContactPageController>(ContactPageController());

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      padding: EdgeInsets.symmetric(horizontal: 0.035.width),
      child: Column(
        children: [
          Obx(
            () => Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: controller.searchText.isEmpty
                    ? (<Widget>[
                          Text(
                            'Recents',
                            style: labelSmall.apply(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.008.vspace
                        ] +
                        controller.recentsContacts
                            .map((element) => contact(element))
                            .toList() +
                        <Widget>[
                          0.033.vspace,
                          Text(
                            'Contacts',
                            style: labelSmall.apply(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.008.vspace
                        ] +
                        controller.contacts
                            .map((element) => contact(element, isContact: true))
                            .toList())
                    : <Widget>[
                          Text(
                            'Suggestions',
                            style: labelSmall.apply(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.008.vspace
                        ] +
                        controller.suggestedContacts
                            .map((element) => contact(element))
                            .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contact(ContactModel contact, {bool isContact = false}) {
    return InkWell(
      onTap: () {
        pageController.jumpToPage(1);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor:
                    ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                child: Image.asset(
                  contact.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              0.04.hspace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    contact.name,
                    style: bodySmall,
                  ),
                  Text(
                    contact.address,
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ],
              ),
              const Spacer(),
              if (isContact)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ),
                  iconSize: 16,
                )
            ],
          ),
        ),
      ),
    );
  }
}
