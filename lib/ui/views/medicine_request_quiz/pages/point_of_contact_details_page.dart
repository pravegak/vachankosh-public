import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/widgets/input_box.dart';
import 'package:vachankosh/ui/views/dashboard/userhome.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';

class PointOfContactDetailsPage extends StatelessWidget {
  const PointOfContactDetailsPage({
    Key key,
    @required this.formkey,
    this.pageController,
  }) : super(key: key);

  final GlobalKey<FormState> formkey;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateIssueModel>(context);
    model.editingControllers[10].text = locator<User>().phoneNumber;
    return WillPopScope(
      onWillPop: () {
        //model.setPageTitle('Request Details');
        pageController.previousPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);

        return Future.value(false);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    InputBox(
                      validator: (String value) {
                        if (value.length < 3) {
                          return 'Name is required cannot be less than 3 characters';
                        }
                        return null;
                      },
                      controller: model.editingControllers[9],
                      hintText: 'Name',
                      icon: Icon(Icons.person),
                    ),
                    InputBox(
                      enabled: false,
                      // ignore: non_constant_identifier_names
                      validator: (String) {},
                      controller: model.editingControllers[10],
                      hintText: 'Contact number',
                      icon: Icon(Icons.phone),
                      keyboard: TextInputType.phone,
                    ),
                    InputBox(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Relation with patient is required';
                        }
                        return null;
                      },
                      controller: model.editingControllers[11],
                      hintText: 'Relation with the patient',
                      icon: Icon(Icons.group),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () async {
                            if (formkey.currentState.validate()) {
                              print("CReating issue");
                              await model
                                  .createAndUploadMedicineRequest(context);
                              print("uploading user");
                              await model.uploadThisUser(context);
                              Navigator.pushNamedAndRemoveUntil(context,
                                  UserHomeView.routeName, (route) => false);
                            } else {
                              model.setFormAutoValidate(true);
                            }
                          },
                          label: Text('Submit Request'),
                          icon: Icon(
                            FontAwesomeIcons.check,
                            size: 16,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
