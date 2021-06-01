import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/constants/app_data.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/services/help_request_service.dart';
import 'package:vachankosh/ui/views/admin/admin_user_info.dart';
import 'package:vachankosh/ui/views/admin/stats_view.dart';
import 'package:vachankosh/ui/views/dashboard/request_tile.dart';
import 'package:vachankosh/ui/views/help_request_detail_view.dart';
import 'package:vachankosh/ui/views/startup_view.dart';
import 'package:vachankosh/utils/firebase.dart';
import 'package:vachankosh/utils/objects/medicine_request.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/admin.dart';

class AdminView extends StatefulWidget {
  static const routeName = '/admin';

  @override
  _AdminView createState() => _AdminView();
}

class _AdminView extends State<AdminView> {
  @override
  Widget build(BuildContext context) {
    User user = locator<User>();

    return ChangeNotifierProvider<AdminModel>(
      create: (context) => locator<AdminModel>(),
      child: Consumer<AdminModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text("Admin Panel"),
          ),
          drawer: SafeArea(
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      accountName: Text('Admin (' + user.name + ')'),
                      accountEmail: Text(user.phoneNumber)),
                  ListTile(
                    title: Text("Requests"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllRequestsAdmin()));
                    },
                  ),
                  ListTile(
                    title: Text("Add Admin"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("How the app works?"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("Statistics"),
                    onTap: () {
                      Navigator.pushNamed(context, StatsView.routeName);
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    trailing: Icon(Icons.exit_to_app),
                    onTap: () async {
                      await signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, StartupView.routeName, (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: buildList(context, model),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, AdminModel model) {
    if (model.state == AdminViewState.Loaded) {
      return ListView(
        children: model.users
            .map((User user) => Card(
                  color: Colors.amber[100],
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, AdminUserInfoView.routeName,
                          arguments: {'userData': user});
                    },
                    leading: Icon(Icons.person_outline),
                    title: Text(user.name),
                    contentPadding: EdgeInsets.all(5.0),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.phoneNumber),
                        if (user.addressModel != null)
                          Text(user.addressModel.addressLine)
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    } else if (model.state == AdminViewState.Empty) {
      return Center(
        child: Text("No users joined yet!"),
      );
    }
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Loading all users"),
        SpinKitFoldingCube(
          color: Colors.blue,
        )
      ],
    ));
  }
}

class AllRequestsAdmin extends StatefulWidget {
  const AllRequestsAdmin({
    Key key,
  }) : super(key: key);

  @override
  _AllRequestsAdminState createState() => _AllRequestsAdminState();
}

class _AllRequestsAdminState extends State<AllRequestsAdmin> {
  bool _newFilterState;
  bool _uvFilterState;
  bool _vFilterState;
  bool _ipFilterState;
  bool _compFilterState;
  bool get _noFilter => !(_newFilterState ||
      _uvFilterState ||
      _vFilterState ||
      _ipFilterState ||
      _compFilterState);

  @override
  void initState() {
    super.initState();
    _newFilterState = false;
    _uvFilterState = false;
    _vFilterState = false;
    _ipFilterState = false;
    _compFilterState = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Requests'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _newFilterState,
                        onChanged: (value) {
                          print('Tapped');
                          print(value);
                          setState(() {
                            _newFilterState = value;
                          });
                        },
                      ),
                      Text('New'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _uvFilterState,
                        onChanged: (value) {
                          print('Tapped');
                          print(value);
                          setState(() {
                            _uvFilterState = value;
                          });
                        },
                      ),
                      Text('Under verification'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _vFilterState,
                        onChanged: (value) {
                          print('Tapped');
                          print(value);
                          setState(() {
                            _vFilterState = value;
                          });
                        },
                      ),
                      Text('Verified'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _ipFilterState,
                        onChanged: (value) {
                          print('Tapped');
                          print(value);
                          setState(() {
                            _ipFilterState = value;
                          });
                        },
                      ),
                      Text('In Progress'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Checkbox(
                        value: _compFilterState,
                        onChanged: (value) {
                          print('Tapped');
                          print(value);
                          setState(() {
                            _compFilterState = value;
                          });
                        },
                      ),
                      Text('Completed'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream:
                    locator<MedicineRequestService>().getAllRequestsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitFoldingCube(
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    //Filtering logic
                    var filteredRequests = [];
                    List<DocumentSnapshot> allRequests =
                        snapshot.data.documents;
                    if (_noFilter) {
                      filteredRequests = allRequests;
                    } else {
                      filteredRequests.clear();
                      allRequests.forEach((element) {
                        if (_newFilterState &&
                            element.data['status'] == RequestStatus.NEW) {
                          filteredRequests.add(element);
                        } else if (_uvFilterState &&
                            element.data['status'] ==
                                RequestStatus.UNDER_VERIFICATION) {
                          filteredRequests.add(element);
                        } else if (_vFilterState &&
                            element.data['status'] == RequestStatus.VERIFIED) {
                          filteredRequests.add(element);
                        } else if (_ipFilterState &&
                            element.data['status'] ==
                                RequestStatus.IN_PROGRESS) {
                          filteredRequests.add(element);
                        } else if (_compFilterState &&
                            element.data['status'] == RequestStatus.COMPLETED) {
                          filteredRequests.add(element);
                        }
                      });
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];

                        return RequestTile(
                            request:
                                MedicineRequest.fromMap(request.data, null),
                            onTap: () => Navigator.pushNamed(
                                  context,
                                  MedicineRequestDetailView.routeName,
                                  arguments: request.documentID,
                                ));
                      },
                      itemCount: filteredRequests.length,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
