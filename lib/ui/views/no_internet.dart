import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vachankosh/ui/views/logo.dart';
import 'package:vachankosh/ui/views/startup_view.dart';

class NoInternetView extends StatelessWidget {
  static const routeName = '/404';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            VachanKoshLogo(),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: <Widget>[
                    Text("Oops, seems like internet is not connected."),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, StartupView.routeName, (route) => false);
                        },
                        child: Text("Retry")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
