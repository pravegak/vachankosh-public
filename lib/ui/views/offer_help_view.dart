import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../../locator.dart';

class OfferHelpView extends StatelessWidget {
  final MedicineRequest helpRequest;
  final _monetaryHelpEditingController = TextEditingController();

  static const routeName = '/offerHelp';

  OfferHelpView({Key key, this.helpRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = locator<User>();
    int left = user.promises['monetary'].currentState['quantityLeft'];
    var noOfAlreadyAssignedVolunteers = helpRequest.assignedVolunteers?.length;
    int cost = int.parse(this.helpRequest.cost);
    String headText;
    int alreadyRaised = 0;
    if (noOfAlreadyAssignedVolunteers == 0) {
      headText = "Total amount required: ${this.helpRequest.cost}\n";
    } else {
      helpRequest.assignedVolunteers.forEach((key, value) {
        alreadyRaised += value['amount'];
      });
      headText =
          "Total amount required was ${this.helpRequest.cost}\n$noOfAlreadyAssignedVolunteers people have already contributed $alreadyRaised\nAmount which is still required: ${cost - alreadyRaised}\n";
    }
    String promiseText =
        "You have ${left.toString()} left in your promises.\nKindly enter amount which you will like to help with.";
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(headText),
            SizedBox(
              height: 10,
            ),
            Text(promiseText),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _monetaryHelpEditingController,
              decoration:
                  InputDecoration(prefixIcon: Icon(FontAwesomeIcons.rupeeSign)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () async {
                int offered = int.parse(_monetaryHelpEditingController.text);
                if (offered > left || offered > (cost - alreadyRaised)) {
                  print("more amount entered");
                  return;
                }
                Dialogs.showAppDialog(
                    context,
                    LoadingDialog(
                      message: 'Please Wait...',
                    ));
                final value = int.tryParse(_monetaryHelpEditingController.text);
                var c = await locator<MedicineRequestService>()
                    .offerMonetaryHelp(locator<User>().phoneNumber, value,
                        helpRequest.documentId);
                if (c is String) {
                  print('Something went wrong');
                } else {
                  user.promises['monetary'].currentState['quantityLeft'] -=
                      value;
                }
                Navigator.pop(context);
              },
              child: Text('Offer help'),
            ),
          ],
        ),
      ),
    );
  }
}
