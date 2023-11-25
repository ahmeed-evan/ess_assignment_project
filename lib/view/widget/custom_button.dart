import 'package:ess_assignment_project/utils.dart';
import 'package:flutter/material.dart';

Widget customButton(
    {required String buttonText, required Function onClickAction}) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
        onPressed: () => onClickAction(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(
          buttonText,
          style: defaultTextStyle.copyWith(color: Colors.white),
        )),
  );
}
