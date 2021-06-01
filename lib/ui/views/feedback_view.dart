import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/app_issue.dart';
import 'package:vachankosh/utils/objects/user.dart';

class FeedbackView extends StatefulWidget {
  static const routeName = '/feedback';
  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  GlobalKey<FormState> formKey = GlobalKey();
  String _option = "Choose an option";
  final _titleEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = locator<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text('App Feedback'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Text(
                "Thank you for stepping up to contribute and using VachanKosh. If you have found any issues or any suggestions, definitely go ahead and share. We will try our best to fix or get them implemented as soon as possible",
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: AppColors.primaryColor),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title cannot be empty";
                  }
                  return null;
                },
                controller: _titleEditingController,
                decoration: InputDecoration(
                  labelText: "Title",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kindly describe your issue";
                  }
                  return null;
                },
                controller: _descriptionEditingController,
                maxLength: 500,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: "Description",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  border: OutlineInputBorder(),
                  // contentPadding:
                  //     EdgeInsets.symmetric(vertical: 40, horizontal: 10)
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                value: _option,
                validator: (String value) {
                  if (value == 'Choose an option') {
                    return 'Please choose a state';
                  }
                  return null;
                },
                items: ["Choose an option", "Bug", "Feature", "Other"]
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (String value) {
                  setState(() {
                    _option = value;
                  });
                },
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                child: Text(
                  'Report issue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () async {
                  if (!formKey.currentState.validate()) {
                    return;
                  }
                  final issue = AppIssue()
                    ..phoneNumber = user.phoneNumber
                    ..desc =
                        "${_titleEditingController.text}\n${_descriptionEditingController.text}"
                    ..issueType = _option;
                  await addAppIssue(issue);
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
