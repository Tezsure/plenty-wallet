import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';

class CollectionCategories extends StatelessWidget {
  const CollectionCategories({
    super.key,
    required this.categoriesName,
    required this.onTap,
    required this.currentSelectedCategoryIndex,
  });
  final List<String> categoriesName;
  final Function(int) onTap;
  final int currentSelectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.06.height,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        itemCount: categoriesName.length,
        physics: const BouncingScrollPhysics(parent: ClampingScrollPhysics()),
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.sp),
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Chip(
                  padding: EdgeInsets.all(4.sp),
                  elevation: 1,
                  autofocus: true,
                  shadowColor: Colors.amber,
                  iconTheme: const IconThemeData(color: Colors.transparent),
                  label: Padding(
                    padding: EdgeInsets.only(bottom: 2.sp),
                    child: Text(
                      categoriesName[index],
                      style: labelSmall.copyWith(
                          color: index == currentSelectedCategoryIndex
                              ? Colors.white
                              : ColorConst.NeutralVariant.shade60),
                    ),
                  ),
                  backgroundColor: index == currentSelectedCategoryIndex
                      ? ColorConst.Primary
                      : ColorConst.NeutralVariant.shade10,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  side: BorderSide(
                    color: index == currentSelectedCategoryIndex
                        ? Colors.transparent
                        : ColorConst.NeutralVariant.shade60,
                    width: 1,
                  ),
                  labelStyle: labelSmall,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            )),
      ),
    );
  }
}
