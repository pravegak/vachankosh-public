import 'package:flutter/material.dart';
import 'package:vachankosh/utils/objects/user.dart';

class AdminUserInfoView extends StatelessWidget {
  static const routeName = '/adminUserInfo';

  Widget listUserPromises(User user) {
    return Column(
        children: user.promises.values.map((e) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(e.object),
          Text("${e.quantity.toString()} ${e.unit == null ? '' : e.unit}"),
          Text(e.time)
        ],
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments as Map;
    User user = args['userData'];
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: ListView(
        children: <Widget>[
          Text(user.name),
          Text(user.phoneNumber),
          if (user.addressModel != null) Text(user.addressModel.addressLine),
          Text(
              user.bloodGroup == null ? "Not donating blood" : user.bloodGroup),
          Text(user.onGroundVolunteer == true
              ? "Yes, will volunteer on ground"
              : "Won't be able to volunteer on ground"),
          listUserPromises(user),
        ],
      ),
    );
  }
}
