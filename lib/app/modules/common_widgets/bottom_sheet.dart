import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'text_scale_factor.dart';

class NaanBottomSheet extends StatelessWidget {
  final double? height;
  final double? width;
  final List<Widget>? bottomSheetWidgets;
  final String? title;
  final Widget? action;
  final Widget? leading;
  final double? blurRadius;
  final double? gradientStartingOpacity;
  final bool isDraggableBottomSheet;
  final bool scrollThumbVisibility;
  final Alignment? titleAlignment;
  final TextStyle? titleStyle;
  final double? bottomSheetHorizontalPadding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isScrollControlled;
  final double? initialChildSize;
  final int? itemCount;
  final double? minChildSize;
  final double? maxChildSize;
  final Widget Function(BuildContext context, int index)? draggableListBuilder;

  /// Create a bottom sheet of non-draggable and draggable type.
  ///
  /// The [bottomSheetWidgets] argument for non-draggable case or [draggableListBuilder] argument for draggable sheet case must not be null.
  ///
  /// Use [title] property for the heading of the bottom sheet
  ///
  /// The [height] & [width] property only applies to non-draggable bottom sheet
  const NaanBottomSheet({
    super.key,
    this.height,
    this.width,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.bottomSheetWidgets,
    this.title,
    this.action,
    this.leading,
    this.blurRadius,
    this.itemCount = 6,
    this.gradientStartingOpacity,
    this.isDraggableBottomSheet = false,
    this.draggableListBuilder,
    this.scrollThumbVisibility = true,
    this.titleAlignment,
    this.titleStyle,
    this.bottomSheetHorizontalPadding,
    this.isScrollControlled = false,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  }) : assert(
          isDraggableBottomSheet == false
              ? bottomSheetWidgets != null
              : draggableListBuilder != null,
        );

  @override
  Widget build(BuildContext context) {
    return OverrideTextScaleFactor(
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: blurRadius ?? 50, sigmaY: blurRadius ?? 50),
        child: isDraggableBottomSheet
            ? DraggableScrollableSheet(
                initialChildSize: initialChildSize ?? 0.85,
                minChildSize: minChildSize ?? 0.4,
                maxChildSize: maxChildSize ?? 1,
                builder: (_, scrollController) => Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 0.05.width),
                  child: Column(
                    children: [
                      0.02.vspace,
                      Center(
                        child: Container(
                          height: 5.arP,
                          width: 36.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffEBEBF5).withOpacity(0.3),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.arP,
                      ),
                      Align(
                        alignment: titleAlignment ?? Alignment.centerLeft,
                        child: Text(
                          title ?? "",
                          textAlign: TextAlign.start,
                          style: titleStyle ?? titleLarge,
                        ),
                      ),
                      0.020.vspace,
                      Expanded(
                        child: RawScrollbar(
                            controller: scrollController,
                            radius: const Radius.circular(2),
                            trackRadius: const Radius.circular(2),
                            thickness: 4,
                            thumbVisibility: scrollThumbVisibility,
                            thumbColor: ColorConst.NeutralVariant.shade60,
                            trackColor: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.4),
                            trackBorderColor: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.4),
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: scrollController,
                              physics: AppConstant.scrollPhysics,
                              itemCount: itemCount,
                              itemBuilder: draggableListBuilder ??
                                  (_, index) => Container(),
                            )),
                      )
                    ],
                  ),
                ),
              )
            : SafeArea(
                bottom: false,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.black),
                  width: width ?? 1.width,
                  height: height,
                  padding: EdgeInsets.symmetric(
                      horizontal: bottomSheetHorizontalPadding ?? 16.arP),
                  child: isScrollControlled
                      ? SingleChildScrollView(
                          child: isScrollControlledUI(),
                        )
                      : isScrollControlledUI(),
                ),
              ),
      ),
    );
  }

  Column isScrollControlledUI() {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: <Widget>[
            0.01.vspace,
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 5,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                ),
              ),
            ),
            if (title != null) ...[
              Column(
                children: [
                  // if (action == null && leading == null)
                  0.04.vspace,
                  // else
                  //   0.03.vspace,
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: leading ?? SizedBox.shrink(),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: titleAlignment ?? Alignment.center,
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: titleStyle ?? titleLarge,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: action ?? SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ],
              )

              // Align(
              //   alignment: titleAlignment ?? Alignment.center,
              //   child: Text(
              //     title!,
              //     textAlign: TextAlign.start,
              //     style: titleStyle ?? titleLarge,
              //   ),
              // ),
            ],
            // 0.010.vspace,
          ] +
          (bottomSheetWidgets ?? const []),
    );
  }
}
