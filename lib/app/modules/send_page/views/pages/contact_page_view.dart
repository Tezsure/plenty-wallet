import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/delete_contact_sheet.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/edit_contact_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class ContactsListView extends GetView<SendPageController> {
  const ContactsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.height,
      width: 1.width,
      decoration: const BoxDecoration(color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 0.035.width),
      child: Column(
        children: [
          Obx(
            () => Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: (<Widget>[
                      if (controller.searchText.isNotEmpty)
                        ...[
                              0.008.vspace,
                              Text(
                                'Suggestions',
                                style: labelSmall.apply(
                                    color: ColorConst.NeutralVariant.shade60),
                              ),
                              0.008.vspace
                            ] +
                            controller.suggestedContacts
                                .map((element) => contactWidget(element))
                                .toList(),
                      controller.recentsContacts.isNotEmpty
                          ? Text(
                              'Recents',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            )
                          : Container(),
                      0.008.vspace
                    ] +
                    controller.recentsContacts
                        .map((element) => contactWidget(element))
                        .toList() +
                    (controller.contacts.isNotEmpty
                        ? <Widget>[
                            0.033.vspace,
                            Text(
                              'Contacts',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            ),
                            0.008.vspace
                          ]
                        : [Container()]) +
                    controller.contacts
                        .map((element) =>
                            contactWidget(element, isContact: true))
                        .toList()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contactWidget(ContactModel contact, {bool isContact = false}) {
    return InkWell(
      onTap: () => controller.onContactSelect(contactModel: contact),
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
                    contact.address.tz1Short(),
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ],
              ),
              const Spacer(),
              if (isContact)
                PopupMenuButton(
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: ColorConst.Neutral.shade20,
                    itemBuilder: (_) => <PopupMenuEntry>[
                          CustomPopupMenuItem(
                            height: 53,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            onTap: () {
                              Get.back();
                              Get.bottomSheet(EditContactBottomSheet(
                                  contactModel: contact));
                            },
                            child: Text(
                              "Edit contact",
                              style: labelMedium,
                            ),
                          ),
                          CustomPopupMenuDivider(
                            height: 1,
                            color: ColorConst.Neutral.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            thickness: 1,
                          ),
                          CustomPopupMenuItem(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            height: 53,
                            onTap: () {
                              Get.back();
                              Get.bottomSheet(DeleteContactBottomSheet(
                                  contactModel: contact));
                            },
                            child: Text(
                              "Delete contact",
                              style: labelMedium.apply(
                                  color: ColorConst.Error.shade60),
                            ),
                          ),
                        ],
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 16,
                    ))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPopupMenuDivider extends PopupMenuEntry<Never> {
  /// Creates a horizontal divider for a popup menu.
  ///
  /// By default, the divider has a height of 16 logical pixels.
  const CustomPopupMenuDivider(
      {Key? key,
      this.height = 1,
      this.color,
      this.thickness,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  /// The height of the divider entry.
  ///
  /// Defaults to 16 pixels.
  @override
  final double height;
  final Color? color;
  final double? thickness;
  final EdgeInsetsGeometry padding;

  @override
  bool represents(void value) => false;

  @override
  State<CustomPopupMenuDivider> createState() => _CustomPopupMenuDividerState();
}

class _CustomPopupMenuDividerState extends State<CustomPopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.padding,
        child: Divider(
          height: widget.height,
          color: widget.color,
          thickness: widget.thickness,
        ),
      );
}

class CustomPopupMenuItem extends PopupMenuEntry<Never> {
  const CustomPopupMenuItem({
    Key? key,
    this.child,
    this.height = 53,
    this.onTap,
    this.align = Alignment.centerLeft,
    this.padding = const EdgeInsets.all(8.0),
    this.width = 154,
  }) : super(key: key);

  @override
  @override
  final double height;
  final double width;
  final Widget? child;
  final GestureTapCallback? onTap;
  final AlignmentGeometry align;
  final EdgeInsetsGeometry padding;

  @override
  bool represents(void value) => false;

  @override
  State<CustomPopupMenuItem> createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: widget.padding,
          child: SizedBox(
            height: widget.height,
            width: widget.width,
            child: Align(alignment: widget.align, child: widget.child),
          ),
        ),
      );
}
