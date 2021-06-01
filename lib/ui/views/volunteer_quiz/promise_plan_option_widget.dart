import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';
import 'package:vachankosh/enums.dart';

class PromisePlanOptionWidget extends StatelessWidget {
  const PromisePlanOptionWidget({
    @required this.promisePlan,
    @required this.promisePlanType,
    Key key,
  }) : super(key: key);
  final String promisePlan;
  final PromisePlan promisePlanType;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<VolunteerQuizModel>(context);
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (promisePlanType == PromisePlan.Monetary) {
          model.changeMonetaryPromisePlan(promisePlan);
        } else if (promisePlanType == PromisePlan.Other) {
          model.changeOtherPromisePlan(promisePlan);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            promisePlan,
            style: TextStyle(color: Colors.black87),
          ),
        ),
        decoration: BoxDecoration(
            color: model.monetaryPromisePlan == promisePlan
                ? Colors.blue
                : Colors.transparent,
            border: model.monetaryPromisePlan == promisePlan
                ? null
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
