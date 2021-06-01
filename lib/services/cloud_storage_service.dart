import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:vachankosh/models/cloud_storage_result.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage(
      {@required File imageToUpload,
      @required String section,
      @required String title}) async {
    var imageFileName = title;
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(section).child(imageFileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      //It means downloadUrl is not null
      var url = downloadUrl.toString();
      return CloudStorageResult(imageUrl: url, imageFileName: imageFileName);
    }
    return null;
  }
}
