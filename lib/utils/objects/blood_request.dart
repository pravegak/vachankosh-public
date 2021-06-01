import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/utils/objects/address.dart';

class BloodRequest {
  int requestId;

  Map<String, Timestamp> timestamps = {};

  String documentId;

  String patientName;
  String patientDOB;

  String hospitalName;
  AddressModel hospitalAddress;

  String bloodGroup;
  int units;
  bool exchangePossible;
  bool platlets;
  String dateOfRequirement;
  bool familyMemberDonated;

  List<String> prescriptionSlip;
  String illness;
  

  String pocName;
  String pocNumber;
  String pocAlternateNumber;
  String pocRelation;
}
