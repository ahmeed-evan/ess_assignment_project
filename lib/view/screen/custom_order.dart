import 'dart:convert';

import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/model/form_data.dart';
import 'package:ess_assignment_project/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils.dart';

class CustomOrder extends StatelessWidget {
  CustomOrder({super.key});

  final _formkey = GlobalKey<FormState>();

  Map<String, dynamic> formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    Get.put(CustomOrderController());

    return Scaffold(
      floatingActionButton: _floatingButton(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: Get.find<CustomOrderController>().loadFormData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "${snapshot.error} occurred",
                  style: defaultTextStyle,
                ),
              );
            } else if (snapshot.hasData) {
              return _loadForm(snapshot.data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
    );
  }

  Widget _loadForm(DynamicFormData dynamicFormData) {
    return Form(
      key: _formkey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: buildFormFields(dynamicFormData),
      ),
    );
  }

  List<Widget> buildFormFields(DynamicFormData dynamicFormData) {
    List<Widget> formFields = [];
    for (var field in dynamicFormData.sections![0].fields!) {
      String key = field.key!;
      Properties? properties = field.properties;

      switch (properties?.type) {
        case 'text':
          formFields.add(
            TextFormField(
              decoration: InputDecoration(
                labelText: properties?.label ?? "",
                hintText: properties?.hintText,
              ),
              maxLength: properties?.maxLength,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              onSaved: (value) {
                formData[key] = value;
              },
            ),
          );
          break;

        case 'dropDownList':
          String? jsonString = properties?.listItems;
          List<Map<dynamic, dynamic>> itemList =
              List<Map<dynamic, dynamic>>.from(
                  jsonDecode(jsonString!).map((item) => {
                        'name': item['name'],
                        'value': item['value'],
                      }));
          List<Map<dynamic, dynamic>> listItems =
              List<Map<dynamic, dynamic>>.from(
                  itemList.map((item) => Map.from(item)));

          formFields.add(
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: properties?.label,
                hintText: properties?.hintText,
              ),
              items: listItems
                  .map((item) => DropdownMenuItem(
                        value: item['value'],
                        child: Text(item['name']),
                      ))
                  .toList(),
              onChanged: (value) {
                formData[key] = value;
                _getValuesFromCSVFile(value as int);
              },
            ),
          );
          break;

        case 'viewText':
          formFields.add(_viewTextFiled(key, properties!,dynamicFormData));
          break;

        case 'imageView':
          formFields.add(imageViewFiled(properties!));
          break;
        case 'numberText':
          formFields.add(numberTextFiled(properties!));
          break;
        default:
          formFields.add(Container());
          break;
      }
    }

    return formFields;
  }

  Widget imageViewFiled(Properties properties) {
    return Obx(() => SizedBox(
          height: 140,
          width: 140,
          child: Get.find<CustomOrderController>().imageUrl.value == ""
              ? Image.network(properties.defaultValue, fit: BoxFit.fill)
              : Image.network(Get.find<CustomOrderController>().imageUrl.value,
                  fit: BoxFit.fitWidth),
        ));
  }

  _floatingButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: customButton(
          buttonText: "Confirm Order",
          onClickAction: () {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              // Process or submit the form data
              print(formData);
            }
          }),
    );
  }

  Widget _viewTextFiled(String key, Properties properties,DynamicFormData dynamicFormData) {

    Get.find<CustomOrderController>().getValue("",1);
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(properties?.label ?? ""),
            Text(key == "viewText_1"
                ? Get.find<CustomOrderController>().retailsUnitPrice.value
                : Get.find<CustomOrderController>().cupEquivalentUnit.value)
          ],
        ));
  }

  void _getValuesFromCSVFile(int value) {
    Get.find<CustomOrderController>().retailsUnitPrice.value =
        Get.find<CustomOrderController>().getValue("RetailPriceUnit", value);
    Get.find<CustomOrderController>().cupEquivalentUnit.value =
        Get.find<CustomOrderController>().getValue("CupEquivalentUnit", value);
    Get.find<CustomOrderController>().imageUrl.value =
        Get.find<CustomOrderController>().getValue("ProductImage", value);
  }
}

Widget numberTextFiled(Properties properties) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [Text(properties?.label ?? ""), _unitLayout()],
  );
}

_unitLayout() {
  return Row(
    children: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.remove)),
      Text("1"),
      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
    ],
  );
}
