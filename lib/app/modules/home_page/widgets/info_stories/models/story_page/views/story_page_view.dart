import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/story_page_controller.dart';

class StoryPageView extends GetView<StoryPageController> {
  final Function()? onPressed;
  final int itemCount;
  final double? containerHeight, width;
  final List<String> profileImagePath;
  final List<String> storyTitle;
  const StoryPageView(
      {this.containerHeight,
      required this.profileImagePath,
      required this.storyTitle,
      this.width,
      this.itemCount = 4,
      this.onPressed,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: containerHeight ?? 0.2.height,
        width: 1.width,
        child: ListView.builder(
            itemCount: profileImagePath.length,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: true,
            cacheExtent: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: width ?? 69,
                    height: 69,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(
                            profileImagePath[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                        12.vspace,
                        Text(
                          storyTitle[index],
                          textAlign: TextAlign.center,
                          style: labelSmall.copyWith(
                            color: ColorConst.Neutral.shade95,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
}
