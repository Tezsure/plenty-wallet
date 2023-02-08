library flutter_bounce;

import 'package:flutter/material.dart';

import 'text_scale_factor.dart';

class BouncingWidget extends StatefulWidget {
  final Function()? onPressed;
  final Function()? onLongPressed;
  final Widget child;
  final Duration duration;
  // This will get the data from the pages
  // Makes sure child won't be passed as null
  const BouncingWidget(
      {required this.child,
      this.duration = const Duration(milliseconds: 100),
      required this.onPressed,
      this.onLongPressed});

  @override
  BouncingWidgetState createState() => BouncingWidgetState();
}

class BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late double _scale;

  // This controller is responsible for the animation
  late AnimationController _animate;

  //Getting the VoidCallack onPressed passed by the user
  Function? get onPressed => widget.onPressed;

  //Getting the VoidCallack onLongPressed passed by the user
  Function? get onLongPressed => widget.onLongPressed;

  // This is a user defined duration, which will be responsible for
  // what kind of bounce he/she wants
  @override
  void initState() {
    //defining the controller
    _animate = AnimationController(
        vsync: this,
        duration: const Duration(
            milliseconds: 100), //This is an inital controller duration
        lowerBound: 0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      }); // Can do something in the listener, but not required
    super.initState();
  }

  @override
  void dispose() {
    // To dispose the contorller when not required
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return OverrideTextScaleFactor(
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: _onTap,
          onLongPress: _onLongPress,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
          )),
    );
  }

  //This is where the animation works out for us
  // Both the animation happens in the same method,
  // but in a duration of time, and our callback is called here as well
  void _onTap() {
    if (onPressed == null && onLongPressed == null) return;
    //Firing the animation right away
    _animate.forward();

    //Now reversing the animation after the user defined duration
    Future.delayed(widget.duration, () {
      _animate.reverse();
      if (onPressed != null) {
        onPressed?.call();
      }
    });
  }

  //This is where the animation works out for us
  // Both the animation happens in the same method,
  // but in a duration of time, and our callback is called here as well
  void _onLongPress() {
    if (onPressed == null && onLongPressed == null) return;

    //Firing the animation right away
    _animate.forward();

    //Now reversing the animation after the user defined duration
    Future.delayed(widget.duration, () {
      _animate.reverse();
      if (onLongPressed != null) {
        onLongPressed?.call();
      }
    });
  }
}
