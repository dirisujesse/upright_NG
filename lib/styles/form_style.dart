import 'package:Upright_NG/styles/colors.dart';
import 'package:flutter/material.dart';
// import 'colors.dart';

const formInputStyle = InputDecoration();
const underlineInputStyle = InputDecoration(
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: appGreen, width: 2)
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: appGreen, width: 3)
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: appRed, width: 3)
  ),
);