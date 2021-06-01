import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/dialogs/Confirmation_dialog.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/views/help_request/contribution_details_view.dart';
import 'package:vachankosh/ui/views/help_request/hospital_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/req_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/request_header_widget.dart';
import 'package:vachankosh/ui/views/offer_help_sheet.dart';
import 'package:vachankosh/ui/views/help_request/patient_details_widget.dart';
import 'package:vachankosh/ui/views/help_request/poc_details_widget.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

class MedicineRequestDetailView extends StatelessWidget {
  static const routeName = '/helprequestview';
  final String requestId;

  const MedicineRequestDetailView({Key key, this.requestId}) : super(key: key);

  Widget buildFAB(BuildContext context, MedicineRequest req) {
    User loggedinUser = locator<User>();
    if (req.pocNumber == loggedinUser.phoneNumber) {
      return null;
    }
    if (req.status == RequestStatus.NEW) {
      return FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          onPressed: () {
            Dialogs.showAppDialog(
              context,
              ConfirmationDialog(
                onTap: () {
                  locator<MedicineRequestService>().assignRequestVerification(
                      req, locator<User>().phoneNumber);
                },
                message:
                    'You will be shown additional details about the request which are crucial for verification. Assign verification to yourself?',
                title: 'Request verification',
              ),
            );
          },
          icon: Icon(Icons.more_horiz),
          label: Text('Initiate Verification'));
    } else if (req.status == RequestStatus.UNDER_VERIFICATION) {
      if (req.verifiedByVolunteer != loggedinUser.phoneNumber) {
        return null;
      }
      return FloatingActionButton.extended(
          icon: Icon(Icons.check),
          backgroundColor: Colors.green,
          onPressed: () {
            Dialogs.showAppDialog(
              context,
              ConfirmationDialog(
                onTap: () async {
                  await locator<MedicineRequestService>().verifyRequest(
                    req,
                  );
                  Navigator.pop(context);
                },
                message: 'Do you want to verify this request',
                title: 'Verification Confirmation',
              ),
            );
          },
          label: Text('Verify'));
    } else if (req.status == RequestStatus.VERIFIED ||
        req.status == RequestStatus.IN_PROGRESS ||
        req.status == RequestStatus.COMPLETED) {
      if (!loggedinUser.promises.containsKey('monetary')) {
        // If user does not have any monetary promise,
        // let's not show them bottom sheet for help
        return null;
      }

      if (req.assignedVolunteers != null &&
          req.assignedVolunteers.containsKey(loggedinUser.phoneNumber)) {
        var contributedAmount =
            req.assignedVolunteers[loggedinUser.phoneNumber]['amount'];
        return FloatingActionButton.extended(
            backgroundColor: Colors.lightBlue,
            onPressed: () {},
            label: Text(
                "Thank you! You already contributed ${contributedAmount.toString()} rupees"));
      }
      if (req.status == RequestStatus.COMPLETED) {
        return null;
      }
      return FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              context: context,
              builder: (context) => OfferHelpSheet(
                    request: req,
                  ));
        },
        label: Text('Offer Help'),
        icon: Icon(FontAwesomeIcons.handsHelping),
      );
    }
    return null;
  }

  // whether to show request details of this request?
  bool showRequirementDetails(MedicineRequest request, User user) {
    // Shows the details when:
    //  * A request is verified
    //  * If current user is verifying it or verified it
    //  * A request is in progress
    //  * Current user is the author of request
    //  * Current user has offered help on the request
    if (request.status == RequestStatus.VERIFIED ||
        request.verifiedByVolunteer == user.phoneNumber ||
        request.status == RequestStatus.IN_PROGRESS ||
        request.assignedVolunteers.containsKey(user.phoneNumber) ||
        request.pocNumber == user.phoneNumber) {
      return true;
    }
    return false;
  }

  // whether to show point of contact details of this request?
  bool showPOCDetails(MedicineRequest request, User user) {
    // Shows the details when:
    //  * The current user is verifiying it or verified it
    //  * Current user if the author of request
    //  * Current user has offered help on this request
    if (request.verifiedByVolunteer == user.phoneNumber ||
        request.pocNumber == user.phoneNumber ||
        request.assignedVolunteers.containsKey(user.phoneNumber)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print(requestId);
    return StreamBuilder(
      stream:
          locator<MedicineRequestService>().getRequestSnapshotStream(requestId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: SpinKitFoldingCube(
            color: Colors.blue,
          ));
        }
        /*Create updated request object everytime
               it updates on the firestore*/
        MedicineRequest req =
            MedicineRequest.fromMap(snapshot.data.data, requestId);

        User user = locator<User>();

        return Scaffold(
          resizeToAvoidBottomPadding: true,
          //floatingActionButton: buildFAB(context, req),
          appBar: AppBar(
            title: Text('Request Details'),
          ),
          body: Stack(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  RequestHeader(req: req),
                  PatientDetailsCard(req: req),
                  SizedBox(
                    height: 8,
                  ),
                  HospitalDetailsCard(req: req),
                  SizedBox(
                    height: 8,
                  ),
                  if (showRequirementDetails(req, user)) ...[
                    RequireDetailsCard(helpRequest: req),
                    SizedBox(
                      height: 8,
                    ),
                    if (showPOCDetails(req, user))
                      PointOfContactDetails(
                        helpRequest: req,
                      ),
                  ],
                  if (user.phoneNumber == req.pocNumber)
                    ContributionDetailsCard(helpRequest: req),
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
                    child: buildFAB(context, req),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
