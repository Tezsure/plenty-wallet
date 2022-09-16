import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
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
  RxBool? isLoading = false.obs;
  SolidButton({
    Key? key,
    this.title = "",
    this.onPressed,
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
    this.borderWidth = 0,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isLoading ??= false.obs;
    return MaterialButton(
      elevation: elevation,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: active ? onPressed : null,
      disabledColor: disabledButtonColor ??
          ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      color: primaryColor ?? ColorConst.Primary,
      splashColor: ColorConst.Primary.shade60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        alignment: Alignment.center,
        child: Obx(
          () => isLoading != null && isLoading!.value
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : child != null
                  ? (active ? child! : inActiveChild!)
                  : Text(
                      title,
                      style: titleSmall.apply(
                          color: active
                              ? textColor ?? ColorConst.Neutral.shade95
                              : ColorConst.NeutralVariant.shade60),
                    ),
        ),
      ),
    );
  }
}
