import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_styles.dart';

class EditTextBottomSheet extends StatefulWidget {
  EditTextBottomSheet(
      {Key key,
      @required this.heading,
      @required this.textEditingController,
      @required this.onSave,
      this.validator})
      : super(key: key);

  final TextEditingController textEditingController;
  final String heading;
  final Function onSave;
  final Function(String) validator;

  @override
  _EditTextBottomSheetState createState() => _EditTextBottomSheetState();
}

class _EditTextBottomSheetState extends State<EditTextBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.heading,
              style: AppStyles.k16BlackHeading,
            ),
            SizedBox(
              height: 8,
            ),
            Form(
              autovalidate: _autoValidate,
              key: _formKey,
              child: TextFormField(
                validator: widget.validator,
                autofocus: true,
                controller: widget.textEditingController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: Colors.blue,
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  textColor: Colors.blue,
                  child: const Text('SAVE'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await widget.onSave();
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}