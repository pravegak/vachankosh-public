import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/ui/views/logo.dart';

class UpdateApp extends StatelessWidget {
  static const routeName = '/updateApp';

  _launchUrl() async {
    var url = AppData.playStoreLink;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch URL somehow");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            VachanKoshLogo(),
            Column(
              children: <Widget>[
                Text("A new version of app is available. Kindly update."),
                FlatButton(
                    onPressed: () => _launchUrl(), child: Text("Update")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
