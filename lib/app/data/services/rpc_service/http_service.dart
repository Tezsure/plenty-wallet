import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  static Future<String> performGetRequest(String server,
      {String endpoint = "", headers = const {}}) async {
    var response = await http.get(
        Uri.parse(
          "$server${endpoint.isNotEmpty ? '/$endpoint' : ''}",
        ),
        headers: headers);
    return response.body;
  }

  static Future<String> performGetRequestStream(String server,
      {String endpoint = "", headers = const {}}) async {
    Completer<String> completer = Completer<String>();
    var client = HttpClient();

    Future<HttpClientRequest> createClient(Uri uri) async {
      var request = await client.getUrl(uri);
      return request;
    }

    HttpClientRequest request = await createClient(Uri.parse(
      "$server${endpoint.isNotEmpty ? '/$endpoint' : ''}",
    ));

    /// listen on request stream
    /// and yield the response
    HttpClientResponse response = await request.close();

    Future.delayed(const Duration(seconds: 7), (() => completer.complete("")));

    await for (var data in response.transform(const Utf8Decoder())) {
      try {
        jsonDecode(data);
        completer.complete(data);
      } catch (e) {
        //
      }
    }

    return completer.future;
  }
}
