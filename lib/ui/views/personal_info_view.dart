import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/constants/app_credentials.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/ui/dialogs/Confirmation_dialog.dart';
import 'package:vachankosh/ui/views/volunteer_quiz/volunteer_quiz_view.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:google_maps_webservice/src/places.dart';

class PersonalInfoView extends StatefulWidget {
  static const routeName = "/personalInfo";

  @override
  _PersonalInfoViewState createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  Prediction _addressPrediction;
  final TextEditingController phoneEditingController = TextEditingController();

  final TextEditingController nameEditingController = TextEditingController();

  final TextEditingController altPhoneEditingController =
      TextEditingController();

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController twitterHandleController = TextEditingController();

  final TextEditingController cityEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User user = locator<User>();
    phoneEditingController.text = user.phoneNumber;
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
                  title: "Alert",
                  message:
                      "All filled details will be lost. Do you want to continue?",
                ));
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                        title: "Alert",
                        message:
                            "All filled details will be lost. Do you want to continue?",
                        onTap: () => Navigator.pop(context),
                      ));
            },
          ),
          elevation: 0.0,
          title: Text("Personal Info"),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              TextFormField(
                  validator: (String text) {
                    if (text.length == 0) {
                      return "Name cannot be empty";
                    } else if (text.length < 3) {
                      return "Name length atleast be 3 characters long";
                    }
                    return null;
                  },
                  controller: nameEditingController,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black54,
                      ),
                      labelText: "Name*",
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.black54, fontStyle: FontStyle.italic))),
              Divider(),
              TextFormField(
                  controller: phoneEditingController,
                  enabled: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.phoneAlt,
                        color: Colors.black54,
                      ),
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ))),
              Divider(),
              TextFormField(
                  validator: (String value) {
                    if (value.isNotEmpty && value.length < 10) {
                      return "Enter a 10-digit mobile number";
                    }
                    return null;
                  },
                  controller: altPhoneEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.mobileAlt,
                        color: Colors.black54,
                      ),
                      prefixText: '+91 ',
                      labelText: "Alternate Phone Number",
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ))),
              Divider(),
              TextFormField(
                  validator: (String value) {
                    if (value.isEmpty ||
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return null;
                    }
                    return "Enter a valid email";
                  },
                  controller: emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.black54,
                      ),
                      labelText: "Email",
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.black54, fontStyle: FontStyle.italic))),
              Divider(),
              TextFormField(
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !value.startsWith('@')) {
                      return "Twitter username must starts with @";
                    }
                    return null;
                  },
                  controller: twitterHandleController,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.black54,
                      ),
                      labelText: "Twitter Username",
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ))),
              Divider(),
              TextFormField(
                  onTap: () async {
                    _addressPrediction = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: AppCredentials.MAPS_API_KEY,
                      language: 'en',
                    );
                    if (_addressPrediction == null) {
                      // The user clicked address and back, so p is null
                      return;
                    }
                    cityEditingController.text = _addressPrediction.description;
                  },
                  readOnly: true,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please enter your address";
                    }
                    return null;
                  },
                  controller: cityEditingController,
                  maxLines: null,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.mapMarkedAlt,
                        color: Colors.black54,
                      ),
                      labelText: "Address*",
                      
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ))),
              Divider(),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        user
                          ..name = nameEditingController.text
                          ..alternatePhoneNumber =
                              altPhoneEditingController.text
                          ..email = emailEditingController.text
                          ..twitterHandle = twitterHandleController.text;

                        Navigator.of(context).pushNamed(
                            VolunteerQuizView.routeName,
                            arguments: _addressPrediction);
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                    child: Text("Next"),
                    textColor: Colors.white,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
