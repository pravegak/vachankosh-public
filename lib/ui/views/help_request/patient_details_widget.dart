import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/helper_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

class PatientDetailsCard extends StatelessWidget {
  const PatientDetailsCard({
    Key key,
    @required this.req,
  }) : super(key: key);

  final MedicineRequest req;

  @override
  Widget build(BuildContext context) {
    final dob = req.patientDOB.split('-');
    final patientAge = calculateAge(
        birthDay: int.parse(dob[0]),
        birthMonth: int.parse(dob[1]),
        birthYear: int.parse(dob[2]));
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Patient Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              FontAwesomeIcons.userAlt,
              color: Colors.blue[900],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              req.patientName,
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 16,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Age',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text('$patientAge years'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Disease',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(req.illness),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'State',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(req.patientState),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'City',
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(req.patientCity),
                  ],
                ),
              ],
            ),
            if (req.status == RequestStatus.UNDER_VERIFICATION &&
                req.verifiedByVolunteer == locator<User>().phoneNumber) ...[
              Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(req.idProofType,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(req.idProofNumber,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
