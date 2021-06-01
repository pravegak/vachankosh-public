import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/dialogs/Confirmation_dialog.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/views/help_request/hospital_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/patient_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/poc_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/req_details_widget.dart';

import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';

class VerifyRequestView extends StatelessWidget {
  final MedicineRequest helpRequest;

  static const routeName = '/verifyRequest';

  const VerifyRequestView({Key key, this.helpRequest}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Request #123') ,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            children: <Widget>[
              PatientDetailsCard(req: helpRequest),
              SizedBox(
                height: 8,
              ),
              HospitalDetailsCard(req: helpRequest),
              SizedBox(
                height: 8,
              ),
              RequireDetailsCard(helpRequest: helpRequest),
              SizedBox(
                height: 8,
              ),
              PointOfContactDetails(helpRequest: helpRequest),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(top: BorderSide(color: Colors.grey[100]))),
              child: Center(
                child: FloatingActionButton.extended(
                    icon: Icon(Icons.check),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Dialogs.showAppDialog(
                        context,
                        ConfirmationDialog(
                          onTap: () async {
                            await locator<MedicineRequestService>()
                                .verifyRequest(
                              helpRequest,
                            );
                            Navigator.pop(context);
                          },
                          message: 'Do you want to verify this request',
                          title: 'Verification Confirmation',
                        ),
                      );
                    },
                    label: Text('Verify')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
