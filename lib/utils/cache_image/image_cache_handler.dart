import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageCacheHandler {
  Future<File> getAndCacheImage(String url) async {
    var oriUrl = url;
    url = url.replaceAll('/', '_');
    var file = File(Directory.systemTemp.path +
        (Directory.systemTemp.path.endsWith('/') ? '' : '/') +
        url);
    if (file.existsSync()) return file;
    var res = await http.get(Uri.parse(oriUrl));
    await file.writeAsBytes(res.bodyBytes);
    return file;
  }
}
