import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/views/dashboard/all_requests_view.dart';
import 'package:vachankosh/ui/views/dashboard/my_requests_view.dart';
import 'package:vachankosh/ui/views/user_account/user_profile_view.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/userhome.dart';

class UserHomeView extends StatefulWidget {
  static const routeName = '/userhome';

  @override
  _UserHomeView createState() => _UserHomeView();
}

class _UserHomeView extends State<UserHomeView> {
  int _currentIndex = 0;
  bool _showMyRequests = false;
  List tabs;

  @override
  void initState() {
    super.initState();
    locator<MedicineRequestService>()
        .getMyRequests(locator<User>().phoneNumber)
        .then((value) {
      setState(() {
        _showMyRequests = value.documents.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = locator<User>();
    bool volunteer = user.volunteer == true;
    if (volunteer) {
      tabs = [
        AllRequestsView(),
        if (_showMyRequests) MyRequestsView(),
        UserProfileView(),
      ];
    } else {
      tabs = [MyRequestsView(), UserProfileView()];
    }
    return ChangeNotifierProvider(
      create: (context) => locator<UserHomeModel>(),
      child: Consumer<UserHomeModel>(
        builder: (context, model, child) => WillPopScope(
          onWillPop: () {
            if (_currentIndex != 0) {
              setState(() {
                _currentIndex = 0;
              });
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Scaffold(
            body: SafeArea(child: tabs[_currentIndex]),
            bottomNavigationBar: volunteer
                ? BottomNavigationBar(
                    elevation: 12,
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      print(index);
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.format_list_bulleted),
                            title: Text('Feed')),
                        if (_showMyRequests)
                          BottomNavigationBarItem(
                              icon: Icon(Icons.assignment_ind),
                              title: Text('My Requests')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            title: Text("Profile")),
                      ])
                : BottomNavigationBar(
                    elevation: 12,
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.assignment_ind),
                            title: Text('My Requests')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person_outline),
                            title: Text("Profile")),
                      ]),
          ),
        ),
      ),
    );
  }
}
