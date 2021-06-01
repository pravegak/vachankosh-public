// A page which represents that this functionality is not
// completed yet and is still in kitchen. It will be completed
// soon

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vachankosh/constants/app_styles.dart';

class NotCompleteView extends StatefulWidget {
  static const routeName = '/notComplete';

  @override
  _NotCompleteViewState createState() => _NotCompleteViewState();
}

class _NotCompleteViewState extends State<NotCompleteView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    'assets/rive/ud.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "This is under construction, will be finished soon.",
                  textAlign: TextAlign.center,
                  style: AppStyles.k16BlackHeading,
                ),
              ],
            ),
          ),
        ));
  }
}
