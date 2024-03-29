import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plenty_wallet/app/data/services/service_models/event_models.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
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

class EventsView extends GetView<EventsController> {
  const EventsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(EventsController());
    return NaanBottomSheet(
      title: "Discover events",
      action: Padding(
        padding: EdgeInsets.only(right: 16.arP),
        child: closeButton(),
      ),
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        Obx(
          () => Container(
            height: AppConstant.naanBottomSheetChildHeight + 12.arP,
            // margin: EdgeInsets.symmetric(horizontal: 16.arP),
            child: Column(
              children: [
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
                                padding: EdgeInsets.only(left: 12.0.arP),
                                child: filterChip(index),
                              );
                      }),
                ),
                0.02.vspace,
                Expanded(
                    child: controller.events.values
                            .toList()
                            .every((element) => element.isEmpty)
                        ? _buildEmpty()
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.arP),
                            itemCount: controller.events.length + 1,
                            itemBuilder: (context, index) {
                              if (index == controller.events.length) {
                                return _addNowButton();
                              }
                              final key =
                                  controller.events.keys.toList()[index];
                              final events = controller.events[key];

                              if (events!.isEmpty) {
                                return const SizedBox
                                    .shrink(); // Don't show empty lists
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 24.0.arP),
                                    child: Text(key,
                                        style: headlineMedium.copyWith(
                                            fontWeight: FontWeight.w700)),
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
                                                  events.length - 1 == index1
                                                      ? 0
                                                      : 24.0.arP),
                                          child: EventWidget(event: event),
                                        );
                                      }),
                                ],
                              );
                            }))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _addNowButton() {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.arP),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.bottomText.value,
              style: bodySmall.copyWith(color: const Color(0xff958E99))),
          SizedBox(
            height: 12.arP,
          ),
          BouncingWidget(
            onPressed: () async {
              CommonFunctions.bottomSheet(
                const DappBrowserView(),
                fullscreen: true,
                settings: RouteSettings(
                  arguments: controller.contactUsLink.value,
                ),
              );
            },
            child: Text("Request event",
                style: labelMedium.copyWith(color: ColorConst.Primary)),
          ),
          const BottomButtonPadding()
        ],
      ),
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
        CommonFunctions.bottomSheet(EventBottomSheet(eventModel: event));
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
                        "${ServiceConfig.naanApis}/events_images/${event.bannerImage!}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400.arP,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${ServiceConfig.naanApis}/events_images/${event.bannerImage!}",
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
                child: Container(
                  height: 0.2.height,
                  width: double.infinity,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // ignore: prefer_const_literals_to_create_immutables
                          colors: [
                        Colors.transparent,
                        Colors.grey[900]!.withOpacity(0.6),
                        Colors.grey[900]!.withOpacity(0.99),
                      ])),
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
                          "${DateFormat('E, dd MMM • h:mm a').format(event.timestamp!)} ${event.timestamp!.timeZoneName}",
                          style: labelMedium.copyWith(
                              color: ColorConst.Secondary)),
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
                        SizedBox(
                          width: 20.arP,
                        ),
                        BouncingWidget(
                          onPressed: () {
                            NaanAnalytics.logEvent(
                                NaanAnalyticsEvents.SHARE_EVENT,
                                param: {"name": event.title});
                            Share.share(event.shareText ??
                                "Check out this event ${event.title}}");
                          },
                          child: SvgPicture.asset("assets/svg/share.svg",
                              height: 18.arP, width: 18.arP),
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
