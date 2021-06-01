import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/utils/objects/user.dart';

class AdminService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');
  Stream<List<User>> getUsersFirestoreStream() {
    return _usersCollectionReference.snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.documents
            .map((DocumentSnapshot documentSnapshot) =>
                User.fromMap(documentSnapshot.data))
            .toList());
  }

  List<User> filterVolunteers(List<User> allUsers) {
    return allUsers.where((user) => user.volunteer == true).toList();
  }

  List<User> filterGroundVolunteers(List<User> allUsers) {
    return allUsers.where((user) => user.onGroundVolunteer == true).toList();
  }

  List<User> filterBloodDonors(List<User> allUsers) {
    return allUsers.where((user) => user.bloodGroup != null).toList();
  }

  Map<String, int> getBloodGroupStats(List<User> bloodDonors) {
    Map<String, int> bloodGroupStatsMap = {
      'A+': 0,
      'A-': 0,
      'B+': 0,
      'B-': 0,
      'AB+': 0,
      'AB-': 0,
      'O+': 0,
      'O-': 0
    };
    bloodDonors.forEach((User bloodDonor) {
      switch (bloodDonor.bloodGroup) {
        case 'A+':
          bloodGroupStatsMap['A+'] += 1;

          break;
        case 'A-':
          bloodGroupStatsMap['A-'] += 1;

          break;
        case 'B+':
          bloodGroupStatsMap['B+'] += 1;

          break;
        case 'B-':
          bloodGroupStatsMap['B-'] += 1;

          break;
        case 'AB+':
          bloodGroupStatsMap['AB+'] += 1;

          break;
        case 'AB-':
          bloodGroupStatsMap['AB-'] += 1;

          break;
        case 'O+':
          bloodGroupStatsMap['O+'] += 1;

          break;
        case 'O-':
          bloodGroupStatsMap['O-'] += 1;

          break;
        default:
      }
    });
    return bloodGroupStatsMap;
  }

  num totalMonetaryPromiseAmountMonthly(List<User> allUsers) {
    num totalAmount = 0;
    allUsers.forEach((User user) {
      if (user.promises != null) {
        if (user.promises['monetary'] != null) {
          if (user.promises['monetary'].time == 'Yearly')
            totalAmount += (user.promises['monetary'].quantity / 12);
          else if (user.promises['monetary'].time == 'Quarterly')
            totalAmount += (user.promises['monetary'].quantity / 4);
          else
            totalAmount += user.promises['monetary'].quantity;
        }
      }
    });
    return totalAmount;
  }
}
