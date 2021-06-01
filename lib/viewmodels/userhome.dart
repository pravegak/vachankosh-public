import 'package:flutter/material.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';

enum UserHomeState { Loading, Empty, Loaded }

class UserHomeModel extends ChangeNotifier {
  UserHomeState _state = UserHomeState.Loading;
  UserHomeState get state => _state;
  List<MedicineRequest> requests = new List();

  Future<void> loadRequests() async {
    User user = locator<User>();
    if (user.volunteer == true) {
      requests = await listMedicineRequests();
    } else {
      requests = await listUserReportedRequests(user.phoneNumber);
    }
    if (requests.isEmpty) {
      setState(UserHomeState.Empty);
    }
    setState(UserHomeState.Loaded);
  }

  // rebuilds the users list
  // trigerred by pulling to refresh or creating fresh instance
  void rebuild() {
    setState(UserHomeState.Loading);
    loadRequests();
  }

  UserHomeModel() {
    rebuild();
  }

  void setState(UserHomeState state) {
    _state = state;
    notifyListeners();
  }
}
