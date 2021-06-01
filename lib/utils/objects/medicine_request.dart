// represents a help request which we got on platform
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/utils/objects/address.dart';

class MedicineRequest {
  // ====== ISSUE METADATA =======
  // unique integer request number for this
  int requestId;
  // timestamps of various events of the request
  // createdAt -> when issue was created
  // verAssignedAt -> when verification of the issue was assigned
  // verifiedAt -> when issue was verified
  // closedAt -> when issue was closed
  Map<String, Timestamp> timestamps = {};
  // document ID of the request in firebase
  String documentId;

  // ====== PATIENT DETAILS ========
  // name of the patient
  String patientName;
  // patient date of birth
  // TODO: is string correct way here?
  String patientDOB;
  // Id proof number
  String idProofNumber;
  // Type of Id proof;
  String idProofType;
  // patient city and state
  String patientCity;
  String patientState;
  // is the person enrolled in some government scheme? If yes, which ones?
  // TODO: this can be done better
  String govtSchemes;

  // ====== HOSPITAL DETAILS =========
  // name of hospital where patient is admitted
  String hospitalName;
  // address of hospital where patient is admitted
  AddressModel hospitalAddress;

  // ====== REQUEST DETAILS =============
  // urls of the prescription images
  List<String> prescriptionImages;
  // Name of illness
  String illness;
  // Details of treatment or medicines required
  String requirement;
  // required cost
  // it's estimated one if the request is not verified
  // final one if the request is verified
  String cost;

  // ====== POINT OF CONTACT DETAILS =======
  // name of point of contact person
  String pocName;
  // phone number of point of contact person
  String pocNumber;
  // relation with the patient
  String pocRelation;

  // ======= REQUEST STATUS DETAILS =========
  // status of the request
  // TODO: we can do better with status
  String status;
  // documentId of volunteer who verified it
  String verifiedByVolunteer;
  // map of documentIds of volunteers who are assigned as keys
  // The value will be a map which contains amount they have contributed,
  // date and time when they contributed and other required metadata
  Map<String, Map> assignedVolunteers = {};

  Map toMap() {
    var res = Map<String, dynamic>();
    res['requestId'] = this.requestId;
    res['patientName'] = this.patientName;
    res['patientDOB'] = this.patientDOB;
    res['idProofNumber'] = this.idProofNumber;
    res['patientCity'] = this.patientCity;
    res['patientState'] = this.patientState;
    res['idProofType'] = this.idProofType;

    res['hospitalName'] = this.hospitalName;
    res['hospitalAddress'] = this.hospitalAddress.toJson();

    res['prescriptionImages'] = this.prescriptionImages;
    res['illness'] = this.illness;
    res['requirement'] = this.requirement;
    res['cost'] = this.cost;

    res['pocName'] = this.pocName;
    res['pocNumber'] = this.pocNumber;
    res['pocRelation'] = this.pocRelation;

    res['status'] = this.status;
    res['verifiedByVolunteer'] = this.verifiedByVolunteer;
    this.assignedVolunteers.forEach((key, value) {
      res['assignedVolunteers'][key] = value;
    });
    res['timestamps'] = this.timestamps;
    return res;
  }

  MedicineRequest() {}

  MedicineRequest.fromMap(Map data, String helpRequestId) {
    this.requestId = data['requestId'];
    this.documentId = helpRequestId;
    this.patientName = data['patientName'];
    this.patientDOB = data['patientDOB'];
    this.idProofNumber = data['idProofNumber'];
    this.idProofType = data['idProofType'];
    this.patientCity = data['patientCity'];
    this.patientState = data['patientState'];

    this.hospitalName = data['hospitalName'];
    this.hospitalAddress = AddressModel.fromJson(data['hospitalAddress']);

    this.prescriptionImages = new List<String>();
    for (String e in data['prescriptionImages']) {
      this.prescriptionImages.add(e);
    }
    this.illness = data['illness'];
    this.requirement = data['requirement'];
    this.cost = data['cost'].toString();

    this.pocName = data['pocName'];
    this.pocNumber = data['pocNumber'];
    this.pocRelation = data['pocRelation'];

    this.status = data['status'];
    this.verifiedByVolunteer = data['verifiedByVolunteer'];
    this.assignedVolunteers = new Map<String, Map>.from(
        data['assignedVolunteers'] == null ? {} : data['assignedVolunteers']);
    if (data['timestamps'] != null) {
      this.timestamps = Map<String, Timestamp>.from(data['timestamps']);
    }
  }
}
