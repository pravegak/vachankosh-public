import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  Future<File> selectImage(
      {ImageSource imageSource,
      List<CropAspectRatioPreset> aspectRatioPresets}) async {
    final pickedImage =
        await ImagePicker().getImage(source: imageSource, imageQuality: 70);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        ...?aspectRatioPresets
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.orange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    return croppedFile;
  }
}
