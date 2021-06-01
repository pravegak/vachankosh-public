import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final Widget child;
  final error;
  final errorDescription;
  final Function onTap;
  final String buttonTitle;
  final isDismissible;

  ErrorDialog(
      {Key key,
      this.child,
      this.error = "Error",
      this.errorDescription,
      this.buttonTitle = "Ok",
      this.onTap,
      this.isDismissible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(error),
        content: Text(errorDescription),
        actions: <Widget>[
          FlatButton(
            child: Text(buttonTitle),
            onPressed: () {
              Navigator.pop(context);
              if (onTap != null) {
                onTap();
              }
            },
          ),
        ],
      ),
    );
  }
}
