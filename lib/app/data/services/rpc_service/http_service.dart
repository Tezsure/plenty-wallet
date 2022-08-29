import 'package:http/http.dart' as http;

class HttpService {
  Future<String> performGetRequest(String server, String endpoint) async {
    var response = await http.get(Uri.parse("$server/$endpoint"));
    return response.body;
  }
}
