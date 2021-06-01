import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/model.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_constants.dart';
import 'package:vachankosh/constants/app_credentials.dart';
import 'package:vachankosh/constants/app_styles.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/ui/shared/divider_without_padding.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/user_profile_model.dart';

class AddressContactCard extends StatelessWidget {
  AddressContactCard({
    Key key,
  }) : super(key: key);
  final user = locator<User>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UserProfileModel>(context);
    return Card(
      elevation: 1.0,
      child: Container(
        padding: EdgeInsets.only(top: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address & Contact', style: AppStyles.k16BlueHeading),
            ListTile(
              leading: Icon(FontAwesomeIcons.phoneAlt),
              contentPadding: EdgeInsets.only(left: 8),
              title: Text(user.phoneNumber),
            ),
            user.volunteer == true
                ? Column(
                    children: [
                      DividerWithoutPadding(),
                      ListTile(
                        onTap: () async {
                          final p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: AppCredentials.MAPS_API_KEY,
                            language: 'en',
                          );
                          Address addressDetails =
                              await locator<LocationSearchService>()
                                  .getLocationDetails(p);
                          AddressModel addressModel = AddressModel(
                            coordinates: GeoPoint(
                                addressDetails.coordinates.latitude,
                                addressDetails.coordinates.longitude),
                            addressLine: addressDetails.addressLine,
                            countryName: addressDetails.countryName,
                            countryCode: addressDetails.countryCode,
                            featureName: addressDetails.featureName,
                            postalCode: addressDetails.postalCode,
                            locality: addressDetails.locality,
                            subLocality: addressDetails.subLocality,
                            adminArea: addressDetails.adminArea,
                            subAdminArea: addressDetails.subAdminArea,
                            thoroughfare: addressDetails.thoroughfare,
                            subThoroughfare: addressDetails.subThoroughfare,
                          );
                          model.changeProfileField(
                              AppConstants.kFirestoreUserAddress,
                              addressModel.toJson());
                        },
                        leading: Icon(FontAwesomeIcons.mapMarkedAlt),
                        contentPadding: EdgeInsets.only(left: 8),
                        title: user.addressModel == null
                            ? Text(
                                'ADD ADDRESS',
                                style: AppStyles.k16LightBlueText,
                              )
                            : Text(user.addressModel.addressLine),
                      ),
                      DividerWithoutPadding(),
                      ListTile(
                        onTap: () {
                          showEditFieldBottomSheet(context,
                              previousValue: user.alternatePhoneNumber == null
                                  ? ''
                                  : user.alternatePhoneNumber,
                              model: model, validator: (String value) {
                            if (value.length < 10) {
                              return 'Enter a 10-digit mobile number';
                            }
                            return null;
                          },
                              field:
                                  AppConstants.kFirestoreUserAlternateNoField,
                              heading: user.alternatePhoneNumber == null ||
                                      user.alternatePhoneNumber.isEmpty
                                  ? 'Add alternate number'
                                  : 'Edit alternate number');
                        },
                        leading: Icon(FontAwesomeIcons.mobileAlt),
                        contentPadding: EdgeInsets.only(left: 8),
                        title: user.alternatePhoneNumber == null ||
                                user.alternatePhoneNumber.isEmpty
                            ? Text(
                                'ADD ALTERNATE NUMBER',
                                style: AppStyles.k16LightBlueText,
                              )
                            : Text(user.alternatePhoneNumber),
                      ),
                      DividerWithoutPadding(),
                      (user.email == null || user.email.isEmpty)
                          ? ListTile(
                              onTap: () {
                                showEditFieldBottomSheet(context,
                                    previousValue: '',
                                    model: model, validator: (String value) {
                                  if (RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return null;
                                  }
                                  return 'Enter a valid email';
                                },
                                    field:
                                        AppConstants.kFirestoreUserEmailField,
                                    heading: 'Add Email');
                              },
                              leading: Icon(FontAwesomeIcons.envelope),
                              contentPadding: EdgeInsets.only(left: 8),
                              title: Text(
                                'ADD EMAIL',
                                style: AppStyles.k16LightBlueText,
                              ))
                          : ListTile(
                              onTap: () {
                                showEditFieldBottomSheet(context,
                                    previousValue: user.email,
                                    model: model, validator: (String value) {
                                  if (RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return null;
                                  }

                                  return 'Enter a valid email';
                                },
                                    field:
                                        AppConstants.kFirestoreUserEmailField,
                                    heading: 'Edit your email');
                              },
                              leading: Icon(FontAwesomeIcons.envelope),
                              contentPadding: EdgeInsets.only(left: 8),
                              title: Text(user.email),
                            ),
                      DividerWithoutPadding(),
                      (user.twitterHandle == null || user.twitterHandle.isEmpty)
                          ? ListTile(
                              onTap: () {
                                showEditFieldBottomSheet(context,
                                    previousValue: '',
                                    validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Enter your twitter username';
                                  }
                                  return null;
                                },
                                    model: model,
                                    field:
                                        AppConstants.kFirestoreUserTwitterField,
                                    heading: 'Add Twitter Handle');
                              },
                              leading: Icon(FontAwesomeIcons.twitter),
                              contentPadding: EdgeInsets.only(left: 8),
                              title: Text(
                                'ADD TWITTER USERNAME',
                                style: AppStyles.k16LightBlueText,
                              ),
                            )
                          : ListTile(
                              onTap: () {
                                showEditFieldBottomSheet(context,
                                    previousValue: user.twitterHandle,
                                    model: model, validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Enter your twitter username';
                                  }
                                  return null;
                                },
                                    field:
                                        AppConstants.kFirestoreUserTwitterField,
                                    heading: 'Edit Twitter Handle');
                              },
                              leading: Icon(
                                FontAwesomeIcons.twitter,
                              ),
                              contentPadding: EdgeInsets.only(left: 8),
                              title: Text(user.twitterHandle),
                            )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
