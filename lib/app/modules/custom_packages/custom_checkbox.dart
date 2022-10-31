// ignore_for_file: library_private_types_in_public_api

library custom_check_box;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color checkedIconColor;
  final Color checkedFillColor;
  final dynamic checkedIcon;
  final Color uncheckedIconColor;
  final Color uncheckedFillColor;
  final IconData uncheckedIcon;
  final double? borderWidth;
  final double? checkBoxSize;
  final double? checkBoxIconSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.checkedIconColor = Colors.white,
    this.checkedFillColor = Colors.teal,
    this.checkedIcon,
    this.checkBoxIconSize,
    this.uncheckedIconColor = Colors.white,
    this.uncheckedFillColor = Colors.white,
    this.uncheckedIcon = Icons.close,
    this.borderWidth,
    this.checkBoxSize,
    this.shouldShowBorder = false,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor,
    this.tooltip,
    this.mouseCursors,
  }) : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _checked;
  late CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    late Color fillColor;
    late Color iconColor;
    late dynamic iconData;

    switch (_status) {
      case CheckStatus.checked:
        fillColor = widget.checkedFillColor;
        iconColor = widget.checkedIconColor;
        iconData = widget.checkedIcon;
        break;
      case CheckStatus.unchecked:
        fillColor = widget.uncheckedFillColor;
        iconColor = widget.uncheckedIconColor;
        iconData = widget.uncheckedIcon;
        break;
    }

    return AnimatedContainer(
      width: widget.checkBoxSize,
      height: widget.checkBoxSize,
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(widget.checkBoxIconSize ?? 0),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius ?? 6)),
        border: Border.all(
          color: widget.shouldShowBorder
              ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
              : (!widget.value
                  ? (widget.borderColor ?? Colors.teal.withOpacity(0.6))
                  : Colors.transparent),
          width: widget.shouldShowBorder
              ? widget.borderWidth ?? 2.0
              : widget.borderWidth ?? 2.0,
        ),
      ),

      // ignore: unnecessary_type_check
      child: SizedBox(
        width: widget.checkBoxIconSize ?? 18,
        height: widget.checkBoxIconSize ?? 18,
        child: iconData is IconData
            ? Icon(
                iconData,
                color: iconColor,
                size: widget.checkBoxIconSize ?? 18,
              )
            : SvgPicture.asset(
                iconData as String,
                color: iconColor,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onChanged(!_checked),
      child: _buildIcon(),
    );

    // IconButton(
    //   icon: _buildIcon(),
    //   onPressed: () => widget.onChanged(!_checked),
    //   splashRadius: widget.splashRadius,
    //   splashColor: widget.splashColor,
    //   tooltip: widget.tooltip,
    //   mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
    // );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
