import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class HospitalDetailsCard extends StatelessWidget {
  const HospitalDetailsCard({
    Key key,
    @required this.req,
  }) : super(key: key);

  final MedicineRequest req;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Hospital Details:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                FontAwesomeIcons.hospitalSymbol,
                color: Colors.red[900],
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                req.hospitalName,
                style: TextStyle(
                  color: Colors.red[900],
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black54,
                      //fontWeight: FontWeight.bold
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    req.hospitalAddress.addressLine,
                    style: TextStyle(

                        // fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
