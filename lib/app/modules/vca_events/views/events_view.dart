import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/generated/i18n.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:naan_wallet/app/data/services/service_models/event_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/nested_route_observer.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/constants.dart';
import '../../../data/services/analytics/firebase_analytics.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../common_widgets/back_button.dart';
import '../../common_widgets/bouncing_widget.dart';
import '../../dapp_browser/views/dapp_browser_view.dart';
import '../controllers/events_controller.dart';
import 'event_bottomsheet.dart';

class VCAEventsView extends GetView<VCAEventsController> {
  const VCAEventsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(VCAEventsController());
    return Navigator(
        observers: [NestedRouteObserver()],
        onGenerateRoute: (_) {
          return MaterialPageRoute(
            builder: (context) => NaanBottomSheet(
              height: AppConstant.naanBottomSheetHeight,
              bottomSheetHorizontalPadding: 0,
              bottomSheetWidgets: [
                SizedBox(
                  height: AppConstant.naanBottomSheetHeight - 20.arP,
                  // margin: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: SizedBox(
                    height: AppConstant.naanBottomSheetHeight,
                    child: Obx(
                      () => Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.arP),
                            child: const BottomSheetHeading(
                              title: "Guide",
                            ),
                          ),
                          0.02.vspace,
                          SizedBox(
                            height: 40.arP,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.tags.length + 1,
                                itemBuilder: (context, index) {
                                  return index == controller.tags.length
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              right: 12.0.arP, left: 12.0.arP),
                                          child: filterChip(index),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.only(left: 12.0.arP),
                                          child: filterChip(index),
                                        );
                                }),
                          ),
                          SizedBox(
                            height: 20.arP,
                          ),
                          Expanded(
                              child: controller.events.values
                                      .toList()
                                      .every((element) => element.isEmpty)
                                  ? _buildEmpty()
                                  : ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.arP),
                                      itemCount: controller.events.length + 2,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            controller.events.length + 1) {
                                          return _addNowButton();
                                        }
                                        if (index == 0) {
                                          return StallsBanner(
                                            banner: controller.banner.value,
                                            stalls: controller.stalls.value,
                                            map: controller.mapImage.value,
                                          );
                                        }
                                        final key = controller.events.keys
                                            .toList()[index - 1];
                                        final events = controller.events[key];

                                        if (events!.isEmpty) {
                                          return const SizedBox
                                              .shrink(); // Don't show empty lists
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 24.0.arP),
                                              child: Text(key,
                                                  style:
                                                      headlineMedium.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: events.length,
                                                itemBuilder: (context, index1) {
                                                  final event = events[index1];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom:
                                                            events.length - 1 ==
                                                                    index1
                                                                ? 0
                                                                : 24.0.arP),
                                                    child: EventWidget(
                                                        event: event),
                                                  );
                                                }),
                                          ],
                                        );
                                      }))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  SizedBox _addNowButton() {
    return SizedBox(
      height: 32.arP,
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: EdgeInsets.all(32.arP),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.EMPTY_STATES}events.svg",
            height: 175.arP,
            width: 175.arP,
          ),
          0.05.vspace,
          Text(
            "No events found".tr,
            textAlign: TextAlign.center,
            style: titleLarge,
          ),
          0.016.vspace,
          Text(
            "There don’t seem to be any events scheduled".tr,
            textAlign: TextAlign.center,
            style: bodySmall.copyWith(
              color: const Color(0xFF958E99),
            ),
          ),
        ],
      ),
    );
  }

  Obx filterChip(int index) {
    return Obx(
      () {
        bool isSelected = controller.selectedTab.value == index;
        return FilterChip(
            shape: StadiumBorder(
                side: BorderSide(
                    color: isSelected
                        ? ColorConst.Primary
                        : const Color(0xff4A454E),
                    width: 1)),
            onSelected: (value) {
              AppConstant.hapticFeedback();
              controller.changeFilter(index);
            },
            padding: EdgeInsets.symmetric(horizontal: 12.arP, vertical: 8.arP),
            backgroundColor:
                isSelected ? ColorConst.Primary : const Color(0xff1E1C1F),
            label: Text(index == 0 ? "Overview" : controller.tags[index - 1],
                style: labelMedium.copyWith(
                    color:
                        isSelected ? Colors.white : const Color(0xff958E99))));
      },
    );
  }
}

