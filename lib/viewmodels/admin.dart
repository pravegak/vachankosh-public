import 'package:flutter/material.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/user.dart';

enum AdminViewState { Loading, Empty, Loaded }

class AdminModel extends ChangeNotifier {
  AdminViewState _state = AdminViewState.Loading;
  AdminViewState get state => _state;
  List<User> users = new List();

  Future<void> loadUsers() async {
    users = await listUsers();
    if (users.isEmpty) {
      setState(AdminViewState.Empty);
    }
    setState(AdminViewState.Loaded);
  }

  // rebuilds the users list
  // trigerred by pulling to refresh or creating fresh instance
  void rebuild() {
    setState(AdminViewState.Loading);
    loadUsers();
  }

  AdminModel() {
    rebuild();
  }

  void setState(AdminViewState state) {
    _state = state;
    notifyListeners();
  }
}
