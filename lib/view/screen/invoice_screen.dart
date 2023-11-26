import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  Map<String, dynamic> formValues;

  InvoiceScreen(this.formValues, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
        child: Column(
          children:formValues.values.map((e) => Text("$e")).toList(),
        ));
  }
}




