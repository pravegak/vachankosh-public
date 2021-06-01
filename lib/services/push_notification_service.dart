import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/objects/user.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _deviceTokensReference = Firestore.instance.collection('deviceTokens');
  final _userPhoneNo = locator<User>().phoneNumber;

  Future initialise() async {
    String token = await _firebaseMessaging.getToken();
    print('Token: $token');
    if (Platform.isIOS) {
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    }

    _firebaseMessaging.configure(
      //App is in the foreground and push notification is received.
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      //App has been closed and it's opened from the push notification directly.
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      //App is in the background and it's opened from the push notification.
      onResume: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
    );
  }

  Future<dynamic> storeDeviceTokenToServer() async {
    String token = await _firebaseMessaging.getToken();
    try {
      await _deviceTokensReference
          .document('deviceIds')
          .setData({_userPhoneNo: token}, merge: true);
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> removeDeviceTokenFromServer() async {
    try {
      await _deviceTokensReference
          .document('deviceIds')
          .updateData({locator<User>().phoneNumber: FieldValue.delete()});
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
