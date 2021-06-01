import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vachankosh/models/cloud_storage_result.dart';
import 'package:vachankosh/utils/objects/app_issue.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../locator.dart';

final firestoreInstance = Firestore.instance;

const String VOLUNTEERS_TABLE = 'users';
const String MEDICINES_REQUESTS_TABLE = 'medsRequests';
const String ADMIN_TABLE = 'admins';
const String VERSION_TABLE = 'latestVersion';
const String REQUEST_ID_TABLE = 'requestId';

// get the latest version of app from the server
Future<double> getLatestVersion() async {
  // by default let's assign to minimum value so that atleast
  // we don't show false positives even if there is some error
  double version = 0.0;
  await firestoreInstance
      .collection(VERSION_TABLE)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      version = element.data['version'];
    });
  });
  return version;
}

// Checks the last used request ID on the server, get it
// increment by one, update the server and returns the incremented
// one. This all is done inside a transaction which locks the
// underlying table so that no race condition happen.
Future<int> getRequestId() async {
  int lastUsed = 0;
  DocumentReference documentReference = firestoreInstance
      .collection(REQUEST_ID_TABLE)
      // hard coded value copy pasted from firebase UI
      .document('KyqlRUPbfF8dtW6hfphG');

  await firestoreInstance.runTransaction((Transaction transaction) async {
    DocumentSnapshot snap = await transaction.get(documentReference);
    lastUsed = snap.data['lastUsed'];
    await transaction
        .update(documentReference, <String, dynamic>{'lastUsed': lastUsed + 1});
  });
  return lastUsed + 1;
}

Future<void> addAppIssue(AppIssue issue) {
  issue.createdAt = Timestamp.now();
  return firestoreInstance
      .collection("appIssues")
      .document()
      .setData(issue.toMap());
}

Future<void> signOut() async {
  return await FirebaseAuth.instance.signOut();
}

Future<void> addUser(User user, {bool update: false}) async {
  var firebaseUser = await FirebaseAuth.instance.currentUser();
  user.createdAt = Timestamp.now();
  return firestoreInstance
      .collection(VOLUNTEERS_TABLE)
      .document(firebaseUser.phoneNumber)
      .setData(user.toMap(), merge: update);
}

// returns whether a new user was added or not
Future<bool> addIfNotExists(User user) async {
  // since addUser can only be called once that user has logged
  // in, we can easily rely on the existsUser() part which checks
  // if the current user has logged in or not
  bool exists = await existsUser();

  if (exists) {
    return false;
  }
  await addUser(user);
  return true;
}

// tells whether a user exists in our users collection by
// searching for a document in current users UID
Future<bool> existsUser() async {
  try {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var doc = await firestoreInstance
        .collection(VOLUNTEERS_TABLE)
        .document(firebaseUser.phoneNumber)
        .get();
    if (doc.exists) {
      return true;
    }
    return false;
  } catch (e) {
    print(e.toString());
    //TODO: think what should be done with this error
  }
  return false;
}

// Tells whether the given user is an admin or not
Future<bool> isAdmin(User user) async {
  bool admin = false;
  await firestoreInstance
      .collection(ADMIN_TABLE)
      .where(user.phoneNumber, isEqualTo: true)
      .getDocuments()
      .then((value) {
    if (value == null || value.documents.length == 0) {
      return;
    }
    admin = true;
  });
  return admin;
}

Future<User> getCurrentUser() async {
  var firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser == null) {
    return null;
  }
  User res;
  await firestoreInstance
      .collection(VOLUNTEERS_TABLE)
      .document(firebaseUser.phoneNumber)
      .get()
      .then((value) {
    res = User.fromMap(value.data);
  });
  res.admin = await isAdmin(res);
  return res;
}

Future<List<User>> listUsers() async {
  List<User> res = new List();
  await firestoreInstance
      .collection(VOLUNTEERS_TABLE)
      .orderBy('createdAt', descending: true)
      .getDocuments()
      .then((result) {
    result.documents.forEach((element) {
      res.add(User.fromMap(element.data));
    });
  });
  return res;
}

Future<List<User>> listGroundVolunteers() async {
  List<User> res = new List();
  await firestoreInstance
      .collection(VOLUNTEERS_TABLE)
      .where("onGV", isEqualTo: 1)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      res.add(User.fromMap(element.data));
    });
  });
  return res;
}

Future updateProfileImageUrl(CloudStorageResult result) async {
  var firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    await Firestore.instance
        .collection(VOLUNTEERS_TABLE)
        .document(firebaseUser.phoneNumber)
        .updateData({"imageUrl": result.imageUrl});
  }
}

Future<void> addMedicineRequest(MedicineRequest request,
    {bool update: false}) async {
  request.timestamps['createdAt'] = Timestamp.now();
  request.requestId = await getRequestId();
  return firestoreInstance
      .collection(MEDICINES_REQUESTS_TABLE)
      .document()
      .setData(request.toMap(), merge: update);
}

//List help requests not reported by the user himself
Future<List<MedicineRequest>> listMedicineRequests() async {
  List<MedicineRequest> res = new List();
  await firestoreInstance
      .collection(MEDICINES_REQUESTS_TABLE)
      .getDocuments()
      .then((result) {
    result.documents.forEach((element) {
      if (element.data['pocNumber'] != locator<User>().phoneNumber)
        res.add(MedicineRequest.fromMap(element.data, element.documentID));
    });
  });
  return res;
}

Future<List<MedicineRequest>> listVerifiedMedicineRequests(String city,
    {bool verified: true}) async {
  List<MedicineRequest> res = new List();
  await firestoreInstance
      .collection(MEDICINES_REQUESTS_TABLE)
      .where('verifiedByVolunteer', isNull: verified ? false : true)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      if (element.data['patientCity'] == city) {
        res.add(MedicineRequest.fromMap(element.data, element.documentID));
      } else {
        // TODO: right now we add all the requests because city
        // based filtering is still not good
        res.add(MedicineRequest.fromMap(element.data, element.documentID));
      }
    });
  });
  return res;
}

Future<List<MedicineRequest>> listUserReportedRequests(String phoneNum) async {
  List<MedicineRequest> res = new List();
  await firestoreInstance
      .collection(MEDICINES_REQUESTS_TABLE)
      .where('pocNumber', isEqualTo: phoneNum)
      .getDocuments()
      .then((value) {
    value.documents.forEach((element) {
      res.add(MedicineRequest.fromMap(element.data, element.documentID));
    });
  });
  return res;
}
