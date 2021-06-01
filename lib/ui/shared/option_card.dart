import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OptionCard extends StatelessWidget {
  const OptionCard(
      {Key key,
      @required this.title,
      @required this.icon,
      this.iconColor = Colors.black,
      this.onTap})
      : super(key: key);
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        padding: EdgeInsets.symmetric(vertical: 16),
        style: NeumorphicStyle(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor,
              size: 40,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
