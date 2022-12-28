import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NaanBottomSheet extends StatelessWidget {
  final double? height;
  final double? width;
  final List<Widget>? bottomSheetWidgets;
  final String? title;
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
    this.bottomSheetWidgets,
    this.title,
    this.blurRadius,
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
    return BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: blurRadius ?? 50, sigmaY: blurRadius ?? 50),
      child: isDraggableBottomSheet
          ? DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.4,
              maxChildSize: 1,
              builder: (_, scrollController) => Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: Colors.black),
                padding: EdgeInsets.symmetric(horizontal: 0.05.width),
                child: Column(
                  children: [
                    0.05.vspace,
                    Center(
                      child: Container(
                        height: 5.sp,
                        width: 36.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffEBEBF5).withOpacity(0.3),
                        ),
                      ),
                    ),
                    0.020.vspace,
                    Align(
                      alignment: titleAlignment ?? Alignment.centerLeft,
                      child: Text(
                        title ?? "Bottom Sheet Title",
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
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: 6,
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
                    horizontal: bottomSheetHorizontalPadding ?? 32),
                child: isScrollControlled
                    ? SingleChildScrollView(
                        child: isScrollControlledUI(),
                      )
                    : isScrollControlledUI(),
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
              0.02.vspace,
              Align(
                alignment: titleAlignment ?? Alignment.center,
                child: Text(
                  title!,
                  textAlign: TextAlign.start,
                  style: titleStyle ?? titleLarge,
                ),
              ),
            ],
            0.010.vspace,
          ] +
          (bottomSheetWidgets ?? const []),
    );
  }
}
