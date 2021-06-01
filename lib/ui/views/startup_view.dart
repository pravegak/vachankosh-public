import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/push_notification_service.dart';
import 'package:vachankosh/ui/views/login_view.dart';
import 'package:vachankosh/ui/views/logo.dart';
import 'package:vachankosh/ui/views/no_internet.dart';
import 'package:vachankosh/ui/views/registration_reason_view.dart';
import 'package:vachankosh/ui/views/update_app.dart';
import 'package:vachankosh/ui/views/dashboard/userhome.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/utils/shared_preferences.dart';

class StartupView extends StatefulWidget {
  static const routeName = '/startup';

  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  User user = locator<User>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  @override
  void initState() {
    super.initState();
    handleStartupLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
            ),
            VachanKoshLogo(),
          ],
        ),
      ),
    );
  }

  void handleStartupLogic() {
    //Check for internet
    checkInternet().then((value) async {
      if (value == false) {
        //Navigate to No internet page
        print('No internet');
        Navigator.pushReplacementNamed(context, NoInternetView.routeName);
      } else {
        //Register for push notifications
        await _pushNotificationService.initialise();
        //Check for app version
        checkAppVersion().then((value) => {
              if (value == false)
                {
                  //Navigate to update app page
                  Navigator.pushReplacementNamed(context, UpdateApp.routeName)
                }
              else
                {
                  //Check if the user is logged in
                  isUserLoggedIn().then((value) {
                    if (value == null) {
                      //Navigate to Login Screen
                      Navigator.pushReplacementNamed(
                          context, LoginView.routeName);
                    } else {
                      //User is logged in
                      user.phoneNumber = value;
                      //Check if the profile is completed
                      profileCompleted(user.phoneNumber)
                          .then((completed) async {
                        if (completed != null && completed) {
                          //LoadUserandGoHome
                          var fetchedUser = await getCurrentUser();
                          user.clone(fetchedUser);
                          Navigator.pushReplacementNamed(
                              context, UserHomeView.routeName);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, RegistrationReasonView.routeName);
                        }
                      });
                    }
                  })
                }
            });
      }
    });
  }
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup("www.google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // we are connected to internet
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Future<bool> checkAppVersion() async {
  double latest = await getLatestVersion();
  if (latest > AppData.version) {
    return false;
  }
  return true;
}

Future<String> isUserLoggedIn() async {
  var user = await FirebaseAuth.instance.currentUser();
  if (user == null) {
    return null;
  }
  return user.phoneNumber;
}

Future<bool> profileCompleted(String number) async {
  bool completed = await getBoolFromShared(number + '-completed');
  if (completed == null || !completed) {
    // if local shared says that signup is not complete, we then
    // fallback to firestore because that's source of truth
    // shared is only used to fastpath positive cases, for negative cases
    // we should confirm with server
    completed = await existsUser();
    // be smart and cache this locally to prevent a network connection
    if (completed) {
      storeBoolInShared('$number-completed', true);
    }
  }
  return completed;
}
