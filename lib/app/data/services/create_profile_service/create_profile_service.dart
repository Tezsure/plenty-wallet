import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CreateProfileService {
  final ImagePicker _picker = ImagePicker();

  /// pick new image from gallery and rewrite into temp storage and return the new path
  Future<String> pickANewImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return "";
    return await _writeNewImage(image);
  }

  /// take a new photo using camera and rewrite into temp storage and return the new path
  Future<String> takeAPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image == null) return "";
    return await _writeNewImage(image);
  }

  /// write new image from xfile to app temp directory
  Future<String> _writeNewImage(XFile? image) async {
    Directory tempDir = await getTemporaryDirectory();
    tempDir.create(recursive: true);
    var path = "${tempDir.path}/${image!.name}";
    var imageBytes = await image.readAsBytes();
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(imageBytes);
    return path;
  }
}
