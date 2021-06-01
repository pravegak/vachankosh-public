import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vachankosh/ui/shared/add_promise_button.dart';
import 'package:vachankosh/utils/objects/promise.dart';
import 'package:vachankosh/viewmodels/volunteer_quiz_model.dart';

final _promiseInputFormKey = GlobalKey<FormState>();

class OtherPromiseQuesWidget extends StatefulWidget {
  const OtherPromiseQuesWidget({
    Key key,
  }) : super(key: key);

  @override
  _OtherPromiseQuesWidgetState createState() => _OtherPromiseQuesWidgetState();
}

class _OtherPromiseQuesWidgetState extends State<OtherPromiseQuesWidget> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<VolunteerQuizModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: model.otherPromises
                .map(
                  (Promise promise) => Card(
                    color: Colors.amber[100],
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                var itemNameController = TextEditingController()
                                  ..text = promise.object;
                                var quantityController = TextEditingController()
                                  ..text = "${promise.quantity}";
                                var unitController = TextEditingController()
                                  ..text = promise.unit;
                                var dropDownValue = promise.time;

                                Promise newPromise = await showDialog<Promise>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Promise Details"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Update"),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              if (_promiseInputFormKey
                                                  .currentState
                                                  .validate()) {
                                                model
                                                    .setAutoValidateForm(false);
                                                Navigator.pop(
                                                  context,
                                                  Promise(
                                                      itemNameController.text,
                                                      int.parse(
                                                          quantityController
                                                              .text),
                                                      dropDownValue,
                                                      unitController.text),
                                                );
                                              } else {
                                                model.setAutoValidateForm(true);
                                              }
                                            },
                                          ),
                                        ],
                                        content: StatefulBuilder(
                                          builder: (context, setDialogState) =>
                                              Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: SingleChildScrollView(
                                              child: Form(
                                                key: _promiseInputFormKey,
                                                autovalidate: model
                                                    .autoValidatePromiseForm,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    TextFormField(
                                                      validator:
                                                          (String value) {
                                                        if (value.length < 3) {
                                                          return "Please enter the item name";
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          itemNameController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Item Name*",
                                                        hintText:
                                                            "eg: sanitary pads",
                                                        prefixIcon: Icon(
                                                          Icons.card_giftcard,
                                                        ),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      validator:
                                                          (String value) {
                                                        if (int.tryParse(
                                                                    value) ==
                                                                null ||
                                                            int.tryParse(
                                                                    value) <=
                                                                0) {
                                                          return "Quantity can't be less than 0";
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          quantityController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Quantity*",
                                                        prefixIcon: Icon(
                                                          Icons.compare_arrows,
                                                        ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          unitController,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Unit (like boxes, hours etc.)",
                                                        prefixIcon: Icon(
                                                          Icons.ac_unit,
                                                        ),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      "Promise Plan",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      validator:
                                                          (String value) {
                                                        if (value ==
                                                            "Choose Plan") {
                                                          return "Please select a promise plan";
                                                        }
                                                        return null;
                                                      },
                                                      isExpanded: true,
                                                      value: dropDownValue,
                                                      onChanged:
                                                          (String newValue) {
                                                        setDialogState(() {
                                                          dropDownValue =
                                                              newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'Choose Plan',
                                                        'Monthly',
                                                        'Quarterly',
                                                        'Yearly'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                if (newPromise != null) {
                                  model.editPromise(promise, newPromise);
                                }
                              }),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                model.removePromise(promise);
                              }),
                        ],
                      ),
                      leading: Icon(Icons.album),
                      title: Text(promise.object),
                      contentPadding: EdgeInsets.all(5.0),
                      subtitle: Text(
                          "${promise.quantity.toString()} ${promise.unit == null ? '' : promise.unit}\n${promise.time}"),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 10),
          AddPromiseButton(
            formKey: _promiseInputFormKey,
            onAdd: (Promise newPromise) => model.addOtherPromise(newPromise),
          ),
        ],
      ),
    );
  }
}
