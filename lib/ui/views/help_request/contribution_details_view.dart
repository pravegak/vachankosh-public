import 'package:flutter/material.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class ContributionDetailsCard extends StatelessWidget {
  const ContributionDetailsCard({
    Key key,
    @required this.helpRequest,
  }) : super(key: key);

  final MedicineRequest helpRequest;

  @override
  Widget build(BuildContext context) {
    Map contribution = helpRequest.assignedVolunteers;
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
                  'Contribution Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            contribution.isEmpty
                ? Text("No help offered yet")
                : Column(
                    children: contribution.keys.map((userPhone) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userPhone),
                          Text(contribution[userPhone]['amount'].toString()),
                        ],
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
