import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get defaultTextStyle => GoogleFonts.poppins(
    color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal);

TextStyle get hintTextStyle => GoogleFonts.poppins(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

SizedBox customSpacerHeight({required double height}) =>
    SizedBox(height: height);

SizedBox customSpacerWidth({required double width}) => SizedBox(width: width);

successToast({required String successMessage}) {
  return Fluttertoast.showToast(
      msg: successMessage,
      backgroundColor: Colors.green.shade200,
      textColor: Colors.white);
}

errorToast({required String errorMessage}) {
  return Fluttertoast.showToast(
      msg: errorMessage,
      backgroundColor: Colors.red.shade200,
      textColor: Colors.white);
}

ThemeData get themeData => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: defaultTextStyle,
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true
    ));

BoxDecoration get defaultBoxDecoration => BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8));

final TextEditingController emailInputController = TextEditingController();
final TextEditingController passInputController = TextEditingController();
