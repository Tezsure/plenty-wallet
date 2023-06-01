import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';

// class ManageAccountsBottomSheet extends GetView<SettingsPageController> {
//   ManageAccountsBottomSheet({super.key});

//   final _homePageController = Get.find<HomePageController>();

//   @override
//   Widget build(BuildContext context) {
//     return NaanBottomSheet(
//       blurRadius: 5,
//       height: 0.87.height,
//       bottomSheetHorizontalPadding: 0,
//       bottomSheetWidgets: [
//         Expanded(
//           child: Obx(
//             () => Scaffold(
//               backgroundColor: Colors.transparent,
//               floatingActionButton:
//                   controller.isScrolling.value ? null : reorderButton(),
//               body: Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       'Manage accounts',
//                       style: titleMedium,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Center(
//                     child: Text(
//                       'Rearrange, delete, and edit accounts',
//                       style: bodySmall.apply(
//                           color: ColorConst.NeutralVariant.shade60),
//                     ),
//                   ),
//                   0.03.vspace,
//                   Expanded(
//                     child: Visibility(
//                       child: NotificationListener<ScrollNotification>(
//                         onNotification: (scrollNotification) {
//                           if (scrollNotification is ScrollStartNotification) {
//                             controller.isScrolling.value = true;
//                           } else if (scrollNotification
//                               is ScrollUpdateNotification) {
//                           } else if (scrollNotification
//                               is ScrollEndNotification) {
//                             controller.isScrolling.value = false;
//                           }

