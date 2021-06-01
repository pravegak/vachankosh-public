import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/model.dart';
import 'package:vachankosh/constants/app_constants.dart';
import 'package:vachankosh/constants/app_credentials.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/edit_profile_service.dart';
import 'package:vachankosh/services/location_search_service.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/objects/address.dart';
import 'package:vachankosh/utils/objects/user.dart';

class UserProfileModel extends ChangeNotifier {
  final _editProfileService = locator<EditProfileService>();
  bool get isBloodDonor => locator<User>().bloodGroup != null;

  changeProfileField(String field, dynamic newValue) async {
    print(field);
    print("Hello: $newValue");
    _editProfileService.changeProfileField(field, newValue);

    switch (field) {
      case AppConstants.kFirestoreUserNameField:
        locator<User>()..name = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserAlternateNoField:
        locator<User>()..alternatePhoneNumber = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserEmailField:
        locator<User>()..email = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserTwitterField:
        locator<User>()..twitterHandle = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserOnGVField:
        locator<User>()..onGroundVolunteer = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserBloodGroupField:
        locator<User>()..bloodGroup = newValue;
        notifyListeners();
        break;
      case AppConstants.kFirestoreUserAddress:
        locator<User>()..addressModel = AddressModel.fromJson(newValue);
        notifyListeners();
        break;
    }
  }
}
