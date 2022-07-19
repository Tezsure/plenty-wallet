import 'package:flutter/material.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/models/tokens_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class TokenBalanceWidget extends StatelessWidget {
  ///A widget that displays tokens along with their balance.
  TokenBalanceWidget({Key? key}) : super(key: key);

  // final HomePageController _homePageController = Get.find();

  /// list of tokens
  final List<TokensModel> listOfTokens = MockData().listOfTokens;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: appleBlack,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: listOfTokens.length,
          itemBuilder: (_, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: FlutterLogo(),
                        ),
                      ),
                      8.hspace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listOfTokens[index].symbol!,
                            style: bold14,
                          ),
                          4.vspace,
                          Text(
                            listOfTokens[index].name!,
                            style: bodyMedium10,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${listOfTokens[index].balance}",
                            style: body12,
                          ),
                          4.vspace,
                          Container(
                            padding: EdgeInsets.only(
                                top: 2, bottom: 2, left: 8, right: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: textGrey1,
                            ),
                            child: Center(
                              child: Text(
                                "\$${listOfTokens[index].priceChange}",
                                style: body12.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                index == listOfTokens.length - 1
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          color: Color(0xff323136),
                          thickness: 1,
                        ),
                      )
              ],
            );
          },
        ),
      );
}
