import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myTexField(keyboard, controller, String labelText) {
  return TextField(
    keyboardType: keyboard,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
    ),
  );
}
