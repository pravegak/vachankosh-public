import 'package:flutter/material.dart';

class DividerWithoutPadding extends StatelessWidget {
  const DividerWithoutPadding({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      height: 0.5,
    );
  }
}