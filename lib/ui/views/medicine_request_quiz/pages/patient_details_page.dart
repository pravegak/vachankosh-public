import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/ui/dialogs/Confirmation_dialog.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/widgets/input_box.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';

class PatientDetailsPage extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final PageController pageController;

  const PatientDetailsPage({Key key, this.formkey, this.pageController})
      : super(key: key);

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  bool otherIdType = false;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateIssueModel>(context);
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (context) => ConfirmationDialog(
            title: "Alert",
            message:
                "All filled details will be lost. Do you want to continue?",
          ),
        );
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
                      controller: model.editingControllers[0],
                      hintText: 'Name',
                      validator: (String value) {
                        if (model.editingControllers[0].text.length < 3)
                          return "Name is required and cannot be less that 3 characters";
                        return null;
                      },
                      icon: Icon(Icons.person),
                    ),
                    Stack(
                      children: <Widget>[
                        InputBox(
                          readOnly: true,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Choose your Date of Birth';
                            }
                            return null;
                          },
                          controller:
                              TextEditingController(text: model.dateOfBirth),
                          hintText: 'Date of Birth',
                          icon: Icon(Icons.date_range),
                        ),
                        GestureDetector(
                            onTap: () async {
                              DateTime dob = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now());
                              if (dob != null) {
                                model.setDateOfBirth(
                                    "${dob.day}-${dob.month}-${dob.year}");
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              height: 50,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.idCardAlt,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  value: model.patientIdProofType,
                                  validator: (String value) {
                                    if (value == 'ID Proof Type') {
                                      return 'Please choose an ID proof type';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  items: [
                                    'ID Proof Type',
                                    'Aadhar Card',
                                    'Driving License',
                                    'Pan Card',
                                    'Other'
                                  ]
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (String value) {
                                    otherIdType = false;
                                    model.setPatientIdProofType(null);
                                    if (value == 'Other') {
                                      setState(() {
                                        otherIdType = true;
                                      });
                                    }
                                    model.setPatientIdProofType(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                    if (otherIdType)
                      InputBox(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'This field cannot be empty';
                          }
                          return null;
                        },
                        controller: model.editingControllers[2],
                        hintText: 'Other ID Proof Type',
                        icon: Icon(Icons.keyboard),
                      ),
                    InputBox(
                      validator: (String value) {
                        final c = int.tryParse(value);
                        if (c == null) {
                          return 'Enter a valid ID proof number';
                        }
                        return null;
                      },
                      controller: model.editingControllers[1],
                      keyboard: TextInputType.number,
                      hintText: 'Id Proof Number',
                      icon: Icon(FontAwesomeIcons.idCard),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.place,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              value: model.patientState,
                              validator: (String value) {
                                if (value == 'State') {
                                  return 'Please choose a state';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                // border: UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.grey),
                                //   borderRadius: BorderRadius.circular(0.0),
                                //  ),
                                border: InputBorder.none,
                              ),
                              items: ['State', ...AppData.statesAndUtList]
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (String value) {
                                model.setPatientState(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    InputBox(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'City field cannot be empty';
                        }
                        return null;
                      },
                      controller: model.editingControllers[3],
                      hintText: 'City',
                      icon: Icon(Icons.location_city),
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
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              if (widget.formkey.currentState.validate()) {
                                model.setFormAutoValidate(false);
                                widget.pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                                //model.setPageTitle('Hospital Details');
                              } else {
                                model.setFormAutoValidate(true);
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 16,
                            ),
                            label: Text('Next'))
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
