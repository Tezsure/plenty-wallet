import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

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
    return PageView.builder(
        controller: widget.controller.pageController,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        onPageChanged: (val) => widget.controller.increment(val),
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
            child: Container(
              color: widget.controller.colorList[index],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Lottie.asset(
                        widget.controller.onboardingMessages.keys
                            .elementAt(index),
                        animate: true,
                        frameRate: FrameRate(30),
                        height: 0.65.height,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0.064.width),
                          child: CustomPaint(
                            foregroundPainter: RectangleBlurPainter(
                              blurSigma: 10,
                              painterColor: widget.controller.colorList[index],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0.3.width,
                        left: 0.3.width,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, -0.12.height),
                                color: widget.controller.colorList[index]
                                    .withOpacity(0.6),
                                spreadRadius: 0.14.height,
                                blurRadius: 20,
                              ),
                            ],
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 52),
                      child: Text(
                        widget.controller.onboardingMessages.values
                            .elementAt(index),
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class RectangleBlurPainter extends CustomPainter {
  RectangleBlurPainter({required this.painterColor, required this.blurSigma});
  final double blurSigma;
  final Color painterColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = painterColor
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Rect rectParameters = Rect.fromLTWH(0, -16, 1.width, 20);
    canvas.drawRect(rectParameters, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
