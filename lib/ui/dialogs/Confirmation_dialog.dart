import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelTitle;
  final String buttonTitle;
  final Function onTap;

  const ConfirmationDialog(
      {Key key,
      this.title = "",
      @required this.message,
      this.onTap,
      this.cancelTitle = "Cancel",
      this.buttonTitle = "Yes"})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text(cancelTitle),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(buttonTitle),
          onPressed: () {
            Navigator.pop(context, true);
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ],
    );
  }
}
