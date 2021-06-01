import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_constants.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/user_profile_model.dart';

class SelectBloodGroupSheet extends StatefulWidget {
  SelectBloodGroupSheet({Key key, this.model}) : super(key: key);

  final UserProfileModel model;

  @override
  _SelectBloodGroupSheetState createState() => _SelectBloodGroupSheetState();
}

class _SelectBloodGroupSheetState extends State<SelectBloodGroupSheet> {
  final user = locator<User>();
  String _selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    if (user.bloodGroup != null) {
      _selectedBloodGroup = user.bloodGroup;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> bloodGroups = [
      'O+',
      'O-',
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-'
    ];
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose your Blood Group',
              style: AppStyles.k16BlackHeading,
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: bloodGroups
                  .map(
                    (e) => RadioListTile(
                        title: Text(e),
                        value: e,
                        groupValue: _selectedBloodGroup,
                        onChanged: (value) {
                          setState(() {
                            _selectedBloodGroup = value;
                          });
                        }),
                  )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    widget.model.changeProfileField(
                        AppConstants.kFirestoreUserBloodGroupField,
                        _selectedBloodGroup);
                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  color: Colors.blue,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}