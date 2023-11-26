import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FeedBackController extends GetxController {
  Rx<File>? imageTempFile;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imageTempFile?.value = File(image.path);
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }
}
