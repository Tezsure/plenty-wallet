import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/contact_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/add_contact_sheet.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/delete_contact_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

class ContactsListView extends GetView<SendPageController> {
  const ContactsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: AppConstant.scrollPhysics,
              children: (<Widget>[
                    if (controller.searchText.isNotEmpty)
                      ...[
                            0.008.vspace,
                            Text(
                              'Suggestions'.tr,
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
                            'Recents'.tr,
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
                          0.02.vspace,
                          Text(
                            'Contacts'.tr,
                            style: labelSmall.apply(
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.008.vspace
                        ]
                      : [Container()]) +
                  controller.contacts
                      .map((element) => contactWidget(element, isContact: true))
                      .toList()),
            ),
          ),
        )
      ],
    );
  }

  Widget contactWidget(ContactModel contact, {bool isContact = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.arP),
      child: InkWell(
        onTap: () => controller.onContactSelect(contactModel: contact),
        child: SizedBox(
          // height: 46,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 23.arP,
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
                        contact.name.length >= 38
                            ? '${contact.name.substring(0, 38)}...'
                            : contact.name,
                        style: bodySmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        contact.address.tz1Short(),
                        style: labelSmall.apply(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              if (isContact)
                PopupMenuButton(
                    position: PopupMenuPosition.under,
                    padding: EdgeInsets.all(0.arP),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: const Color(0xFF421121),
                    itemBuilder: (_) => <PopupMenuEntry>[
                          CustomPopupMenuItem(
                            height: 40.arP,
                            padding: EdgeInsets.symmetric(horizontal: 12.arP),
                            onTap: () {
                              Get.back();
                              CommonFunctions.bottomSheet(
                                  AddContactBottomSheet(
                                    contactModel: contact,
                                    isTransactionContact: false,
                                    isEditContact: true,
                                  ),
                                  fullscreen: true);
                            },
                            child: Text(
                              "Edit".tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5.arP,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5.arP,
                              ),
                            ),
                          ),
                          CustomPopupMenuDivider(
                            height: 1,
                            color: ColorConst.Neutral.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            thickness: 1,
                          ),
                          CustomPopupMenuItem(
                            padding: EdgeInsets.symmetric(horizontal: 12.arP),
                            height: 40.arP,
                            onTap: () {
                              Get.back();
                              CommonFunctions.bottomSheet(
                                DeleteContactBottomSheet(contactModel: contact),
                              );
                            },
                            child: Text(
                              "Remove".tr,
                              style: TextStyle(
                                color: const Color(0xFFFF5449),
                                fontSize: 12.5.arP,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5.arP,
                              ),
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
  Widget build(BuildContext context) => BouncingWidget(
        // focusColor: Colors.transparent,
        // hoverColor: Colors.transparent,
        // splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
        // overlayColor: MaterialStateProperty.all(Colors.transparent),
        onPressed: widget.onTap,
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
