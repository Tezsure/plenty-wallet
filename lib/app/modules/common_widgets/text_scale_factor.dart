import 'package:flutter/material.dart';

/// Flutter widget that overrides [textScaleFactor] passed through [MediaQuery].
class OverrideTextScaleFactor extends StatelessWidget {
  /// Creates a [OverrideTextScaleFactor] widget
  const OverrideTextScaleFactor({
    required this.child,
    this.textScaleFactor = 1.0,
    Key? key,
  }) : super(key: key);

  /// Widget to be used as child
  ///
  /// This cannot be null since there would be no
  /// reason to use [OverrideTextScaleFactor] widget then
  final Widget child;

  /// The [textScaleFactor] used to override the systems' font scale
  ///
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      key: key,
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: child,
    );
  }
}