import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vachankosh/models/cloud_storage_result.dart';
import 'package:vachankosh/services/cloud_storage_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/image_selector.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../locator.dart';

class ProfileImageWidgetModel extends ChangeNotifier {
  final _imageSelector = locator<ImageSelector>();
  final _cloudStorageService = locator<CloudStorageService>();

  File _selectedImageFile;
  File get selectedImageFile => _selectedImageFile;

  Future selectImage(ImageSource imageSource, BuildContext context) async {
    User user = locator<User>();
    var tempImageFile =
        await _imageSelector.selectImage(imageSource: imageSource);
    if (tempImageFile != null) {
      _selectedImageFile = tempImageFile;
      Dialogs.showAppDialog(
          context,
          LoadingDialog(
            message: 'Uploading...',
          ));
      //Upload image to cloud storage
      CloudStorageResult result = await _cloudStorageService.uploadImage(
          imageToUpload: _selectedImageFile,
          section: "UserProfile",
          title: user.phoneNumber);
      print("Image Uploaded to Firestore");

      if (result != null) {
        //Update in the user document
        user.imageUrl = result.imageUrl;
        await updateProfileImageUrl(result);
        notifyListeners();
        Navigator.pop(context);
      }
    }
  }
}
