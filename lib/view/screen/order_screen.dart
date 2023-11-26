import 'dart:convert';

import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/model/form_data.dart';
import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/screen/home_screen.dart';
import 'package:ess_assignment_project/view/screen/invoice_screen.dart';
import 'package:ess_assignment_project/view/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<List<dynamic>> products = Get.find<CustomOrderController>().csvFile;

  DynamicFormData dynamicFormData =
      Get.find<CustomOrderController>().dynamicFormData;
  Map<String, dynamic> formData = <String, dynamic>{};

  //try to put it inside getx
  Map<String, dynamic> formValues = {};

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceScreen(
              formValues,
            ),
          ));
      print(formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (formValues.keys.isEmpty) {
                Navigator.pop(context);
              } else {
                backWarningDialog();
              }
            },
            icon: const Icon(CupertinoIcons.back)),
        centerTitle: true,
        title: Text(dynamicFormData.formName ?? "Order Collection Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ...dynamicFormData!.sections![0].fields!
                  .map((Fields fields) => buildFormField(fields))
                  .toList(),
              _placeOrderButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormField(Fields field) {
    String? fieldType = field.properties?.type;
    String fieldKey = field.key!;

    switch (fieldType) {
      case 'text':
        return _customTextInputField(field);

      case 'dropDownList':
        return _customDropdown(field);

      case 'viewText':
        return _customTextView(field);
      case 'imageView':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.network(
            formValues[fieldKey] == null || formValues[fieldKey] == ""
                ? field.properties?.defaultValue
                : formValues[fieldKey],
            height: 100,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        );
      case 'numberText':
        return _customNumberInputField(field);
      default:
        return const SizedBox.shrink();
    }
  }

  void updateValueMapping(String fieldKey, dynamic value) {
    for (ValueMapping mapping in dynamicFormData.valueMapping!) {
      for (var search in mapping.searchList!) {
        if (search.fieldKey == fieldKey) {
          for (var display in mapping.displayList!) {
            formValues[display.fieldKey!] = getProductFieldValue(
                value, search.dataColumn!, display.dataColumn!);
          }
        }
      }
    }
  }

  dynamic getProductFieldValue(
      dynamic productCode, String searchColumn, String displayColumn) {
    int productCodeIndex = products[0].indexOf(searchColumn);
    int displayColumnIndex = products[0].indexOf(displayColumn);

    for (int i = 1; i < products.length; i++) {
      if (products[i][productCodeIndex] == productCode) {
        return products[i][displayColumnIndex];
      }
    }
    return "Value Not found";
  }

  Widget _customTextInputField(Fields field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: defaultBoxDecoration,
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: field.properties?.label,
          hintText: field.properties?.hintText,
        ),
        onChanged: (value) {
          formValues[field.key!] = value;
        },
        validator: (value) {
          if (field.properties?.minLength != null &&
              value!.length < field.properties!.minLength!) {
            return 'Value must be at least ${field.properties?.minLength} characters';
          }
          if (field.properties?.maxLength != null &&
              value!.length > field.properties!.maxLength!) {
            return 'Value must be at most ${field.properties?.maxLength} characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _customTextView(Fields field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: defaultBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${field.properties?.label} :: ",
          ),
          Text(
            "${formValues[field.key] ?? ""}",
          )
        ],
      ),
    );
  }

  Widget _customNumberInputField(Fields field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: defaultBoxDecoration,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: field.properties?.label,
          hintText: field.properties?.hintText,
        ),
        onChanged: (value) {
          formValues[field.key!] = int.tryParse(value) ?? 0;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Value is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _customDropdown(Fields field) {
    String? jsonString = field.properties?.listItems;
    List<Map<dynamic, dynamic>> itemList =
        List<Map<dynamic, dynamic>>.from(jsonDecode(jsonString!).map((item) => {
              'name': item['name'],
              'value': item['value'],
            }));
    List<Map<dynamic, dynamic>> listItems = List<Map<dynamic, dynamic>>.from(
        itemList.map((item) => Map.from(item)));

    return Container(
      decoration: defaultBoxDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField(
        items: listItems.map((item) {
          return DropdownMenuItem(
            value: item['value'],
            child: Text(item['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            formValues[field.key!] = getNameByValue(listItems, value as int);
            updateValueMapping(field.key!, value);
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: field.properties?.label,
          hintText: field.properties?.hintText,
        ),
      ),
    );
  }

  Widget _placeOrderButton() {
    return customButton(buttonText: "Place Order", onClickAction: _onSubmit);
  }

  String? getNameByValue(List<Map<dynamic, dynamic>> list, int targetValue) {
    for (var fruit in list) {
      if (fruit["value"] == targetValue) {
        return fruit["name"];
      }
    }
    return null; // Return null if no match is found
  }

  Future backWarningDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: AlertDialog(
            title: const Text("Unsaved data will be removed"),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ok")),
                    ),
                    customSpacerWidth(width: 4),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false);
                            },
                            child: const Text("Home")))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
