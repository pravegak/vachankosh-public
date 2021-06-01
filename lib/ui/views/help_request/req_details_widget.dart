import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/ui/views/prescription_images_view.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class RequireDetailsCard extends StatelessWidget {
  const RequireDetailsCard({
    Key key,
    @required this.helpRequest,
  }) : super(key: key);

  final MedicineRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    int raised = 0;
    for (Map e in helpRequest.assignedVolunteers.values) {
      raised += e['amount'];
    }
    int left = int.parse(helpRequest.cost) - raised;
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Disease and Requirements:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Text(helpRequest.illness,
                    style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Requirements',
                  style: TextStyle(color: Colors.black45),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(helpRequest.requirement),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                    textColor: Colors.white,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, PrescriptionImagesView.routeName,
                          arguments: helpRequest.prescriptionImages);
                    },
                    icon: Icon(FontAwesomeIcons.stethoscope),
                    label: Text('Prescription Images'))
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total Cost',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('₹${helpRequest.cost}',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Raised',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('₹$raised',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Still Required',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text('₹$left',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
