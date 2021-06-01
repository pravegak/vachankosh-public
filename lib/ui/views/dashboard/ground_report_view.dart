import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vachankosh/services/help_request_service.dart';

import '../../../locator.dart';
import 'request_tile.dart';

class GroundReportView extends StatelessWidget {
  static const routeName = '/groundReport';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Helps"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Expanded(
              child: FutureBuilder(
                  future: locator<MedicineRequestService>()
                      .getRequestsVerfiedByMe(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: SpinKitFoldingCube(
                        color: Colors.blue,
                      ));
                    }
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Text("You have not verfied any requests yet!"),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, pos) {
                        return RequestTile(
                          request: snapshot.data[pos],
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
