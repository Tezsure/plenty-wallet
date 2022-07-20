import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class DappSearchWidget extends StatefulWidget {
  /// A widget that displays a list of available dapps.
  const DappSearchWidget({Key? key}) : super(key: key);

  @override
  State<DappSearchWidget> createState() => _DappSearchWidgetState();
}

class _DappSearchWidgetState extends State<DappSearchWidget> {
  /// text controller for search bar in dapp search widget
  TextEditingController dappSearchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) => Container(
        height: 208,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 90,
                child: Center(
                  child: Container(
                    height: 34,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/home_page/search.png", height: 20),
                        4.hspace,
                        Expanded(
                          child: TextField(
                            controller: dappSearchTextController,
                            decoration:
                                InputDecoration.collapsed(hintText: "Search"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    dappWidget(),
                    Spacer(),
                    dappWidget(),
                    Spacer(),
                    dappWidget(),
                    Spacer(),
                    dappWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget dappWidget() => Container(
        height: 63,
        width: 63,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: appleGreen,
            ),
          ),
        ),
      );
}
