import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';

class HttpService {
  static Future<String> performGetRequest(String server,
      {String endpoint = "", Map<String, String>? headers}) async {
    var response = await http
        .get(
            Uri.parse(
              "$server${endpoint.isNotEmpty ? '/$endpoint' : ''}",
            ),
            headers: headers)
        .timeout(
          const Duration(seconds: 15),
/*       onTimeout: () {
        Future.delayed(const Duration(seconds: 15), () {
          DataHandlerService().setUpTimer();
        });

        throw TimeoutException(
            "Timeout $server${endpoint.isNotEmpty ? '/$endpoint' : ''}");
      }, */
        );
    return response.body;
  }
}
