import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_1x1_widget.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NftWidget extends StatefulWidget {
  /// A widget that displays nfts
  NftWidget({Key? key}) : super(key: key);

  @override
  _NftWidgetState createState() => _NftWidgetState();
}

class _NftWidgetState extends State<NftWidget> {
  /// list of nfts
  List listOfNFTTokens = MockData().listOfNFTTokens;

  /// current nft index for sliding nft
  int currentNFTIndex = 0;

  /// timer for sliding nft
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startNFTTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  startNFTTimer() => _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        currentNFTIndex = currentNFTIndex == listOfNFTTokens.length - 1
            ? 0
            : currentNFTIndex + 1;
      });

  @override
  Widget build(BuildContext context) => WidgetWrapper2x1(
        LinearGradient(colors: [Colors.black, Colors.black]),
        child: Container(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    listOfNFTTokens[currentNFTIndex].displayUri!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listOfNFTTokens[currentNFTIndex].name!,
                      style: body12,
                    ),
                    Text(
                      "Objct.com",
                      style: bodyMedium10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
