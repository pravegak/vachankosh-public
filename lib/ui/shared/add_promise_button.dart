import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vachankosh/utils/objects/promise.dart';

Future<Promise> showPromisePopUp(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController itemNameController,
  TextEditingController quantityController,
  TextEditingController unitController,
  String timeDropDownValue, {
  bool update = false,
}) async {
  return showDialog<Promise>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Promise Details"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(update ? "Update" : "Add"),
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (formKey.currentState.validate()) {
                  Navigator.pop(
                    context,
                    Promise(
                        itemNameController.text,
                        int.parse(quantityController.text),
                        timeDropDownValue,
                        unitController.text),
                  );
                } else {
                  //AutoValidate
                }
              },
            ),
          ],
          content: StatefulBuilder(
            builder: (context, setDialogState) => Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (itemNameController.text != 'monetary')
                        TextFormField(
                          validator: (String value) {
                            if (value.length < 3) {
                              return "Please enter the item name";
                            }
                            return null;
                          },
                          controller: itemNameController,
                          decoration: InputDecoration(
                            labelText: "Item Name*",
                            hintText: "eg: sanitary pads",
                            prefixIcon: Icon(
                              Icons.card_giftcard,
                            ),
                          ),
                        ),
                      TextFormField(
                        validator: (String value) {
                          if (int.tryParse(value) == null ||
                              int.tryParse(value) < 1) {
                            return "Quantity should be greater than 0";
                          }
                          return null;
                        },
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: "Quantity*",
                          prefixIcon: Icon(
                            FontAwesomeIcons.cloudscale,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      if (itemNameController.text != 'monetary')
                        TextFormField(
                          controller: unitController,
                          decoration: InputDecoration(
                            labelText: "Unit",
                            hintText: "(like boxes, hours etc.)",
                            prefixIcon: Icon(
                              Icons.ac_unit,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Promise Plan",
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (String value) {
                          if (value == "Choose Plan") {
                            return "Please select a promise plan";
                          }
                          return null;
                        },
                        isExpanded: true,
                        value: timeDropDownValue,
                        onChanged: (String newValue) {
                          setDialogState(() {
                            timeDropDownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Choose Plan',
                          'Monthly',
                          'Quarterly',
                          'Yearly'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
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
}

class AddPromiseButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function onAdd;

  const AddPromiseButton({Key key, this.formKey, @required this.onAdd})
      : super(key: key);

  @override
  _AddPromiseButtonState createState() => _AddPromiseButtonState();
}

class _AddPromiseButtonState extends State<AddPromiseButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text('Add Promise'),
      icon: Icon(FontAwesomeIcons.gratipay),
      onPressed: () async {
        var itemNameController = TextEditingController();
        var quantityController = TextEditingController();
        var unitController = TextEditingController();
        var timeDropDownValue = 'Choose Plan';

        Promise newPromise = await showPromisePopUp(
            context,
            widget.formKey,
            itemNameController,
            quantityController,
            unitController,
            timeDropDownValue);

        if (newPromise != null) {
          widget.onAdd(newPromise);
        }
      },
    );
  }
}
