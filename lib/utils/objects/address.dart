import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  GeoPoint coordinates;
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
      coordinates = json['coordinates'];
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
      data['coordinates'] = this.coordinates;
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

  CoordinatesModel.fromFirestoreGeoPoint(GeoPoint geoPoint) {
    latitude = geoPoint.latitude;
    longitude = geoPoint.longitude;
  }

  GeoPoint toFirestoreGeoPoint() {
    return GeoPoint(this.latitude, this.longitude);
  }
}
