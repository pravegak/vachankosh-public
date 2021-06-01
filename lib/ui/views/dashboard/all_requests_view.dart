import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/ui/views/choose_request_category.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/views/dashboard/request_tile.dart';
import 'package:vachankosh/ui/views/help_request_detail_view.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

class AllRequestsView extends StatefulWidget {
  // List<DocumentSnapshot> getRelevantRequests(QuerySnapshot snapshot) {
  //   final user = locator<User>();
  //   bool showNew = user.onGroundVolunteer;
  //   bool showVerified = user.promises.containsKey('monetary')
  //       ? user.promises['monetary'].currentState['quantityLeft'] != 0
  //       : false;
  //   List<DocumentSnapshot> relevantRequest = [];
  //   snapshot.documents.forEach((element) {
  //     if (element.data['pocNumber'] == user.phoneNumber) {
  //       return;
  //     }
  //     if (element.data['status'] == RequestStatus.NEW) {
  //       if (showNew) {
  //         // TODO: do location based filtering here
  //         relevantRequest.add(element);
  //       }
  //     } else if (element.data['status'] == RequestStatus.UNDER_VERIFICATION) {
  //       if (element.data['verifiedByVolunteer'] == user.phoneNumber) {
  //         relevantRequest.add(element);
  //       }
  //     } else if (element.data['status'] == RequestStatus.VERIFIED) {
  //       if (showVerified) {
  //         relevantRequest.add(element);
  //       }
  //     }
  //   });
  //   return relevantRequest;
  // }

//Temporary method to get all requests excluding mine
  @override
  _AllRequestsViewState createState() => _AllRequestsViewState();
}

class _AllRequestsViewState extends State<AllRequestsView> {
  bool _showMyRequests = false;
  List<DocumentSnapshot> getRelevantRequests(QuerySnapshot snapshot) {
    final user = locator<User>();
    List<DocumentSnapshot> relevantRequest = [];
    snapshot.documents.forEach((element) {
      if (element.data['pocNumber'] == user.phoneNumber) {
        return;
      }
      relevantRequest.add(element);
    });
    return relevantRequest;
  }

  @override
  void initState() {
    super.initState();
    locator<MedicineRequestService>()
        .getMyRequests(locator<User>().phoneNumber)
        .then((value) {
      setState(() {
        _showMyRequests = value.documents.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showMyRequests
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(
                    context, ChooseRequestCategoryView.routeName);
              },
              label: Text("Request for help"),
              icon: Icon(Icons.playlist_add),
            ),
      appBar: AppBar(
        title: Text("Requests Feed"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: locator<MedicineRequestService>().getAllRequestsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFoldingCube(
                color: Colors.blue,
              ),
            );
          } else {
            //Exclude my requests
            final relevantRequests = getRelevantRequests(snapshot.data);
            return (relevantRequests.isEmpty)
                ? Center(
                    child: Text(
                      'No requests to show at the moment',
                      style: AppStyles.kBlueGreyText,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemBuilder: (context, index) {
                      final request = relevantRequests[index];
                      return RequestTile(
                          request: MedicineRequest.fromMap(request.data, null),
                          onTap: () => Navigator.pushNamed(
                                context,
                                MedicineRequestDetailView.routeName,
                                arguments: request.documentID,
                              ));
                    },
                    itemCount: relevantRequests.length,
                  );
          }
        },
      ),
    );
  }
}
