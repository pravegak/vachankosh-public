// denotes an application issue filed by some user
import 'package:cloud_firestore/cloud_firestore.dart';

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
