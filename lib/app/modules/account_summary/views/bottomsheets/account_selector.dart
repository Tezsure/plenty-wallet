import 'dart:math';

import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../../utils/utils.dart';

class AccountSelectorSheet extends StatelessWidget {
  const AccountSelectorSheet({super.key});

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
                  itemCount: 7,
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
                            color: index == 0
                                ? ColorConst.Primary
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {},
                          dense: true,
                          leading: Image.asset(
                            ServiceConfig.allAssetsProfileImages[Random()
                                .nextInt(ServiceConfig
                                    .allAssetsProfileImages.length)],
                            fit: BoxFit.contain,
                            height: 40,
                            width: 40,
                          ),
                          title: Text(
                            index == 0 ? 'My Main Account' : 'Account $index',
                            style: bodySmall,
                          ),
                          subtitle: Text(
                              tz1Shortner(
                                'tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5',
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
                                '5.63 tez',
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
