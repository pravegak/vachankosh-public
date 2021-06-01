import 'package:flutter/material.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/admin_service.dart';

class StatsView extends StatelessWidget {
  static const routeName = '/stats';
  final _adminService = locator<AdminService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: StreamBuilder(
        stream: _adminService.getUsersFirestoreStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final volunteers = _adminService.filterVolunteers(snapshot.data);
            final onGroundVolunteers =
                _adminService.filterGroundVolunteers(snapshot.data);
            final bloodDonors = _adminService.filterBloodDonors(snapshot.data);
            final totalMonetaryPromiseAmount =
                _adminService.totalMonetaryPromiseAmountMonthly(snapshot.data);
            final bloodGroupStatsMap =
                _adminService.getBloodGroupStats(bloodDonors);
            return Container(
              child: Column(
                children: [
                  Text("Total Register Users: " +
                      snapshot.data.length.toString()),
                  Text('Total Volunteers: ' + volunteers.length.toString()),
                  Text('Total On-Ground Volunteers: ' +
                      onGroundVolunteers.length.toString()),
                  Text('Total Blood Donors: ' + bloodDonors.length.toString()),
                  Text(bloodGroupStatsMap.toString()),
                  Text('Total Monetary Promise Amount (per month): ' +
                      totalMonetaryPromiseAmount.toStringAsFixed(2)),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
