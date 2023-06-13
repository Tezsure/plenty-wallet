import 'dart:async';

import 'package:http/http.dart' as http;

class HttpService {
  static Future<String> performGetRequest(String server,
      {String endpoint = "",
      Map<String, String>? headers,
      bool callSetupTimer = false,
      int timeout = 15}) async {
    var response = await http
        .get(
            Uri.parse(
              "$server${endpoint.isNotEmpty ? '/$endpoint' : ''}",
            ),
            headers: headers)
        .timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        throw TimeoutException(
            "Timeout $server${endpoint.isNotEmpty ? '/$endpoint' : ''}");
      },
    );
    return response.body;
  }

  static Future<String> performPostRequest(String server,
      {String endpoint = "",
      Map<String, String>? headers,
      Map<String, dynamic>? body}) async {
    var response = await http
        .post(
            Uri.parse(
              "$server${endpoint.isNotEmpty ? '/$endpoint' : ''}",
            ),
            headers: headers,
            body: body)
        .timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException(
            "Timeout $server${endpoint.isNotEmpty ? '/$endpoint' : ''}");
      },
    );
    return response.body;
  }
}
