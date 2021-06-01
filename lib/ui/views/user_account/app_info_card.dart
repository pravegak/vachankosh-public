import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/ui/shared/divider_without_padding.dart';
import 'package:vachankosh/ui/views/about_app.dart';
import 'package:vachankosh/ui/views/feedback_view.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
          padding: EdgeInsets.only(top: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Info', style: AppStyles.k16BlueHeading),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                title: Text('Give app feedback'),
                trailing: Icon(Icons.arrow_forward_ios),
                leading: Icon(FontAwesomeIcons.commentAlt),
                onTap: () {
                  Navigator.pushNamed(context, FeedbackView.routeName);
                },
              ),
              DividerWithoutPadding(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                title: Text('About App'),
                trailing: Icon(Icons.arrow_forward_ios),
                leading: Icon(FontAwesomeIcons.infoCircle),
                onTap: () {
                  Navigator.pushNamed(context, AboutAppView.routeName);
                },
              ),
              DividerWithoutPadding(),
            ],
          )),
    );
  }
}
