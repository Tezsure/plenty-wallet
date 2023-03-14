import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/event_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/constants.dart';
import '../../../data/services/analytics/firebase_analytics.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../common_widgets/back_button.dart';
import '../../common_widgets/bouncing_widget.dart';
import '../controllers/events_controller.dart';
import 'event_bottomsheet.dart';

class EventsView extends GetView<EventsController> {
  const EventsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(EventsController());
    return NaanBottomSheet(
      title: "Events",
      action: Padding(
        padding: EdgeInsets.only(right: 16.arP),
        child: closeButton(),
      ),
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        Obx(
          () => Container(
            height: AppConstant.naanBottomSheetHeight - 56.arP,
            margin: EdgeInsets.symmetric(horizontal: 16.arP),
            child: Column(
              children: [
                0.02.vspace,
                SizedBox(
                  height: 40.arP,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.tags.length + 1,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? filterChip(index)
                            : Padding(
                                padding: EdgeInsets.only(left: 12.0.arP),
                                child: filterChip(index),
                              );
                      }),
                ),
                0.01.vspace,
                Expanded(
                    child: ListView.builder(
                        itemCount: controller.events.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.events.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 24.0.arP),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.bottomText.value,
                                      style: bodySmall.copyWith(
                                          color: const Color(0xff958E99))),
                                  SizedBox(
                                    height: 12.arP,
                                  ),
                                  BouncingWidget(
                                    onPressed: () async {
                                      if (await canLaunchUrl(Uri.parse(
                                          controller.contactUsLink.value))) {
                                        await launchUrl(
                                            Uri.parse(
                                                controller.contactUsLink.value),
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        throw 'Could not launch ${controller.contactUsLink.value}';
                                      }
                                    },
                                    child: Text("Contact Us",
                                        style: labelMedium.copyWith(
                                            color: ColorConst.Primary)),
                                  ),
                                  SizedBox(
                                    height: 12.arP,
                                  ),
                                ],
                              ),
                            );
                          }
                          final key = controller.events.keys.toList()[index];
                          final events = controller.events[key];
                          if (events!.isEmpty) {
                            return const SizedBox
                                .shrink(); // Don't show empty lists
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: 24.0.arP),
                                child: Text(key,
                                    style: headlineMedium.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    final event = events[index];
                                    return EventWidget(event: event);
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

  Obx filterChip(int index) {
    return Obx(
      () => FilterChip(
          shape: StadiumBorder(
              side: BorderSide(
                  color: const Color(0xff4A454E),
                  width: controller.selectedTab.value == index ? 0 : 1)),
          onSelected: (value) {
            controller.changeFilter(index);
          },
          padding: EdgeInsets.symmetric(horizontal: 20.arP, vertical: 12.arP),
          backgroundColor: controller.selectedTab.value == index
              ? ColorConst.Primary
              : const Color(0xff1E1C1F),
          label: Text(index == 0 ? "Overview" : controller.tags[index - 1],
              style: labelMedium.copyWith(
                  color: controller.selectedTab.value == index
                      ? Colors.white
                      : const Color(0xff958E99)))),
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
          margin: EdgeInsets.only(
            bottom: 20.arP,
          ),
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
                        fit: BoxFit.fill,
                        height: 400.arP,
                        width: double.infinity,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${ServiceConfig.naanApis}/events_images/${event.bannerImage!}",
                        fit: BoxFit.cover,
                        height: 400.arP,
                        width: double.infinity,
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
                          "${DateFormat('E, dd MMM • h:mm a').format(event.timestamp!)} ${event.timestamp!.timeZoneName}",
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
