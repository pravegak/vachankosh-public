// A page which lists the various kinds of help requests and
// asks user about which one they want to create

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/ui/shared/option_card.dart';
import 'package:vachankosh/ui/views/blood_request/blood_request_view.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/create_issue_view.dart';
import 'package:vachankosh/ui/views/not_completed.dart';

class ChooseRequestCategoryView extends StatelessWidget {
  static const routeName = '/chooseRequestCategory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Request Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OptionCard(
              title: 'Medicine Request',
              icon: FontAwesomeIcons.briefcaseMedical,
              iconColor: Colors.teal,
              onTap: () {
                Navigator.pushNamed(
                    context, CreateMedicineRequestView.routeName);
              },
            ),
            SizedBox(
              height: 20,
            ),
            OptionCard(
              title: 'Blood or Plasma',
              icon: FontAwesomeIcons.tint,
              iconColor: Colors.red[900],
              onTap: () {
                Navigator.pushNamed(context, NotCompleteView.routeName);
                // Navigator.pushNamed(context, BloodRequestView.routeName);
              },
            ),
            SizedBox(
              height: 20,
            ),
            OptionCard(
              title: 'Other Request',
              icon: Icons.more_horiz,
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pushNamed(context, NotCompleteView.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
