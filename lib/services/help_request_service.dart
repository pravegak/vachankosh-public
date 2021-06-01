import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

import '../locator.dart';
import '../utils/objects/promise.dart';

class MedicineRequestService {
  final CollectionReference _requestsCollectionReference =
      Firestore.instance.collection('medsRequests');

  final CollectionReference _userCollectionReference =
      Firestore.instance.collection('users');

  Future assignRequestVerification(
      MedicineRequest helpRequest, String userId) async {
    try {
      Map ts = helpRequest.timestamps;
      ts['verAssignedAt'] = Timestamp.now();
      await _requestsCollectionReference
          .document(helpRequest.documentId)
          .updateData({
        'status': 'Under Verification',
        'verifiedByVolunteer': userId,
        'timestamps': ts
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getMyRequestsStream(String pocNumber) {
    return _requestsCollectionReference
        .where('pocNumber', isEqualTo: pocNumber)
        .snapshots();
  }

  Future<QuerySnapshot> getMyRequests(String pocNumber) {
    return _requestsCollectionReference
        .where('pocNumber', isEqualTo: pocNumber)
        .getDocuments();
  }

/*Get Requests verified by the user*/
  Future<List<MedicineRequest>> getRequestsVerfiedByMe() async {
    QuerySnapshot querySnapshot = await _requestsCollectionReference
        .where('verifiedByVolunteer', isEqualTo: locator<User>().phoneNumber)
        .getDocuments();
    List<DocumentSnapshot> documents = querySnapshot.documents;
    return List.generate(
        documents.length,
        (index) => MedicineRequest.fromMap(
            documents[index].data, documents[index].documentID));
  }

  Stream<DocumentSnapshot> getRequestSnapshotStream(String docuemntId) {
    return _requestsCollectionReference.document(docuemntId).snapshots();
  }

  Future offerMonetaryHelp(
      String phoneNumber, int monetaryValue, String helpRequestId) async {
    try {
      DocumentSnapshot document =
          await _requestsCollectionReference.document(helpRequestId).get();
      Map<String, Map> previousMap;
      if (document.data['assignedVolunteers'] != null) {
        /*If the request has already some volunteers assigned
         status is already in In Progress*/
        previousMap =
            Map<String, Map>.from(document.data['assignedVolunteers']);
        if (previousMap.containsKey(phoneNumber)) {
          previousMap.update(phoneNumber, (value) => {'amount': monetaryValue});
        } else {
          previousMap.addAll({
            phoneNumber: {'amount': monetaryValue}
          });
        }
      } else {
        /*First volunteer is offering help*/
        previousMap = {
          phoneNumber: {'amount': monetaryValue}
        };
      }

      var time = Timestamp.now();
      previousMap.update(phoneNumber, (value) {
        value['time'] = time;
        return value;
      });
      await _requestsCollectionReference
          .document(helpRequestId)
          .updateData({'assignedVolunteers': previousMap});
      DocumentSnapshot reqDocument =
          await _requestsCollectionReference.document(helpRequestId).get();

      int currentTotalDonation = 0;
      (reqDocument.data['assignedVolunteers'] as Map).forEach((key, value) {
        currentTotalDonation += value['amount'];
      });
      num requirementCost = num.parse(reqDocument.data['cost']);

      /*Update status to In progress after first help is offered*/
      if (reqDocument.data['status'] == RequestStatus.VERIFIED) {
        //Case if the user offers help worth the total requirement cost
        if (requirementCost - currentTotalDonation == 0) {
          await _requestsCollectionReference
              .document(helpRequestId)
              .updateData({'status': RequestStatus.COMPLETED});
        } else {
          await _requestsCollectionReference
              .document(helpRequestId)
              .updateData({'status': RequestStatus.IN_PROGRESS});
        }
      } else if (reqDocument.data['assignedVolunteers'] != null) {
        print(currentTotalDonation);
        print(requirementCost);
        /*Update status to Completed after current requirement cost goes to 0*/
        if (requirementCost - currentTotalDonation == 0) {
          await _requestsCollectionReference
              .document(helpRequestId)
              .updateData({'status': RequestStatus.COMPLETED});
        }
      }

      // now update the user to contain the info about
      // the expenses being done
      var currentUser =
          await _userCollectionReference.document(phoneNumber).get();
      Map<String, Map> currentPromises =
          Map<String, Map>.from(currentUser.data['promises']);
      // add expense to logs
      currentPromises['monetary']['expenses']
          [helpRequestId] = {'quantity': monetaryValue, 'time': time};
      // deduce spent quantity from the current state
      currentPromises['monetary']['currentState']['quantityLeft'] -=
          monetaryValue;
      await _userCollectionReference
          .document(phoneNumber)
          .updateData({'promises': currentPromises});
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getAllRequestsStream() {
    return _requestsCollectionReference.snapshots();
  }

  Future verifyRequest(MedicineRequest request) async {
    Map ts = request.timestamps;
    ts['verifiedAt'] = Timestamp.now();
    try {
      await _requestsCollectionReference
          .document(request.documentId)
          .updateData({
        'status': 'Verified',
        'timestamps': ts,
      });
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
