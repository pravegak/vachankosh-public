import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegistrationReasonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("What do you want to do?"),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                  color: Colors.orange,
                  textColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon: Icon(FontAwesomeIcons.solidEdit),
                  label: Text('Create an issue')),
              SizedBox(
                height: 10,
              ),
              RaisedButton.icon(
                  color: Colors.green,
                  textColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: Icon(FontAwesomeIcons.handsHelping),
                  label: Text('Register as a volunteer')),
              SizedBox(
                height: 10,
              ),
              Text(
                'Note: You can still do the volunteer registration later',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
