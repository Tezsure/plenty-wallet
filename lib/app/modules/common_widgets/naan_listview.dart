// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NaanListView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var itemBuilder;
  int itemCount;
  double topSpacing = 10.0;
  double bottomSpacing = 10.0;
  EdgeInsets listViewEdgeInsets = EdgeInsets.zero;
  NaanListView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.topSpacing,
    required this.bottomSpacing,
    required this.listViewEdgeInsets,
  }) : super(key: key);

  @override
  State<NaanListView> createState() => _NaanListViewState();
}

class _NaanListViewState extends State<NaanListView>
    with TickerProviderStateMixin {
  final ValueNotifier<bool> showShadow = ValueNotifier<bool>(false);
  AnimationController? _animationController;
  Animation<double>? _fadeInFadeOut;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _fadeInFadeOut =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.forward();
    // _scrollController!.addListener(() {
    //   if (_scrollController!.offset >= 10) {
    //     showShadow.value = true;
    //   } else {
    //     showShadow.value = false;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: widget.listViewEdgeInsets,
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ValueListenableBuilder<bool>(
              valueListenable: showShadow,
              builder: (context, value, child) {
                if (value) {
                  _animationController!.forward();
                } else {
                  _animationController!.reverse();
                }
                return FadeTransition(
                  opacity: _fadeInFadeOut!,
                  child: Container(
                    width: double.infinity,
                    height: widget.bottomSpacing,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.transparent
                        ])),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
