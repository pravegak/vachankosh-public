import 'package:flutter/material.dart';

class Dialogs {
  static void showAppDialog(BuildContext _context, Widget body,
      {bool isDismissible = false}) {
    showDialog(
      context: _context,
      barrierDismissible: isDismissible,
      builder: (context) => body,
    );
  }
}
