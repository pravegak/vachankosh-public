import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';

class DonateBloodQuesWidget extends StatefulWidget {
  const DonateBloodQuesWidget({
    Key key,
  }) : super(key: key);

  static const List<String> bloodGroups = [
    'O+',
    'O-',
    'A-',
    'A+',
    'B-',
    'B+',
    'AB-',
    'AB+'
  ];

  @override
  _DonateBloodQuesWidgetState createState() => _DonateBloodQuesWidgetState();
}

class _DonateBloodQuesWidgetState extends State<DonateBloodQuesWidget> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<VolunteerQuizModel>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "What is your blood group?",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            child: DropdownButton<String>(
                isExpanded: true,
                value: model.bloodGroup,
                hint: Text("Blood group"),
                items: DonateBloodQuesWidget.bloodGroups.map((String val) {
                  return DropdownMenuItem(
                    child: Text(val),
                    value: val,
                  );
                }).toList(),
                onChanged: (value) {
                  model.changeBloodGroup(value);
                }),
          ),
        ],
      ),
    );
  }
}
