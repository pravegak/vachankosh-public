import 'package:flutter/material.dart';
import 'package:vachankosh/constants/app_colors.dart';

class AppStyles {
  static const k16BlueHeading = const TextStyle(
      color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w500);
  static const k16LightBlueText = const TextStyle(
      color: Colors.lightBlue, fontSize: 16, fontWeight: FontWeight.w500);
  static const k20BlueHeading = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primaryColor);
  static const k24BlueHeading = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primaryColor);
  static const k20BlackHeading =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const k16BlackHeading =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const kLightItalicText =
      const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic);
  static const kBlueGreyText = const TextStyle(color: Colors.blueGrey);
}
