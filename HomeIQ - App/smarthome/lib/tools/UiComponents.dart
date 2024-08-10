import 'package:flutter/material.dart';

InputDecoration tbdecor({required String labelT}) {
  return InputDecoration(
      labelText: labelT,
      labelStyle: LabelTstlye(),
      filled: true,
      fillColor: Colors.white);
}

TextStyle LabelTstlye() {
  return TextStyle(color: Colors.grey, fontSize: 20);
}

TextStyle appTstyle() {
  return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

TextStyle buttonTstlye() {
  return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
}
