import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() => runApp(
      DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => GetMaterialApp(
                useInheritedMediaQuery: true,
                // locale: DevicePreview.locale(),
                builder: DevicePreview.appBuilder,
                theme: ThemeData(
                  fontFamily: "Poppins",
                ),
                debugShowCheckedModeBanner: false,
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes,
              )),
    );
