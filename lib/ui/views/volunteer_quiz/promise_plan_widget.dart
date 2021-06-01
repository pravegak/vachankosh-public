import 'package:flutter/material.dart';
import 'promise_plan_option_widget.dart';
import 'package:vachankosh/enums.dart';

class PromisePlanWidget extends StatelessWidget {
  const PromisePlanWidget({
    Key key,
    @required this.promisePlan,
  }) : super(key: key);
  final PromisePlan promisePlan;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Promise Plan',
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: 4,
        ),
        Text('When the promised quantity should be renewed?'),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            PromisePlanOptionWidget(
              promisePlan: "Monthly",
              promisePlanType: promisePlan,
            ),
            PromisePlanOptionWidget(
              promisePlan: "Quarterly",
              promisePlanType: promisePlan,
            ),
            PromisePlanOptionWidget(
              promisePlan: "Yearly",
              promisePlanType: promisePlan,
            ),
          ],
        ),
      ],
    );
  }
}
