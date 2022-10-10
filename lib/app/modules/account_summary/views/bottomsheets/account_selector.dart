import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../../utils/utils.dart';
import '../../../../data/services/service_models/account_model.dart';

class AccountSelectorSheet extends StatefulWidget {
  final List<AccountModel> accounts;
  final AccountModel selectedAccount;
  const AccountSelectorSheet({
    super.key,
    required this.accounts,
    required this.selectedAccount,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  final AccountSummaryController controller =
      Get.find<AccountSummaryController>();
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.accounts.indexOf(widget.selectedAccount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.height,
      width: 1.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        gradient: GradConst.GradientBackground,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.01.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.01.vspace,
            Center(
              child: Container(
                height: 5,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                ),
              ),
            ),
            0.01.vspace,
            Center(
              child: Text(
                'Accounts',
                style: titleMedium,
              ),
            ),
            0.01.vspace,
            Expanded(
              child: ListView.builder(
                  itemCount: widget.accounts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 4,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: index == selectedIndex
                                ? ColorConst.Primary
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              controller.userAccount.value =
                                  widget.accounts[index];
                              selectedIndex = index;
                              controller.fetchAllTokens();
                            });
                          },
                          dense: true,
                          leading: CustomImageWidget(
                            imageType: widget.accounts[index].imageType!,
                            imagePath: widget.accounts[index].profileImage!,
                            imageRadius: 20,
                          ),
                          title: Text(
                            '${widget.accounts[index].name}',
                            style: bodySmall,
                          ),
                          subtitle: Text(
                              tz1Shortner(
                                "${widget.accounts[index].publicKeyHash}",
                              ),
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60)),
                          trailing: Container(
                            height: 0.03.height,
                            width: 0.15.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.2),
                            ),
                            child: Center(
                              child: Text(
                                '${widget.accounts[index].accountDataModel?.xtzBalance}',
                                style: labelSmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
