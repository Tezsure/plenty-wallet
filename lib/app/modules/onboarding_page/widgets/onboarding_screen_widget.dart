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
    return Scaffold(
      backgroundColor:
          widget.controller.colorList[widget.controller.pageIndex()],
      body: PageView.builder(
          controller: widget.controller.pageController,
          itemCount: 5,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {
            widget.controller.onPageChanged(value);
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
              child: Container(
                height: 1.height,
                width: 1.width,
                color: widget.controller.colorList[index],
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Lottie.asset(
                      widget.controller.onboardingMessages.keys
                          .elementAt(index),
                      animate: true,
                      frameRate: FrameRate(60),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      repeat: true,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.65.height,
                        width: 1.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: const [0.6, 1],
                            colors: [
                              widget.controller.colorList[index],
                              widget.controller.colorList[index].withOpacity(0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            tileMode: TileMode.decal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.1, 0.6),
                      child: Text(
                        widget.controller.onboardingMessages.values
                            .elementAt(index),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
