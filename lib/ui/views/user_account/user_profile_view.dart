import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/views/user_account/address_contact_card.dart';
import 'package:vachankosh/ui/views/user_account/app_info_card.dart';
import 'package:vachankosh/ui/views/user_account/promises_and_more_card.dart';
import 'package:vachankosh/ui/views/user_account/user_header.dart';
import 'package:vachankosh/ui/views/user_account/volunteering_profile_card.dart';
import 'package:vachankosh/utils/helper_functions.dart';
import 'package:vachankosh/utils/objects/user.dart';
import 'package:vachankosh/viewmodels/user_profile_model.dart';
import 'edit_text_bottom_sheet.dart';

class UserProfileView extends StatefulWidget {
  static const routeName = "/userProfile";

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Account'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 4,
            ),
            UserHeader(),
            AddressContactCard(),
            VolunteeringProfileCard(),
            PromisesAndMoreCard(),
            AppInfoCard(),
          ],
        ),
      ),
    );
  }
}

void showEditFieldBottomSheet(BuildContext context,
    {String previousValue,
    UserProfileModel model,
    String field,
    String heading,
    Function(String) validator}) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        TextEditingController textEditingController = TextEditingController()
          ..text = previousValue
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: previousValue.length));
        return EditTextBottomSheet(
            textEditingController: textEditingController,
            heading: heading,
            validator: validator,
            onSave: () {
              final newValue = textEditingController.text.isEmpty
                  ? null
                  : textEditingController.text;
              model.changeProfileField(field, newValue);
            });
      });
}

class MyExpensesSheet extends StatefulWidget {
  const MyExpensesSheet({
    Key key,
  }) : super(key: key);

  @override
  _MyExpensesSheetState createState() => _MyExpensesSheetState();
}

class _MyExpensesSheetState extends State<MyExpensesSheet> {
  List expenses = locator<User>().promises['monetary'].expenses.values.toList();

  @override
  Widget build(BuildContext context) {
    String quantityLeft = locator<User>()
        .promises['monetary']
        .currentState['quantityLeft']
        .toString();
    String monetaryPromiseValue =
        locator<User>().promises['monetary'].quantity.toString();
    String monetaryPromisePlan = locator<User>().promises['monetary'].time;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: Text(
                    'Monetary Promise Details',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '₹$monetaryPromiseValue',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$monetaryPromisePlan',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Balance Remaining: ',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Text(
                    '₹$quantityLeft',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Divider(
                  color: Colors.black45,
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Expenses',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                    child: Divider(
                  color: Colors.black45,
                )),
              ],
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: expenses.isEmpty
                    ? Center(
                        child: Text('Nothing here...'),
                      )
                    : ListView.separated(
                        itemBuilder: (context, pos) {
                          print(expenses);
                          return ExpenseTile(details: expenses[pos]);
                        },
                        itemCount: expenses.length,
                        separatorBuilder: (context, pos) => Divider(
                          color: Colors.black54,
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    Key key,
    @required this.details,
  }) : super(key: key);

  final Map details;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Text('- ₹${details['quantity']}',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          )),
      leading: Text(getDateString(details['time'].toDate())),
    );
  }
}

class CustomizedIcon extends StatelessWidget {
  const CustomizedIcon({
    Key key,
    this.icon,
  }) : super(key: key);
  final Color backGroundColor = Colors.black;
  @required
  final IconData icon;
  final Color iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: backGroundColor, borderRadius: BorderRadius.circular(4)),
        child: Icon(
          icon,
          color: iconColor,
        ));
  }
}
