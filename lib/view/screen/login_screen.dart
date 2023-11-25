import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/custom_button.dart';
import '../widget/custom_text_inputfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _logoText(),
            customSpacerHeight(height: 30),
            _emailInoutField(),
            customSpacerHeight(height: 20),
            _passwordInputField(),
            customSpacerHeight(height: 30),
            _loginButton(context)
          ],
        ),
      ),
    );
  }

  _logoText() =>
      Center(child: Text("Frutter", style: GoogleFonts.anton(fontSize: 42)));

  _emailInoutField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: defaultTextStyle,
        ),
        customSpacerHeight(height: 10),
        cusTomTextInputField(
            hintText: "Enter Email Address", controller: emailInputController),
      ],
    );
  }

  _passwordInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: defaultTextStyle,
        ),
        customSpacerHeight(height: 10),
        cusTomTextInputField(
            hintText: "Enter Password",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passInputController),
      ],
    );
  }

  _loginButton(BuildContext context) =>
      customButton(buttonText: "Login", onClickAction: loinAction);

  loinAction(BuildContext context) {

    if (emailInputController.text.isNotEmpty ||
        passInputController.text.isNotEmpty) {
      if (emailInputController.text == "esssumon@gmail.com" &&
          passInputController.text == "admin") {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));

      } else {
        errorToast(errorMessage: "Invalid login");
      }
    } else {
      errorToast(errorMessage: "Provide a valid input");
    }
  }
}
