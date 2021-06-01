// Contains Dart representation of various objects we use in the app

import 'package:cloud_firestore/cloud_firestore.dart';

class Promise {
  final String monetary = 'monetary';

  // object which the person is promising
  // monetary, or anything else
  String object;

  // Quantity which is promised
  int quantity;

  // whether the promise if montly or yearly
  String time;

  // unit of the promise offered
  String unit;

  // map of expenditures which user has made of this promise
  // contains a map where quantity is the key
  // and value is a map which conatins request ID of the request
  // where expense was made and time when it was done
  Map<String, Map> expenses;

  // represents the current State of the promise i.e. how much
  // quantity is left and when will the quantity be refilled
  Map<String, int> currentState;

  Promise(String object, int quantity, String time, String unit) {
    if (object == null) {
      object = monetary;
    }
    this.object = object;
    this.quantity = quantity;
    this.time = time;
    this.unit = unit;
    this.expenses = {};
    this.currentState = {};
    this.currentState['quantityLeft'] = quantity;
    if (time == 'Monthly') {
      this.currentState['nextRefill'] = 30;
    } else if (time == 'Quarterly') {
      this.currentState['nextRefill'] = 120;
    } else {
      this.currentState['nextRefill'] = 365;
    }
  }

  Map<String, dynamic> toMap() {
    var res = Map<String, dynamic>();
    res['object'] = this.object;
    res['quantity'] = this.quantity;
    res['time'] = this.time;
    res['unit'] = this.unit;
    res['expenses'] = {};
    this.expenses.forEach((key, value) {
      res['expenses'][key] = value;
    });
    res['currentState'] = this.currentState;
    return res;
  }

  Promise.fromMap(Map data) {
    this.object = data['object'];
    this.quantity = data['quantity'];
    this.time = data['time'];
    this.unit = data['unit'];
    this.expenses = {};
    if (data['expenses'] == null) {
      return;
    }
    data['expenses'].forEach((k, v) {
      this.expenses[k] = v;
    });
    this.currentState = Map<String, int>.from(data['currentState']);
  }

  // deep copies a promise object in current one
  void clone(Promise p) {
    this.object = p.object;
    this.quantity = p.quantity;
    this.time = p.time;
    this.unit = p.unit;
    this.expenses = p.expenses;
    this.currentState = p.currentState;
  }
}

class User {
  // basic user location and contact details
  String phoneNumber;
  String alternatePhoneNumber;
  String imageUrl;
  String name;
  String email;
  String twitterHandle;
  AddressModel addressModel;
  // String state;
  // String city;

  // whether the user is a volunteer or not
  // this should be set always
  bool volunteer = true;

  // blood group of the user. Can be null if the user does not want
  // to donate blood
  String bloodGroup;

  // whether the person agreed to volunteer on ground and verify
  bool onGroundVolunteer;

  // key is the promise object
  Map<String, Promise> promises;

  // whether the user is an admin or not. It's is not stored with
  // user object. It's stored in a separate document
  // When the user logs in, we get whether the person is admin or not
  // from the server
  bool admin;

  // when was the user created
  Timestamp createdAt;

  //Getter for Quantity left
  int get remainingPromiseAmount =>
      promises['monetary'].currentState['quantityLeft'];

  // ignore: empty_constructor_bodies
  User() {}

  User.fromMap(Map data) {
    this.phoneNumber = data['phoneNumber'];
    if (data['imageUrl'] != null) {
      this.imageUrl = data["imageUrl"];
    }
    this.volunteer = data['volunteer'];
    if (data.containsKey('alternateNumber')) {
      this.alternatePhoneNumber = data['alternateNumber'];
    }
    this.name = data['name'];
    if (data.containsKey("email")) {
      this.email = data['email'];
    }
    if (data.containsKey("twitterHandle")) {
      this.twitterHandle = data['twitterHandle'];
    }
    this.addressModel =
        data['address'] != null ? AddressModel.fromJson(data['address']) : null;
    // this.state = data['state'];
    // this.city = data['city'];
    this.onGroundVolunteer = data['onGV'] == true ? true : false;
    if (data.containsKey("bloodGroup")) {
      this.bloodGroup = data['bloodGroup'];
    }
    this.promises = {};
    if (data['promises'] != null) {
      data['promises'].forEach((k, p) {
        Promise promise = new Promise.fromMap(p);
        this.promises[k] = promise;
      });
    }
    if (data['createdAt'] != null) {
      this.createdAt = data['createdAt'];
    }
  }

