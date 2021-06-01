import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/dialogs/Confirmation_dialog.dart';
import 'package:vachankosh/ui/dialogs/dialogs.dart';
import 'package:vachankosh/ui/shared/add_promise_button.dart';
import 'package:vachankosh/utils/objects/promise.dart';
import 'package:vachankosh/utils/objects/user.dart';

class UserPromisesView extends StatefulWidget {
  static const routeName = '/userPromises';
  @override
  _UserPromisesViewState createState() => _UserPromisesViewState();
}

class _UserPromisesViewState extends State<UserPromisesView> {
  final _promiseInputFormKey = GlobalKey<FormState>();

  void deletePromise(
      BuildContext context, String promiseKey, String documentId) {
    Dialogs.showAppDialog(
        context,
        ConfirmationDialog(
          title: 'Delete Promise',
          message: 'Do you want to delete this promise?',
          buttonTitle: 'Yes',
          onTap: () async {
            await Firestore.instance
                .collection('users')
                .document(documentId)
                .setData({
              "promises": {promiseKey: FieldValue.delete()}
            }, merge: true);
            //Update local user object
            locator<User>().promises.remove(promiseKey);
          },
        ));
  }

  void editPromise(BuildContext context, String promiseKey, String documentId,
      int pos) async {
    //Show Dialog to Update promise
    var d =
        await Firestore.instance.collection('users').document(documentId).get();
    final promise = Promise.fromMap(d.data['promises'][promiseKey]);
    var itemNameController = TextEditingController()..text = promise.object;
    var quantityController = TextEditingController()
      ..text = promise.quantity.toString();
    var unitController = TextEditingController()..text = promise.unit;
    var timeDropDownValue = promise.time;

    Promise newPromise = await showPromisePopUp(
        context,
        _promiseInputFormKey,
        itemNameController,
        quantityController,
        unitController,
        timeDropDownValue,
        update: true);
    if (newPromise != null) {
      await Firestore.instance
          .collection('users')
          .document(documentId)
          .setData({
        "promises": {promiseKey: newPromise.toMap()},
      }, merge: true);
      //Update local user object
      locator<User>().promises.update(promiseKey, (value) => newPromise);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = locator<User>();
    var documentId = user.phoneNumber;
    // var promises = user.promises;
    // List promiseKeys = user.promises.keys.toList();
    return Scaffold(
        floatingActionButton: AddPromiseButton(
          formKey: GlobalKey(),
          onAdd: (Promise newPromise) async {
            await Firestore.instance
                .collection('users')
                .document(documentId)
                .setData({
              "promises": {newPromise.object: newPromise.toMap()}
            }, merge: true);
            //Update local user object
            locator<User>()
                .promises
                .putIfAbsent(newPromise.object, () => newPromise);
          },
        ),
        appBar: AppBar(
          title: Text('Promises'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(locator<User>().phoneNumber)
                .snapshots(),
            builder: (context, snapshot) {
              Map<String, dynamic> p = snapshot.data['promises'];
              var keys = p.keys.toList();
              print(keys);
              return Container(
                child: Stack(
                  children: <Widget>[
                    ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemBuilder: (context, pos) => Container(
                              margin: EdgeInsets.only(bottom: 16),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        p[keys[pos]]['object'] == 'monetary'
                                            ? 'Monetary Promise'
                                            : p[keys[pos]]['object'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        p[keys[pos]]['time'],
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Quantity: ',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Text(
                                        '${p[keys[pos]]['quantity']} ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blueGrey),
                                      ),
                                      Text(
                                          '${p[keys[pos]]['unit'] == null ? '' : p[keys[pos]]['unit']}',
                                          style:
                                              TextStyle(color: Colors.black54)),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.pencilAlt,
                                          size: 18,
                                        ),
                                        color: Colors.grey,
                                        onPressed: () {
                                          editPromise(context, keys[pos],
                                              documentId, pos);
                                        },
                                      ),
                                      IconButton(
                                        color: Colors.red,
                                        icon: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          deletePromise(
                                              context, keys[pos], documentId);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[350],
                                      offset: Offset(4, 4),
                                      blurRadius: 24,
                                    )
                                  ]),
                            ),
                        itemCount: p.length),
                  ],
                ),
              );
            }));
  }
}
