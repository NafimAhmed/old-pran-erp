import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<XFile?> selectImage(ImageSource imageSource) async {
  try {
    XFile? imageFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 50,
    );

    // if (imageFile == null) {
    //   throw Exception("Image picking returned null");
    // }

    // File(imageFile.path).renameSync(imageName);
    return imageFile;
  } catch (e) {
    log("Couldn't pick image: $e");
    return null;
  }
}
