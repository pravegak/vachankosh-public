import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/error_dialog.dart';
import 'package:vachankosh/ui/shared/divider_without_padding.dart';
import 'package:vachankosh/ui/views/volunteer_quiz/question_widget.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';

import '../../../enums.dart';

final bloodDonationCardController = ExpandableController(initialExpanded: true);
final onGroundVolunteerCardController = ExpandableController();
final monetaryPromiseCardController = ExpandableController();
final otherPromisesCardController = ExpandableController();

class VolunteerQuizCard extends StatelessWidget {
  final String heading;
  final ExpandableController cardController, nextCardController;
  final QuestionWidget questionWidget;
  final Function onNext;

  VolunteerQuizCard(
      {Key key,
      @required this.heading,
      @required this.cardController,
      this.onNext,
      this.nextCardController,
      @required this.questionWidget})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var disabled = true;
    final model = Provider.of<VolunteerQuizModel>(context);
    final bloodDonationIncomplete = (model.isBloodDonor == null) ||
        (model.isBloodDonor == true && model.bloodGroup == null);
    final onGvIncomplete = model.isGroundVolunteer == null;
    final monetaryPromiseIncomplete = (model.madeMonetaryPromise == null) ||
        (model.madeMonetaryPromise == true &&
            (model.monetaryAmount == null ||
                model.monetaryAmount.isEmpty ||
                model.monetaryPromisePlan == null));
    final otherPromiseIncomplete = (model.madeOtherPromise == null) ||
        (model.madeOtherPromise == true && model.otherPromises.isEmpty);
    switch (questionWidget.questionType) {
      case VolunteerQuestion.BloodDonor:
        disabled = bloodDonationIncomplete;
        break;
      case VolunteerQuestion.GroundVolunteer:
        disabled = onGvIncomplete;
        break;
      case VolunteerQuestion.MonetaryPromise:
        disabled = monetaryPromiseIncomplete;
        break;
      case VolunteerQuestion.OtherPromise:
        disabled = otherPromiseIncomplete;
    }
    return ExpandableNotifier(
      controller: cardController,
      child: ScrollOnExpand(
        child: Card(
          elevation: 2.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expandable(
                  collapsed: InkWell(
                    onTap: () {
                      cardController.toggle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading,
                          style: AppStyles.k20BlueHeading,
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            cardController.toggle();
                          },
                        )
                      ],
                    ),
                  ),
                  expanded: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          cardController.toggle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              heading,
                              style: AppStyles.k20BlueHeading,
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.chevronUp,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                cardController.toggle();
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                        color: AppColors.primaryColor,
                      ),
                      questionWidget,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            disabledColor: Colors.grey[400],
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              this.heading == 'Other Promises'
                                  ? 'Submit'
                                  : 'Next',
                            ),
                            onPressed: disabled
                                ? null
                                : onNext == null
                                    ? () {
                                        cardController.toggle();
                                        nextCardController.toggle();
                                      }
                                    : () {
                                        //Validate if previous cards are filled
                                        if (bloodDonationIncomplete == true) {
                                          Dialogs.showAppDialog(
                                              context,
                                              ErrorDialog(
                                                errorDescription:
                                                    'Please complete blood donation card',
                                              ));
                                          return;
                                        }
                                        if (onGvIncomplete == true) {
                                          Dialogs.showAppDialog(
                                              context,
                                              ErrorDialog(
                                                errorDescription:
                                                    'Please complete ground volunteering card',
                                              ));
                                          return;
                                        }
                                        if (monetaryPromiseIncomplete == true) {
                                          Dialogs.showAppDialog(
                                              context,
                                              ErrorDialog(
                                                errorDescription:
                                                    'Please complete monetary promise card',
                                              ));
                                          return;
                                        }
                                        onNext();
                                      },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
