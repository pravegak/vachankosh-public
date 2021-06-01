import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/services/push_notification_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/ui/views/dashboard/userhome.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/promise.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/utils/shared_preferences.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';
import 'package:vachankosh/enums.dart';
import 'volunteer_quiz_card.dart';
import 'question_widget.dart';
import 'donate_blood_ques_widget.dart';
import 'monetary_promise_ques_widget.dart';
import 'other_promise_ques_widget.dart';

class VolunteerQuizView extends StatelessWidget {
  static const routeName = "/volunteerQuiz";
  final addressPrediction;
  final questionWidgetList = [
    QuestionWidget(
      questionType: VolunteerQuestion.BloodDonor,
      primaryQuestion: "Will you like to donate blood?",
      questionDesc:
          "India faces shortage of ~2 million units of blood each year. Donate blood and save lives.",
      secondaryQuestionWidget: DonateBloodQuesWidget(),
    ),
    QuestionWidget(
      questionType: VolunteerQuestion.GroundVolunteer,
      primaryQuestion: "Will you like to serve as a ground volunteer?",
      questionDesc:
          "Ground volunteers will help us in verifying requests, helping on ground whenever there comes any need in their city.",
    ),
    QuestionWidget(
      questionType: VolunteerQuestion.MonetaryPromise,
      primaryQuestion: "Will you like to make a monetary promise?",
      questionDesc:
          "A promise that you will help with this amount for medicine requirements of needy people.",
      secondaryQuestionWidget: MonetaryPromiseQuesWidget(),
    ),
    QuestionWidget(
      questionType: VolunteerQuestion.OtherPromise,
      primaryQuestion: "Will you like to make any other promises?",
      questionDesc:
          "Apart from money, something which you can promise. Dubious whether something you can promise will help or not? Go ahead and make that promise.",
      secondaryQuestionWidget: OtherPromiseQuesWidget(),
    )
  ];

  VolunteerQuizView({Key key, this.addressPrediction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var user = locator<User>();
    return ChangeNotifierProvider<VolunteerQuizModel>(
      create: (context) => locator<VolunteerQuizModel>(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Helping Info"),
          centerTitle: true,
        ),
        body: Consumer<VolunteerQuizModel>(
          builder: (context, model, child) => ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              VolunteerQuizCard(
                heading: 'Blood Donation',
                cardController: bloodDonationCardController,
                nextCardController: onGroundVolunteerCardController,
                questionWidget: questionWidgetList[0],
              ),
              VolunteerQuizCard(
                heading: 'Ground Volunteering',
                cardController: onGroundVolunteerCardController,
                nextCardController: monetaryPromiseCardController,
                questionWidget: questionWidgetList[1],
              ),
              VolunteerQuizCard(
                heading: 'Monetary Promise',
                cardController: monetaryPromiseCardController,
                nextCardController: otherPromisesCardController,
                questionWidget: questionWidgetList[2],
              ),
              VolunteerQuizCard(
                heading: 'Other Promises',
                cardController: otherPromisesCardController,
                onNext: () async {
                  Dialogs.showAppDialog(
                      context,
                      LoadingDialog(
                        message: 'Registering details',
                      ));
                  //Update Address
                  Address addressDetails =
                      await locator<LocationSearchService>()
                          .getLocationDetails(addressPrediction);
                  user.addressModel = AddressModel(
                    coordinates: GeoPoint(addressDetails.coordinates.latitude,
                        addressDetails.coordinates.longitude),
                    addressLine: addressDetails.addressLine,
                    countryName: addressDetails.countryName,
                    countryCode: addressDetails.countryCode,
                    featureName: addressDetails.featureName,
                    postalCode: addressDetails.postalCode,
                    locality: addressDetails.locality,
                    subLocality: addressDetails.subLocality,
                    adminArea: addressDetails.adminArea,
                    subAdminArea: addressDetails.subAdminArea,
                    thoroughfare: addressDetails.thoroughfare,
                    subThoroughfare: addressDetails.subThoroughfare,
                  );
                  await uploadUser(user, model);

                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, UserHomeView.routeName, (route) => false);
                },
                questionWidget: questionWidgetList[3],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadUser(User user, VolunteerQuizModel model) async {
    if (model.isBloodDonor) {
      user.bloodGroup = model.bloodGroup;
    }
    user.onGroundVolunteer = model.isGroundVolunteer;
    Map<String, Promise> promises = {};
    if (model.madeMonetaryPromise) {
      promises['monetary'] = Promise(null, int.parse(model.monetaryAmount),
          model.monetaryPromisePlan, null);
    }
    if (model.otherPromises.isNotEmpty) {
      model.otherPromises.forEach((element) {
        promises[element.object] = element;
      });
    }
    user.promises = promises;
    user.volunteer = true;
    print("User map: ${user.toMap()}");
    //send data to firestore
    // set update as true because this might be a non-volunteer
    // registering to be a volunteer
    await addUser(user, update: true);

    //Add Device Id to firestore
    await locator<PushNotificationService>().storeDeviceTokenToServer();

    print("User successfully added");
    // store in shared that this user has successfully completed
    // the whole registration and they should be redirected to
    // dashboard next time
    await storeBoolInShared(user.phoneNumber + '-completed', true);
  }
}
