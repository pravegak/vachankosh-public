import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/constants/app_credentials.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/ui/views/medicine_request_quiz/widgets/input_box.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/viewmodels/create_issue_model.dart';

import '../../../../locator.dart';

class HospitalDetailsPage extends StatelessWidget {
  const HospitalDetailsPage({
    Key key,
    @required this.formkey,
    this.pageController,
  }) : super(key: key);

  final GlobalKey<FormState> formkey;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateIssueModel>(context);
    return WillPopScope(
      onWillPop: () {
        //model.setPageTitle('Patient Details');
        pageController.previousPage(
            duration: Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut);
        return Future.value(false);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    InputBox(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Hospital name is required cannot be empty';
                        }
                        return null;
                      },
                      controller: model.editingControllers[4],
                      hintText: 'Hospital Name',
                      icon: Icon(FontAwesomeIcons.hospitalSymbol),
                    ),
                    InputBox(
                      enabled: true,
                      onTap: () async {
                        final p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: AppCredentials.MAPS_API_KEY,
                          language: 'en',
                        );
                        model.editingControllers[5].text = p.description;
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
                        model.setHospitalAddress(addressModel);
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Hospital address is required and cannot be empty';
                        }
                        return null;
                      },
                      controller: model.editingControllers[5],
                      hintText: 'Hospital Address',
                      icon: Icon(FontAwesomeIcons.solidHospital),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              if (formkey.currentState.validate()) {
                                model.setFormAutoValidate(false);
                                pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.linearToEaseOut);
                                //model.setPageTitle('Request Details');
                              } else {
                                model.setFormAutoValidate(true);
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 16,
                            ),
                            label: Text('Next')),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
