// import 'package:flutter/material.dart';
// import 'package:plenty_wallet/app/data/services/service_models/contact_model.dart';
// import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
// import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
// import 'package:plenty_wallet/app/modules/common_widgets/naan_textfield.dart';
// import 'package:plenty_wallet/utils/colors/colors.dart';
// import 'package:plenty_wallet/utils/extensions/size_extension.dart';
// import 'package:plenty_wallet/utils/styles/styles.dart';

// class EditContactBottomSheet extends StatelessWidget {
//   final ContactModel contactModel;
//   const EditContactBottomSheet({
//     super.key,
//     required this.contactModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return NaanBottomSheet(
//       height: 262,
//       bottomSheetHorizontalPadding: 32,
//       blurRadius: 5,
//       bottomSheetWidgets: [
//         Center(
//           child: Text(
//             'Edit Contact',
//             style: titleMedium,
//           ),
//         ),
//         0.03.vspace,
//         NaanTextfield(
//           hint: 'Enter Name',
//         ),
//         0.025.vspace,
//         Text(
//           contactModel.address,
//           style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
//         ),
//         0.025.vspace,
//         MaterialButton(
//           color: ColorConst.Primary,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           onPressed: () async {},
//           child: SizedBox(
//             width: double.infinity,
//             height: 48,
//             child: Center(
//                 child: Text(
//               'Save Changes',
//               style: titleSmall,
//             )),
//           ),
//         ),
//       ],
//     );
//   }
// }
