import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class NaanGetView<T> extends StatefulWidget {
  const NaanGetView({Key? key}) : super(key: key);
  Widget build(BuildContext context, T controller);

  @override
  State<NaanGetView<T>> createState() => _NaanGetViewState<T>();
}

class _NaanGetViewState<T> extends State<NaanGetView<T>> {
  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context) {
    return widget.build(context,controller);
  }

  @override
  void dispose() {
    Get.delete<T>();
    // TODO: implement dispose
    super.dispose();
  }
}
