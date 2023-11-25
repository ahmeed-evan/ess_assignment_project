import 'package:ess_assignment_project/utils.dart';
import 'package:flutter/material.dart';

Widget cusTomTextInputField(
    {String? hintText,
    TextInputType? textInputType,
    bool? obscureText,
    required TextEditingController controller}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, strokeAlign: 1)),
    child: Column(
      children: [
        TextFormField(
          controller: controller,
          keyboardType: textInputType ?? TextInputType.text,
          obscureText: obscureText ?? false,
          decoration: InputDecoration.collapsed(
              hintText: hintText ?? "Input Text", hintStyle: hintTextStyle),
        ),
      ],
    ),
  );
}
