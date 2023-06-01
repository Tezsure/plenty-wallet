import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

import 'package:naan_wallet/app/data/services/service_models/event_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';

import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';

import 'package:naan_wallet/utils/colors/colors.dart';

import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/analytics/firebase_analytics.dart';

// ignore: must_be_immutable
class VCAEventBottomSheet extends StatelessWidget {
  EventModel eventModel;
  VCAEventBottomSheet({Key? key, required this.eventModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.arP),
        topRight: Radius.circular(18.arP),
      ),
      child: Container(
        height: 0.78.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.arP),
            topRight: Radius.circular(18.arP),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            SizedBox(
              height: 0.3.height,
              child: Stack(
                children: [
                  // image
                  eventModel.bannerImage!.endsWith('.svg')
                      ? SvgPicture.network(
                          "${ServiceConfig.naanApis}/vca_images/${eventModel.bannerImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          color: Colors.transparent,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              "${ServiceConfig.naanApis}/vca_images/${eventModel.bannerImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),

                  // back
                  // Positioned(
                  //   top: 30.arP,
                  //   left: 14.arP,
                  //   child: GestureDetector(
                  //     onTap: () => Navigator.pop(context),
                  //     child: Icon(
                  //       Icons.arrow_back_ios_new_rounded,
                  //       color: Colors.white,
                  //       size: 18.arP,
                  //     ),
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 40.arP,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 0.01.height),
                          height: 5.arP,
                          width: 36.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.arP),
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.3),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 16.arP, top: 0.02.height),
                            child: closeButton(),
                          ))
                    ],
                  ),
                ],
              ),
            ),

            // name
            Padding(
              padding:
                  EdgeInsets.only(left: 16.arP, top: 29.arP, right: 16.arP),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250.arP,
                    child: Text(
                      eventModel.title!,
                      textAlign: TextAlign.left,
                      style: titleLarge,
                    ),
                  ),
                  BouncingWidget(
                      child: SvgPicture.asset(
                        "assets/svg/share2.svg",
                        width: 30.arP,
                        height: 30.arP,
                      ),
                      onPressed: () {
                        NaanAnalytics.logEvent(NaanAnalyticsEvents.SHARE_EVENT,
                            param: {"name": eventModel.title});
                        Share.share(eventModel.shareText ??
                            "Check out this event ${eventModel.title}}");
                      })
                ],
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 20.0.arP, horizontal: 16.arP),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svg/calendar.svg',
                    width: 20.arP,
                    height: 20.arP,
                  ),
                  SizedBox(width: 8.arP),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('E, dd MMM y').format(eventModel.timestamp!),
                        style: bodySmall,
                      ),
                      SizedBox(height: 4.arP),
                      Text(
                        "${DateFormat('h:mm a').format(eventModel.timestamp!)} ${eventModel.timestamp!.timeZoneName}",
                        style: bodySmall.copyWith(
                          color: const Color(0xff958E99),
                        ),
                      ),
                      SizedBox(height: 12.arP),
                      BouncingWidget(
                        onPressed: () {
                          final Event event = Event(
                            title: eventModel.title!,
                            description: eventModel.description!,
                            location: eventModel.address!,
                            startDate: eventModel.timestamp!,
                            endDate: eventModel.endTimestamp!,
                            iosParams: IOSParams(
                              reminder: const Duration(
                                  hours:
                                      1), // on iOS, you can set alarm notification after your event.
                              url: eventModel
                                  .link!, // on iOS, you can set url to your event.
                            ),
                            androidParams: const AndroidParams(
                              emailInvites: [], // on Android, you can add invite emails to your event.
                            ),
                          );

                          Add2Calendar.addEvent2Cal(event);
                        },
                        child: Text(
                          "Add to calendar",
                          style: labelMedium.copyWith(
                            color: ColorConst.Primary,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0.arP, left: 16.arP),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svg/location.svg',
                    width: 20.arP,
                    height: 20.arP,
                  ),
                  SizedBox(width: 8.arP),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eventModel.location!,
                        style: bodySmall,
                      ),
                      eventModel.address!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 4.arP),
                                Text(
                                  eventModel.address!,
                                  style: bodySmall.copyWith(
                                    color: const Color(0xff958E99),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.arP, right: 16.arP, bottom: 20.arP),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: bodySmall,
                  ),
                  SizedBox(height: 6.arP),
                  Text(
                    eventModel.description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: bodySmall.copyWith(
                      color: const Color(0xff958E99),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(child: Container()),

            // launch button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 40.arP,
                ),
                child: SolidButton(
                    // title: 'Launch',
                    width: 1.width - 64.arP,
                    height: 50.arP,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/link.svg',
                          width: 20.arP,
                          height: 20.arP,
                        ),
                        SizedBox(width: 10.arP),
                        Text(
                          'Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.arP,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1.arP,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (await canLaunchUrl(Uri.parse(eventModel.link!))) {
                        NaanAnalytics.logEvent(NaanAnalyticsEvents.JOIN_EVENT,
                            param: {"name": eventModel.title});
                        await launchUrl(Uri.parse(eventModel.link!),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch ${eventModel.link}';
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
