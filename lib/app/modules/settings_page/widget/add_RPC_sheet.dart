import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:http/http.dart' as http;

class AddRPCbottomSheet extends StatefulWidget {
  AddRPCbottomSheet({Key? key}) : super(key: key);

  @override
  State<AddRPCbottomSheet> createState() => _AddRPCbottomSheetState();
}

class _AddRPCbottomSheetState extends State<AddRPCbottomSheet> {
  final SettingsPageController controller = Get.find<SettingsPageController>();

  final TextEditingController _name = TextEditingController();

  final TextEditingController _url = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: 'Add Custom RPC',
      blurRadius: 5,
      bottomSheetHorizontalPadding: 32,
      height: .45.height,
      bottomSheetWidgets: [
        0.03.vspace,
        NaanTextfield(
          onTextChange: (_) {
            setState(() {});
          },
          controller: _name,
          height: 52,
          hint: "My custom network",
          hintTextSyle: labelLarge.copyWith(
              color: ColorConst.lightGrey, fontWeight: FontWeight.w400),
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        0.025.vspace,

        NaanTextfield(
          onTextChange: (_) {
            setState(() {});
          },
          controller: _url,
          height: 52,
          hint: "http://localhost:4444",
          hintTextSyle: labelLarge.copyWith(
              color: ColorConst.lightGrey, fontWeight: FontWeight.w400),
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        0.025.vspace,
        SolidButton(
            title: "Add RPC",
            onPressed: (_name.text.isEmpty || (!_url.text.isURL))
                ? null
                : () async {
                    try {
                      final result = await http.get(Uri.parse(
                        "${_url.text}/chains/main/blocks/head/header",
                      ));
                      print("hi ${result.body}");
                      if (!result.body.contains("chain_id")) {
                        Get.showSnackbar(const GetSnackBar(
                          message: "Not a valid RPC",
                          snackPosition: SnackPosition.TOP,
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }
                    } catch (e) {
                      print(e);
                      Get.showSnackbar(const GetSnackBar(
                        message: "Not a valid RPC",
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }

                    controller.addCustomNode(
                        NodeModel(name: _name.text, url: _url.text));
                  }),
        // MaterialButton(
        //   color: ColorConst.Primary,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   onPressed: () {
        //     controller
        //         .addCustomNode(NodeModel(name: _name.text, url: _url.text));
        //   },
        //   child: SizedBox(
        //     width: double.infinity,
        //     height: 48,
        //     child: Center(
        //       child: Text(
        //         "Add RPC",
        //         style: titleSmall,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
