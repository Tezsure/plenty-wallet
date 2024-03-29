import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import 'bouncing_widget.dart';

// ignore: must_be_immutable
class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  final GestureLongPressCallback? onLongPressed;
  final Color? textColor;
  final double? height;
  final double? width;
  final Widget? rowWidget;
  final bool active;
  final Widget? child;
  final Color? disabledButtonColor;
  final Color? primaryColor;
  final double elevation;
  final Color borderColor;
  final double borderWidth;
  final Widget? inActiveChild;
  final double? borderRadius;
  RxBool? isLoading = false.obs;
  final TextStyle? titleStyle;

  SolidButton(
      {Key? key,
      this.title = "",
      this.onPressed,
      this.onLongPressed,
      this.textColor,
      this.height,
      this.width,
      this.rowWidget,
      this.active = true,
      this.child,
      this.inActiveChild,
      this.disabledButtonColor,
      this.primaryColor,
      this.elevation = 2,
      this.borderColor = Colors.transparent,
      this.borderWidth = 01.5,
      this.isLoading,
      this.titleStyle,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLoading ??= false.obs;
    return BouncingWidget(
      onPressed: active ? onPressed : null,
      onLongPressed: active ? (onLongPressed ?? onPressed) : null,
      duration: onLongPressed != null
          ? const Duration(
              milliseconds: 800,
            )
          : const Duration(
              milliseconds: 200,
            ),
      child: Container(
        decoration: BoxDecoration(
            color: !active || (onPressed == null && onLongPressed == null)
                ? (disabledButtonColor ?? const Color(0xFF1E1C1F))
                : (primaryColor ?? ColorConst.Primary),
            borderRadius: BorderRadius.circular(borderRadius ?? 8.arP)),
        height: height ?? 50.arP,
        // elevation: elevation,
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        // onPressed: active ? onPressed : null,
        // onLongPress: onLongPressed,
        // disabledColor: disabledButtonColor ?? const Color(0xFF1E1C1F),
        // color: primaryColor ?? ColorConst.Primary,
        // splashColor: ColorConst.Primary.shade60,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(borderRadius ?? 8)),
        child: Container(
          height: height ?? 50.arP,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.arP),
            color: Colors.transparent,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          alignment: Alignment.center,
          child: Obx(
            () => isLoading != null && isLoading!.value
                ? SizedBox(
                    width: 30.arP,
                    height: 30.arP,
                    child: const CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  )
                : rowWidget == null
                    ? child != null
                        ? (active ? child! : inActiveChild!)
                        : Text(
                            title.tr,
                            style: titleStyle ??
                                titleSmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: !active ||
                                            (onPressed == null &&
                                                onLongPressed == null)
                                        ? ColorConst.NeutralVariant.shade60
                                        : textColor ??
                                            ColorConst.Neutral.shade100),
                          )
                    : rowWidget!,
          ),
        ),
      ),
    );
  }
}
