import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'nft_activity_tab.dart';
import 'nft_information_tab.dart';

class NFTSummaryBottomSheet extends StatelessWidget {
  const NFTSummaryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  0.02.vspace,
                  Center(
                    child: Container(
                      height: 5,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                      ),
                    ),
                  ),
                  0.03.vspace,
                  Center(
                    child: Text('unstable dreams', style: titleMedium),
                  ),
                  0.04.vspace,
                  Text('Unstable #5', style: bodyLarge),
                  0.02.vspace,
                  Center(
                    child: Image.asset(
                      'assets/temp/nft_preview.png',
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                  ),
                  0.01.vspace,
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: TabBar(
                          isScrollable: true,
                          labelColor: ColorConst.Primary.shade95,
                          indicatorColor: ColorConst.Primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          enableFeedback: true,
                          unselectedLabelColor:
                              ColorConst.NeutralVariant.shade60,
                          tabs: const [
                            Tab(text: "Information"),
                            Tab(text: "Activity"),
                          ]),
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        NFTInformationTab(),
                        NFTActivityTab(),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
