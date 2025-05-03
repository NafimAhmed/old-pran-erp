import 'dart:developer';

import 'package:image_picker/image_picker.dart';

Future<XFile?> selectImage(ImageSource imageSource) async {
  try {
    XFile? imageFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 50,
    );
    return imageFile;
  } catch (e) {
    log("Could't able to pick image");
  }
}
