import 'package:e_commerce_2/const/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customButton(String label, onPressed, icon) {
  return ElevatedButton.icon(
    style: ButtonStyle(
      shadowColor: MaterialStateProperty.all(Colors.orange),
      backgroundColor: MaterialStateProperty.all(AppColor.lightOrange),
    ),
    onPressed: onPressed,
    icon: Icon(
      icon,
      color: Colors.white,
    ),
    label: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
  );
}