class EventWidget extends StatelessWidget {
  const EventWidget({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(VCAEventBottomSheet(eventModel: event));
      },
      child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(
          //   bottom: 20.arP,
          // ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1A22),
            borderRadius: BorderRadius.circular(
              22.arP,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  22.arP,
                ),
                child: event.bannerImage!.endsWith(".svg")
                    ? SvgPicture.network(
                        "${ServiceConfig.naanApis}/vca_images/${event.bannerImage!}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400.arP,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${ServiceConfig.naanApis}/vca_images/${event.bannerImage!}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400.arP,
                      ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  22.arP,
                ),
                child: Container(
                  height: 400.arP,
                  width: double.infinity,
                  decoration: BoxDecoration(gradient: imagesGradient),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.arP, left: 12.0.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190.arP,
                        child: Text(
                          event.title!,
                          style: titleLarge.copyWith(height: 28.arP / 22.arP),
                        ),
                      ),
                      SizedBox(
                        height: 8.0.arP,
                      ),
                      Text(
                          "${intl.DateFormat('E, dd MMM • h:mm a').format(event.timestamp!)} ${event.timestamp!.timeZoneName}",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary)),
                      SizedBox(
                        height: 12.0.arP,
                      ),
                      Row(children: [
                        SolidButton(
                          width: 72.arP,
                          borderRadius: 20.arP,
                          height: 32.arP,
                          title: "Join",
                          primaryColor: ColorConst.Primary,
                          onPressed: () async {
                            if (await canLaunchUrl(Uri.parse(event.link!))) {
                              NaanAnalytics.logEvent(
                                  NaanAnalyticsEvents.JOIN_EVENT,
                                  param: {"name": event.title});
                              await launchUrl(Uri.parse(event.link!),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch ${event.link}';
                            }
                          },
                        ),
                        BouncingWidget(
                          onPressed: () {
                            NaanAnalytics.logEvent(
                                NaanAnalyticsEvents.SHARE_EVENT,
                                param: {"name": event.title});
                            Share.share(event.shareText ??
                                "Check out this event ${event.title}}");
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.arP),
                            child: SvgPicture.asset("assets/svg/share.svg",
                                height: 18.arP, width: 18.arP),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class StallsBanner extends StatelessWidget {
  const StallsBanner({
    super.key,
    required this.banner,
    required this.stalls,
    required this.map,
  });

  final String banner;
  final List<StallsModel> stalls;
  final String map;
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Stalls(
                      stalls: stalls,
                      map: map,
                    )));
      },
      child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(
          //   bottom: 20.arP,
          // ),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1A22),
            borderRadius: BorderRadius.circular(
              22.arP,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  22.arP,
                ),
                child: banner.endsWith(".svg")
                    ? SvgPicture.network(
                        "${ServiceConfig.naanApis}/vca_images/$banner",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400.arP,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${ServiceConfig.naanApis}/vca_images/$banner",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400.arP,
                      ),
              ),
/*               ClipRRect(
                borderRadius: BorderRadius.circular(
                  22.arP,
                ),
                child: Container(
                  height: 400.arP,
                  width: double.infinity,
                  decoration: BoxDecoration(gradient: imagesGradient),
                ),
              ), */
            ],
          )),
    );
  }
}

class Stalls extends StatefulWidget {
  const Stalls({
    super.key,
    required this.stalls,
    required this.map,
  });
  final List<StallsModel> stalls;
  final String map;

  @override
  State<Stalls> createState() => _StallsState();
}

