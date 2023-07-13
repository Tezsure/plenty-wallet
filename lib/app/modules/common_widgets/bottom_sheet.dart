import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import 'text_scale_factor.dart';

class NaanBottomSheet extends StatefulWidget {
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
  final String? prevPageName;

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
    this.prevPageName,
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
  State<NaanBottomSheet> createState() => _NaanBottomSheetState();
}

class _NaanBottomSheetState extends State<NaanBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: OverrideTextScaleFactor(
          child: widget.isDraggableBottomSheet
              ? DraggableScrollableSheet(
                  initialChildSize: widget.initialChildSize ?? 0.85,
                  minChildSize: widget.minChildSize ?? 0.4,
                  maxChildSize: widget.maxChildSize ?? 1,
                  builder: (_, scrollController) => Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(36.arP)),
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
                          alignment:
                              widget.titleAlignment ?? Alignment.centerLeft,
                          child: Text(
                            (widget.title ?? "").tr,
                            textAlign: TextAlign.start,
                            style: widget.titleStyle ?? titleMedium,
                          ),
                        ),
                        0.020.vspace,
                        Expanded(
                          child: RawScrollbar(
                              controller: scrollController,
                              radius: const Radius.circular(2),
                              trackRadius: const Radius.circular(2),
                              thickness: 4,
                              thumbVisibility: widget.scrollThumbVisibility,
                              thumbColor: ColorConst.NeutralVariant.shade60,
                              trackColor: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.4),
                              trackBorderColor: ColorConst
                                  .NeutralVariant.shade60
                                  .withOpacity(0.4),
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: scrollController,
                                physics: AppConstant.scrollPhysics,
                                itemCount: widget.itemCount,
                                itemBuilder: widget.draggableListBuilder ??
                                    (_, index) => Container(),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  bottom: false,
                  minimum: widget.isScrollControlled
                      ? EdgeInsets.only(top: kToolbarHeight)
                      : EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(36.arP)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxHeight: AppConstant.naanBottomSheetHeight),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(36.arP)),
                          color: Colors.black),
                      width: widget.width ?? 1.width,
                      height: widget.height,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              widget.bottomSheetHorizontalPadding ?? 16.arP),
                      child: widget.isScrollControlled
                          ? SingleChildScrollView(
                              child: isScrollControlledUI(),
                            )
                          : isScrollControlledUI(),
                    ),
                  ),
                ),
        ));
  }

  Widget isScrollControlledUI() {
    return SafeArea(
      bottom: false,
      child: Column(
          mainAxisAlignment:
              widget.mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment:
              widget.crossAxisAlignment ?? CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.prevPageName == null) _buildTopBar(),
            _buildBody()
          ]),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      // height: widget.height == null ? null : (widget.height! - 24.arP),
      child: Column(
        children: [
          if (widget.title != null)
            BottomSheetHeading(
              title: widget.title,
              action: widget.action,
              leading: widget.leading,
            ),
          ...(widget.bottomSheetWidgets ?? const []),
        ],
      ),
    );
  }
}

Column _buildTopBar() {
  return Column(
    children: [
      0.01.vspace,
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 5.arP,
          width: 36.arP,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.arP),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
          ),
        ),
      ),
    ],
  );
}

class BottomSheetHeading extends StatelessWidget {
  const BottomSheetHeading(
      {super.key,
      this.leading,
      this.action,
      this.titleAlignment,
      this.title,
      this.titleStyle});

  final Widget? leading;
  final Widget? action;
  final Alignment? titleAlignment;
  final String? title;
  final TextStyle? titleStyle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        0.02.vspace,
        // else
        //   0.03.vspace,
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: leading ?? const SizedBox.shrink(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: titleAlignment ?? Alignment.center,
                child: Text(
                  (title ?? "").tr,
                  textAlign: TextAlign.center,
                  style: titleStyle ?? titleMedium,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: action ?? closeButton(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// class NaanBottomsheetController extends AnimateBottomsheetController {
//   NaanBottomsheetController();
//   @override
//   void animateForward() {
//     animate.forward();
//     // TODO: implement animateForward
//   }

//   @override
//   void animateReverse() {
//     animate.reverse();

//     // TODO: implement animateReverse
//   }
// }
