import 'package:flutter/cupertino.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class TezosHeadlineWidget extends StatelessWidget {
  /// A widget that displays a list of tezos [Headlines].
  TezosHeadlineWidget({Key? key}) : super(key: key);

  /// list of tezos headlines
  final List tezosHeadlineList = MockData().tezosHeadlineList;

  @override
  Widget build(BuildContext context) => Container(
        width: 1.width,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        decoration: BoxDecoration(
          gradient: appleBlack,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tezos Headlines",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: blue,
              ),
            ),
            16.vspace,
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: tezosHeadlineList.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == tezosHeadlineList.length - 1 ? 0 : 16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey,
                        ),
                      ),
                      12.hspace,
                      Expanded(
                        child: Text(
                          tezosHeadlineList[index].desc,
                          style: body12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
}