class _StallsState extends State<Stalls> {
  bool isScrollingUp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetWidgets: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: BottomSheetHeading(
            title: "Discover Stalls",
            leading: backButton(
                ontap: () => Navigator.pop(context), lastPageName: "Guide"),
          ),
        ),
        0.02.vspace,
        Container(
          height: AppConstant.naanBottomSheetChildHeight,
          margin: EdgeInsets.only(top: 20.arP),
          child: Scaffold(
            backgroundColor: Colors.black,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: EdgeInsets.only(bottom: 32.arP),
              transform: Matrix4.identity()
                ..translate(
                  0.0,
                  !isScrollingUp ? 0.0 : 200.arP,
                ),
              child: SolidButton(
                height: 45.arP,
                borderRadius: 40.arP,
                width: 125.arP,
                primaryColor: ColorConst.Primary,
                title: "View map",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenView(
                            child: CachedNetworkImage(
                          imageUrl:
                              "${ServiceConfig.naanApis}/vca_images/${widget.map}",
                          // width: 1.2.width,
                          fit: BoxFit.cover,
                          height: 1.2.height,
                        )),
                      ));
                },
              ),
            ),
            body: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final ScrollDirection direction = notification.direction;
                if (direction == ScrollDirection.forward) {
                  isScrollingUp = false;
                  setState(() {});
                } else if (direction == ScrollDirection.reverse) {
                  isScrollingUp = true;
                  setState(() {});
                }
                return false;
              },
              child: ListView.builder(
                  itemCount: widget.stalls.length + 1,
                  itemBuilder: (context, index) {
                    if (index == widget.stalls.length) {
                      return SizedBox(
                        height: 55.arP,
                      );
                    }
                    StallsModel stall = widget.stalls[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        stall.image!.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        22.arP,
                                      ),
                                      child: stall.image!.endsWith(".svg")
                                          ? SvgPicture.network(
                                              "${ServiceConfig.naanApis}/vca_images/${stall.image!}",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 230.arP,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  "${ServiceConfig.naanApis}/vca_images/${stall.image!}",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 230.arP,
                                            )),
                                  SizedBox(
                                    height: 12.arP,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        stall.title!.isNotEmpty
                            ? Text(
                                stall.title!,
                                style: titleSmall,
                              )
                            : const SizedBox(),
                        stall.description!.isNotEmpty
                            ? StallDescription(description: stall.description!)
                            : const SizedBox(),
                        SizedBox(
                          height: 12.arP,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }
}

class StallDescription extends StatefulWidget {
  const StallDescription({
    super.key,
    required this.description,
  });

  final String description;

  @override
  State<StallDescription> createState() => _StallDescriptionState();
}

class _StallDescriptionState extends State<StallDescription> {
  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.arP),
          child: Text(
            widget.description,
            maxLines: showMore ? null : 3,
            style: bodySmall.copyWith(color: const Color(0xff958E99)),
          ),
        ),
        hasTextOverflow(widget.description, bodySmall,
                maxWidth: Get.width - 32.arP)
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    showMore = !showMore;
                  });
                },
                child: Text(
                  !showMore ? "Show more" : "Show less",
                  maxLines: 3,
                  style: labelMedium.copyWith(color: ColorConst.Primary),
                ),
              )
            : Container(),
      ],
    );
  }
}

bool hasTextOverflow(String text, TextStyle style,
    {double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 3}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: minWidth, maxWidth: maxWidth);
  return textPainter.didExceedMaxLines;
}

/* class EventMap extends StatelessWidget {
  final String map;
  const EventMap({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: "Discover stalls",
      height: AppConstant.naanBottomSheetHeight,
      leading: backButton(
          ontap: () {
            Navigator.pop(context);
          },
          lastPageName: "Discover stalls"),
      title: "",
      bottomSheetWidgets: [
        InteractiveViewer(
            child: Image.network("${ServiceConfig.naanApis}/vca_images/$map")),
      ],
    );
  }
} */

class FullScreenView extends StatelessWidget {
  final Widget child;
  const FullScreenView({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        height: Get.height,
        child: Stack(children: [
          SizedBox(
            height: Get.height,
            child: Column(
              // alignment: Alignment.topLeft,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 333),
                        curve: Curves.fastOutSlowIn,
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.5,
                          maxScale: 4,
                          constrained: false,
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomSheetHeading(
            action: Padding(
              padding: EdgeInsets.only(right: 16.arP),
              child: closeButton(),
            ),
            title: "",
            leading: Padding(
              padding: EdgeInsets.only(left: 16.arP),
              child: backButton(
                  isBlack: true,
                  ontap: () => Navigator.pop(context),
                  lastPageName: "Discover stalls"),
            ),
          )
        ]));
  }
}
