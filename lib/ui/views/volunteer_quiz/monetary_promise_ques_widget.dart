import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';
import 'promise_plan_widget.dart';
import 'package:vachankosh/enums.dart';

class MonetaryPromiseQuesWidget extends StatelessWidget {
  const MonetaryPromiseQuesWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<VolunteerQuizModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              model.setMonetaryAmount(value);
            },
            decoration: InputDecoration(
              labelText: "Amount (in rupees)*",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(
                FontAwesomeIcons.rupeeSign,
                size: 20,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 20,
          ),
          PromisePlanWidget(
            promisePlan: PromisePlan.Monetary,
          ),
        ],
      ),
    );
  }
}
