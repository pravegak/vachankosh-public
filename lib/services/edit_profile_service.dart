import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/constants/app_constants.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../locator.dart';

class EditProfileService {
  User user = locator<User>();
  CollectionReference userCollectionReference =
      Firestore.instance.collection(AppConstants.kFirestoreUsersCollection);
  Future<dynamic> changeProfileField(String field, dynamic value) async {
    try {
      await userCollectionReference
          .document(user.phoneNumber)
          .updateData({field: value});
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}