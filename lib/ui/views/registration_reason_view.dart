import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/ui/shared/option_card.dart';
import 'package:vachankosh/ui/views/choose_request_category.dart';
import 'package:vachankosh/ui/views/login_view.dart';
import 'package:vachankosh/ui/views/logo.dart';
import 'package:vachankosh/ui/views/personal_info_view.dart';
import 'package:vachankosh/utils/objects/user.dart';

import 'package:vachankosh/locator.dart';

class RegistrationReasonView extends StatelessWidget {
  static const routeName = '/registrationReason';
  final User user = locator<User>();
  @override
  Widget build(BuildContext context) {
    final Map showWelcomeBack =
        ModalRoute.of(context).settings.arguments as Map;
    if (showWelcomeBack != null &&
        showWelcomeBack.containsKey("showWelcomeBack")) {
      showWelcomeBack.remove('showWelcomeBack');
      Future.delayed(
          Duration.zero,
          () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Welcome back!"),
                  content:
                      Text("Last time you left without completing the steps."),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Continue"))
                  ],
                );
              }));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              Expanded(child: SizedBox()),
              Image.asset(AppImages.joinedHands),
              SizedBox(
                height: 24,
              ),
              OptionCard(
                title: 'Register as a Volunteer',
                icon: FontAwesomeIcons.handsHelping,
                iconColor: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, PersonalInfoView.routeName);
                },
              ),
              SizedBox(
                height: 16,
              ),
              OptionCard(
                title: 'Create a Help Request',
                icon: FontAwesomeIcons.prayingHands,
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(
                      context, ChooseRequestCategoryView.routeName);
                },
              ),
              Expanded(child: SizedBox()),
              OptionCard(
                title: 'Change Mobile Number',
                icon: FontAwesomeIcons.exchangeAlt,
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.pushReplacementNamed(context, LoginView.routeName);
                },
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                    text: "You are logged in as ",
                    style: TextStyle(
                        color: Colors.black38, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "${user.phoneNumber}",
                          style: TextStyle(color: Colors.blue))
                    ]),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
