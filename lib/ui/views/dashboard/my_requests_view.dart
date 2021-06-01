import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/views/choose_request_category.dart';
import 'package:vachankosh/ui/views/dashboard/request_tile.dart';
import 'package:vachankosh/ui/views/help_request_detail_view.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

class MyRequestsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: locator<MedicineRequestService>()
            .getMyRequestsStream(locator<User>().phoneNumber),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFoldingCube(
                color: Colors.blue,
              ),
            );
          } else {
            if (snapshot.data.documents.isEmpty) {
              return Center(
                child: Text(
                  "You have not created any requests yet",
                  style: AppStyles.kBlueGreyText,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemBuilder: (context, index) {
                final request =
                    snapshot.data.documents[index] as DocumentSnapshot;
                return RequestTile(
                  request: MedicineRequest.fromMap(request.data, null),
                  onTap: () => Navigator.pushNamed(
                    context,
                    MedicineRequestDetailView.routeName,
                    arguments: request.documentID,
                  ),
                );
              },
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, ChooseRequestCategoryView.routeName);
        },
        label: Text("Request for help"),
        icon: Icon(Icons.playlist_add),
      ),
    );
  }
}
