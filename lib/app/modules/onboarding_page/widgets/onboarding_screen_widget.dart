import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plenty_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class OnboardingWidget extends StatefulWidget {
  final OnboardingPageController controller;
  const OnboardingWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.controller.animateSlider());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        height: 1.height,
        width: 1.width,
        duration: const Duration(milliseconds: 5000),
        color: widget.controller.colorList[widget.controller.pageIndex()],
        child: PageView.builder(
            controller: widget.controller.pageController,
            itemCount: widget.controller.onboardingMessages.keys.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              widget.controller.onPageChanged(value);
              widget.controller.resetTimer();
              setState(() {});
            },
            itemBuilder: (_, index) {
              return AnnotatedRegion(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor: widget.controller.colorList[index],
                ),
                child: GestureDetector(
                  onTapDown: (_) {
                    widget.controller.pause();
                  },
                  onTapUp: (details) {
                    widget.controller.play();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    // height: 517.arP,
                    // width: 390.arP,
                    color: widget
                        .controller.colorList[widget.controller.pageIndex()],
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 450.arP,
                            width: 1.width,
                            child: Lottie.asset(
                              widget.controller.onboardingMessages.keys
                                  .elementAt(index),
                              animate: true,
                              frameRate: FrameRate.max,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              repeat: true,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: .65.height,
                            width: 1.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: const [0.3, 0.5, 1],
                                colors: [
                                  widget.controller
                                      .colorList[widget.controller.pageIndex()]
                                      .withOpacity(1),
                                  widget.controller
                                      .colorList[widget.controller.pageIndex()]
                                      .withOpacity(0.9),
                                  widget.controller
                                      .colorList[widget.controller.pageIndex()]
                                      .withOpacity(0),
                                ],
                                begin: const Alignment(0, 0),
                                end: const Alignment(0, -0.8),
                                tileMode: TileMode.clamp,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: AnimatedContainer(
                            margin: EdgeInsets.symmetric(horizontal: 32.arP),
                            padding: EdgeInsets.only(bottom: .2.height),
                            duration: const Duration(milliseconds: 1000),
                            color: Colors.transparent,
                            alignment: Alignment.bottomLeft,
                            // alignment: const Alignment(-0.1, 0.6),
                            child: Text(
                              widget.controller.onboardingMessages.values
                                  .elementAt(widget.controller.pageIndex())
                                  .tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                color: widget.controller.pageIndex() == 0 ||
                                        widget.controller.pageIndex() == 3 ||
                                        widget.controller.pageIndex() == 4
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 40.arP,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
