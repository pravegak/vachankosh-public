import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/enums.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';

class QuestionWidget extends StatelessWidget {
  final VolunteerQuestion questionType;
  final String primaryQuestion;
  final String questionDesc;
  final Widget secondaryQuestionWidget;

  QuestionWidget({
    @required this.primaryQuestion,
    @required this.questionType,
    @required this.questionDesc,
    this.secondaryQuestionWidget,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<VolunteerQuizModel>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              primaryQuestion,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              questionDesc,
              style: TextStyle(color: Colors.blueGrey),
            ),
            SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
              InkWell(
                onTap: () {
                  model.changePrimaryQuestionState(
                    questionType,
                    true,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: model.primaryQuestionState(questionType) == null
                        ? Colors.white
                        : model.primaryQuestionState(questionType)
                            ? Colors.green
                            : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: model.primaryQuestionState(questionType) == null
                            ? Colors.green
                            : model.primaryQuestionState(questionType)
                                ? Colors.white
                                : Colors.green,
                        size: 32,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                            color:
                                model.primaryQuestionState(questionType) == null
                                    ? Colors.green
                                    : model.primaryQuestionState(questionType)
                                        ? Colors.white
                                        : Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  model.changePrimaryQuestionState(
                    questionType,
                    false,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                      color: model.primaryQuestionState(questionType) == null
                          ? Colors.white
                          : model.primaryQuestionState(questionType)
                              ? Colors.white
                              : Colors.red,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.clear,
                        size: 32,
                        color: model.primaryQuestionState(questionType) == null
                            ? Colors.red
                            : model.primaryQuestionState(questionType)
                                ? Colors.red
                                : Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'No',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              model.primaryQuestionState(questionType) == null
                                  ? Colors.red
                                  : model.primaryQuestionState(questionType)
                                      ? Colors.red
                                      : Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
            if (secondaryQuestionWidget != null &&
                (model.primaryQuestionState(questionType) == true))
              secondaryQuestionWidget,
          ],
        ),
      ),
    );
  }
}
