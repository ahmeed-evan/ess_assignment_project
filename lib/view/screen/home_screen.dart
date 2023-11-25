import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/screen/custom_order.dart';
import 'package:ess_assignment_project/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customButton(
                buttonText: "Custom Order ",
                onClickAction: () async {
                  if (context.mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomOrder(),
                        ));
                  }
                }),
            customSpacerHeight(height: 20),
            customButton(buttonText: "Feedback", onClickAction: () {}),
          ]),
    ));
  }
}
