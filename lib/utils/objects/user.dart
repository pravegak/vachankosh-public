import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/promise.dart';

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
    if (data.containsKey('alternatePhoneNumber')) {
      this.alternatePhoneNumber = data['alternatePhoneNumber'];
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
