import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/dialogs/error_dialog.dart';
import 'package:vachankosh/ui/dialogs/loading_dialog.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';
import '../../services/help_request_service.dart';

class OfferHelpSheet extends StatefulWidget {
  OfferHelpSheet({
    Key key,
    @required this.request,
  }) : super(key: key);

  final MedicineRequest request;

  @override
  _OfferHelpSheetState createState() => _OfferHelpSheetState();
}

class _OfferHelpSheetState extends State<OfferHelpSheet> {
  final _monetaryHelpEditingController = TextEditingController();
  int _left;
  int _noOfAlreadyAssignedVolunteers;
  int _requirementCost;
  int _alreadyRaised;
  User _user;
  bool _alreadyAssigned;

  @override
  void initState() {
    super.initState();
    final medicineRequest = widget.request;
    _user = locator<User>();
    _left = _user.remainingPromiseAmount;
    _noOfAlreadyAssignedVolunteers = medicineRequest.assignedVolunteers?.length;
    _requirementCost = int.parse(medicineRequest.cost);
    _alreadyRaised = 0;
    _alreadyAssigned = _noOfAlreadyAssignedVolunteers > 0;

    if (_noOfAlreadyAssignedVolunteers > 0) {
      medicineRequest.assignedVolunteers.forEach((key, value) {
        _alreadyRaised += value['amount'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(16),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.solidMoneyBillAlt,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Monetary Help',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Divider(),
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                  children: [
                    TextSpan(
                        text: _alreadyAssigned
                            ? 'Total Amount required was: '
                            : 'Total Amount Required: '),
                    TextSpan(
                        text: '₹$_requirementCost',
                        style: TextStyle(
                            color: _alreadyAssigned
                                ? Colors.black54
                                : Colors.green,
                            fontWeight: _alreadyAssigned
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 20))
                  ]),
            ),
            if (_noOfAlreadyAssignedVolunteers > 0) ...[
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                    children: [
                      TextSpan(
                          text: '₹$_alreadyRaised ',
                          style: TextStyle(color: Colors.green, fontSize: 20)),
                      TextSpan(
                          text:
                              'has already been raised thanks to the contribution of '),
                      TextSpan(
                          text: '$_noOfAlreadyAssignedVolunteers ',
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 20)),
                      TextSpan(text: 'volunteer(s)'),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
            ],
            SizedBox(
              height: 10,
            ),
            Divider(),
            RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'You can offer help worth upto '),
                    TextSpan(
                        style: TextStyle(
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        text: ' ₹${_requirementCost - _alreadyRaised}')
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                autofocus: true,
                controller: _monetaryHelpEditingController,
                decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(FontAwesomeIcons.rupeeSign)),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text('Note: You have ₹$_left left in your promises'),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton.extended(
                  label: Text('Offer Help'),
                  icon: Icon(
                    FontAwesomeIcons.handsHelping,
                  ),
                  onPressed: () async {
                    int offered =
                        int.parse(_monetaryHelpEditingController.text);
                    if (offered > _left) {
                      Dialogs.showAppDialog(
                          context,
                          ErrorDialog(
                            errorDescription:
                                "You offered amount more than what you have left in your promises.",
                          ));
                      return;
                    } else if (offered > (_requirementCost - _alreadyRaised)) {
                      Dialogs.showAppDialog(
                          context,
                          ErrorDialog(
                            errorDescription:
                                "You offered amount more than what is required.",
                          ));
                      return;
                    }
                    Dialogs.showAppDialog(
                        context,
                        LoadingDialog(
                          message: 'Please Wait...',
                        ));
                    final value =
                        int.tryParse(_monetaryHelpEditingController.text);
                    var c = await locator<MedicineRequestService>()
                        .offerMonetaryHelp(locator<User>().phoneNumber, value,
                            widget.request.documentId);
                    if (c is String) {
                      print('Something went wrong');
                    } else {
                      _user.promises['monetary'].currentState['quantityLeft'] -=
                          value;
                    }
                    // pop the loading dialog
                    Navigator.pop(context);
                    // pop the help sheet
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