//                           return false;
//                         },
//                         child: controller.isRearranging.value
//                             ? ReorderableListView.builder(
//                                 physics: AppConstant.scrollPhysics,
//                                 scrollController:
//                                     controller.scrollcontroller.value,
//                                 itemBuilder: (context, index) => accountWIdget(
//                                     index,
//                                     _homePageController.userAccounts[index]),
//                                 itemCount:
//                                     _homePageController.userAccounts.length,
//                                 onReorder: controller.reorderUserAccountsList)
//                             : ListView.builder(
//                                 physics: AppConstant.scrollPhysics,
//                                 controller: controller.scrollcontroller.value,
//                                 itemBuilder: (context, index) => accountWIdget(
//                                     index,
//                                     _homePageController.userAccounts[index]),
//                                 itemCount:
//                                     _homePageController.userAccounts.length,
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   ListTile accountWIdget(int index, AccountModel accountModel) {
//     return ListTile(
//       selectedColor: Colors.transparent,
//       selectedTileColor: Colors.transparent,
//       focusColor: Colors.transparent,
//       contentPadding: const EdgeInsets.symmetric(
//         vertical: 6,
//         horizontal: 14,
//       ),
//       key: Key(index.toString()),
//       leading: CustomImageWidget(
//           imageType: accountModel.imageType!,
//           imagePath: accountModel.profileImage!),
//       title: SizedBox(
//         height: 57,
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   "Address index : $index",
//                   style: labelSmall.apply(
//                       color: ColorConst.NeutralVariant.shade60),
//                 ),
//                 Text(
//                   accountModel.name!,
//                   style: labelLarge,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                       text: "${accountModel.accountDataModel?.xtzBalance}",
//                       style: labelSmall.apply(
//                           color: ColorConst.NeutralVariant.shade60),
//                       children: [
//                         WidgetSpan(
//                             alignment: PlaceholderAlignment.middle,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 4.arP),
//                               child: SvgPicture.asset(
//                                 '${PathConst.HOME_PAGE}svg/xtz.svg',
//                                 height: 12.arP,
//                                 color: ColorConst.NeutralVariant.shade60,
//                               ),
//                             ))
//                       ]),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 controller.isRearranging.value
//                     ? const Icon(
//                         Icons.drag_handle,
//                         size: 24,
//                         color: Colors.white,
//                       )
//                     : PopupMenuButton(
//                         position: PopupMenuPosition.under,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         color: ColorConst.Neutral.shade20,
//                         itemBuilder: (_) => <PopupMenuEntry>[
//                           CustomPopupMenuItem(
//                             height: 51,
//                             padding: const EdgeInsets.symmetric(horizontal: 11),
//                             onTap: () {
//                               controller.makePrimaryAccount(index);
//                               Get.back();
//                             },
//                             child: Text(
//                               "Make primary account",
//                               style: labelMedium,
//                             ),
//                           ),
//                           CustomPopupMenuDivider(
//                             height: 1,
//                             color: ColorConst.Neutral.shade50,
//                             padding: const EdgeInsets.symmetric(horizontal: 11),
//                             thickness: 1,
//                           ),
//                           CustomPopupMenuItem(
//                             height: 51,
//                             padding: const EdgeInsets.symmetric(horizontal: 11),
//                             onTap: () {
//                               Get.back();
//                               CommonFunctions.bottomSheet(
//                                 EditAccountBottomSheet(
//                                   accountIndex: index,
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "Edit profile",
//                               style: labelMedium,
//                             ),
//                           ),
//                           CustomPopupMenuDivider(
//                             height: 1,
//                             color: ColorConst.Neutral.shade50,
//                             padding: const EdgeInsets.symmetric(horizontal: 11),
//                             thickness: 1,
//                           ),
//                           CustomPopupMenuItem(
//                             padding: const EdgeInsets.symmetric(horizontal: 11),
//                             height: 51,
//                             onTap: () {
//                               CommonFunctions.bottomSheet(
//                                 removeAccountBottomSheet(index),
//                               );
//                             },
//                             child: Text(
//                               "Delete account",
//                               style: labelMedium.apply(
//                                   color: ColorConst.Error.shade60),
//                             ),
//                           ),
//                         ],
//                         child: const Icon(
//                           Icons.more_horiz,
//                           size: 24,
//                           color: Colors.white,
//                         ),
//                       ),
//                 if (index == 0 &&
//                     !controller.isRearranging.value &&
//                     _homePageController.userAccounts[index].isAccountPrimary!)
//                   Container(
//                     height: 18,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: ColorConst.NeutralVariant.shade20,
//                       borderRadius: BorderRadius.circular(9),
//                     ),
//                     child: Text(
//                       "Primary",
//                       style:
//                           labelSmall.apply(color: ColorConst.Primary.shade60),
//                     ),
//                   )
//               ],
//             ),
//           ],
//         ),
//       ),
//       horizontalTitleGap: 21,
//     );
//   }

//   Widget reorderButton() {
//     return BouncingWidget(
//       onPressed: () {
//         controller.isRearranging.value = !controller.isRearranging.value;
//       },
//       child: Container(
//         height: 56,
//         width: 56,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             color: ColorConst.Primary, borderRadius: BorderRadius.circular(16)),
//         child: controller.isRearranging.value
//             ? const Icon(
//                 Icons.check,
//                 size: 24,
//                 color: Colors.white,
//               )
//             : const Icon(
//                 Icons.mode_edit_outline_outlined,
//                 size: 18,
//                 color: Colors.white,
//               ),
//       ),
//     );
//   }

//   Widget removeAccountBottomSheet(int index) {
//     return NaanBottomSheet(
//       bottomSheetHorizontalPadding: 32,
//       blurRadius: 5,
//       height: 239,
//       bottomSheetWidgets: [
//         Center(
//           child: Text(
//             'Do you want to remove “Main acount”\nfrom your wallet?',
//             style: labelMedium,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         0.03.vspace,
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(
//             horizontal: 12,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//           ),
//           child: Column(
//             children: [
//               optionMethod(
//                   child: Text(
//                     "Remove Account",
//                     style: labelMedium.apply(color: ColorConst.Error.shade60),
//                   ),
//                   onTap: () {
//                     controller.removeAccount(index);
//                     Get.back();
//                     Get.back();
//                   }),
//               const Divider(
//                 color: Color(0xff4a454e),
//                 height: 1,
//                 thickness: 1,
//               ),
//               optionMethod(
//                   child: Text(
//                     "Cancel",
//                     style: labelMedium,
//                   ),
//                   onTap: () {
//                     Get.back();
//                   }),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget optionMethod({Widget? child, GestureTapCallback? onTap}) {
//     return BouncingWidget(
//       onPressed: onTap,
//       child: SizedBox(
//         width: double.infinity,
//         height: 54,
//         child: Center(
//           child: child,
//         ),
//       ),
//     );
//   }
// }

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
