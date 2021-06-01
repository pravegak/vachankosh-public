import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/push_notification_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/ui/shared/divider_without_padding.dart';
import 'package:vachankosh/ui/views/dashboard/ground_report_view.dart';
import 'package:vachankosh/ui/views/login_view.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../user_promises_view.dart';

class PromisesAndMoreCard extends StatelessWidget {
  const PromisesAndMoreCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = locator<User>();
    return Card(
      elevation: 1.0,
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 16),
        child: user.volunteer == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Promises and More', style: AppStyles.k16BlueHeading),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.handsHelping),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text('My Promises'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, UserPromisesView.routeName);
                    },
                  ),
                  // DividerWithoutPadding(),
                  // ListTile(
                  //   leading: Icon(FontAwesomeIcons.receipt),
                  //   trailing: Icon(Icons.arrow_forward_ios),
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  //   title: Text('My Expenses'),
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //         context: context,
                  //         isScrollControlled: true,
                  //         builder: (context) => MyExpensesSheet());
                  //   },
                  // ),
                  // DividerWithoutPadding(),
                  // ListTile(
                  //   leading: Icon(FontAwesomeIcons.campground),
                  //   trailing: Icon(Icons.arrow_forward_ios),
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  //   title: Text('Verification Helps'),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, GroundReportView.routeName);
                  //   },
                  // ),
                  DividerWithoutPadding(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.skullCrossbones),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text('Logout'),
                    onTap: () async {
                      Dialogs.showAppDialog(
                          context,
                          LoadingDialog(
                            message: "Sad to see you go",
                          ));
                      //Remove device id
                      await locator<PushNotificationService>()
                          .removeDeviceTokenFromServer();
                      await signOut();
                      locator.resetLazySingleton<User>();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginView.routeName, (route) => false);
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Promises and More', style: AppStyles.k16BlueHeading),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text('Logout'),
                    onTap: () async {
                      //Remove device id
                      await locator<PushNotificationService>()
                          .removeDeviceTokenFromServer();
                      await signOut();
                      locator.resetLazySingleton<User>();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginView.routeName, (route) => false);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
