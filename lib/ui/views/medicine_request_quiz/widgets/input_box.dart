import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final Function onTap;
  final String hintText;
  final String errorText;
  final Function(String value) validator;
  final Icon icon;
  final int maxLines;
  final TextInputType keyboard;
  final bool readOnly;
  final bool enabled;
  const InputBox({
    Key key,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.maxLines,
    this.errorText,
    this.validator,
    this.controller,
    this.keyboard = TextInputType.text,
    this.hintText,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            onTap: onTap,
            enabled: enabled,
            readOnly: readOnly,
            validator: validator,
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
                errorText: errorText,
                border: InputBorder.none,
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.black, width: 2),
                //   borderRadius: BorderRadius.circular(0.0),
                // ),
                // disabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey),
                //   borderRadius: BorderRadius.circular(0.0),
                // ),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey),
                //   borderRadius: BorderRadius.circular(0.0),
                // ),
                labelText: hintText,
                icon: icon),
          ),
          Divider(),
        ],
      ),
    );
  }
}