  Map<String, dynamic> toMap() {
    var res = Map<String, dynamic>();
    res['phoneNumber'] = this.phoneNumber;
    res['volunteer'] = this.volunteer;
    if (this.imageUrl != null) {
      res['imageUrl'] = this.imageUrl;
    }
    if (this.alternatePhoneNumber != null &&
        this.alternatePhoneNumber.isNotEmpty) {
      res['alternatePhoneNumber'] = this.alternatePhoneNumber;
    }
    res['name'] = this.name;
    if (this.email != null && this.email.isNotEmpty) {
      res['email'] = this.email;
    }
    if (this.twitterHandle != null && this.twitterHandle.isNotEmpty) {
      res['twitterHandle'] = this.twitterHandle;
    }
    res['address'] = addressModel != null ? this.addressModel.toJson() : null;
    // res['state'] = this.state;
    // res['city'] = this.city;
    if (this.bloodGroup != null) {
      res['bloodGroup'] = this.bloodGroup;
    }
    if (this.onGroundVolunteer != null) {
      if (this.onGroundVolunteer) {
        res['onGV'] = true;
      } else {
        res['onGV'] = false;
      }
    }

    if (this.promises != null) {
      res['promises'] = {};
      this.promises.forEach((key, value) {
        res['promises'][key] = value.toMap();
      });
    }
    res['createdAt'] = this.createdAt;

    return res;
  }

  // deep copies an existing user object
  void clone(User u) {
    this.admin = u.admin;
    this.alternatePhoneNumber = u.alternatePhoneNumber;
    this.twitterHandle = u.twitterHandle;
    this.bloodGroup = u.bloodGroup;
    this.addressModel = u.addressModel;
    // this.city = u.city;
    this.email = u.email;
    this.imageUrl = u.imageUrl;
    this.name = u.name;
    this.onGroundVolunteer = u.onGroundVolunteer;
    this.phoneNumber = u.phoneNumber;
    // this.state = u.state;
    this.promises = {};
    if (u.promises != null) {
      u.promises.forEach((key, p) {
        Promise pr = new Promise(p.object, p.quantity, p.time, p.unit);
        if (p.expenses != null) {
          pr.expenses = p.expenses;
        }
        if (p.currentState != null) {
          pr.currentState = p.currentState;
        }
        this.promises[key] = pr;
      });
    }
    this.volunteer = u.volunteer;
    this.createdAt = u.createdAt;
  }
}

// denotes an application issue filed by some user
class AppIssue {
  // phoneNumber of the user who filed the issue
  String phoneNumber;
  // description of the issue
  String desc;
  // feature or bug?
  String issueType;

  Timestamp createdAt;

  String toString() {
    return "AppIssue($phoneNumber, $desc, $issueType)";
  }

  Map toMap() {
    var res = Map<String, dynamic>();
    res['phoneNumber'] = phoneNumber;
    res['desc'] = desc;
    res['type'] = issueType;
    res['createdAt'] = createdAt;
    return res;
  }
}

// represents a help request which we got on platform
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

class AddressModel {
  CoordinatesModel coordinates;
  String addressLine;
  String countryName;
  String countryCode;
  String featureName;
  String postalCode;
  String locality;
  String subLocality;
  String adminArea;
  String subAdminArea;
  String thoroughfare;
  String subThoroughfare;

  AddressModel(
      {this.coordinates,
      this.addressLine,
      this.countryName,
      this.countryCode,
      this.featureName,
      this.postalCode,
      this.locality,
      this.subLocality,
      this.adminArea,
      this.subAdminArea,
      this.thoroughfare,
      this.subThoroughfare});

  AddressModel.fromJson(Map json) {
    if (json != null) {
      coordinates = json['coordinates'] != null
          ? new CoordinatesModel.fromJson(json['coordinates'])
          : null;
      addressLine = json['addressLine'];
      countryName = json['countryName'];
      countryCode = json['countryCode'];
      featureName = json['featureName'];
      postalCode = json['postalCode'];
      locality = json['locality'];
      subLocality = json['subLocality'];
      adminArea = json['adminArea'];
      subAdminArea = json['subAdminArea'];
      thoroughfare = json['thoroughfare'];
      subThoroughfare = json['subThoroughfare'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['addressLine'] = this.addressLine;
    data['countryName'] = this.countryName;
    data['countryCode'] = this.countryCode;
    data['featureName'] = this.featureName;
    data['postalCode'] = this.postalCode;
    data['locality'] = this.locality;
    data['subLocality'] = this.subLocality;
    data['adminArea'] = this.adminArea;
    data['subAdminArea'] = this.subAdminArea;
    data['thoroughfare'] = this.thoroughfare;
    data['subThoroughfare'] = this.subThoroughfare;
    return data;
  }
}

class CoordinatesModel {
  double latitude;
  double longitude;

  CoordinatesModel({this.latitude, this.longitude});

  CoordinatesModel.fromJson(Map json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
