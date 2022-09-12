import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../account_summary_view.dart';
import '../bottomsheets/transaction_details.dart';
import '../widgets/history_tab_widgets/history_tile.dart';
import '../widgets/history_tab_widgets/nft_history_tile.dart';

class HistoryPage extends StatelessWidget {
  final bool isNftTransaction;
  final GestureTapCallback? onTap;
  const HistoryPage({super.key, this.isNftTransaction = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.02.vspace,
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 0.06.height,
                        width: 0.8.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: ColorConst.NeutralVariant.shade60,
                              size: 22,
                            ),
                            0.02.hspace,
                            Text(
                              'Search',
                              style: bodySmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.filter,
                            color: ColorConst.Primary,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16.sp, left: 16.sp, bottom: 16.sp),
            child: Text(
              'August 15, 2022',
              style: labelMedium,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return index.isEven
                  ? HistoryTile(
                      onTap: () => Get.bottomSheet(
                          const TransactionDetailsBottomSheet()),
                      status: HistoryStatus.receive,
                    )
                  : const NftHistoryTile(
                      status: HistoryStatus.inProgress,
                    );
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
