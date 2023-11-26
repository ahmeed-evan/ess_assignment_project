import 'dart:convert';

import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/init_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await initApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<List<dynamic>> products = Get.find<CustomOrderController>().csvFile;

  Map<String, dynamic> formValues = {
    "text_1": "",
    // Write your address
    "text_3": "",
    // Phone number
    "list_1": 1,
    // Your fav food (default value: Apples)
    "viewText_1": "",
    // Retail Price unit
    "viewText_2": "",
    // Cup Equivalent Unit
    "image_1":
        "https://static.vecteezy.com/system/resources/previews/011/307/643/original/avocado-slice-with-avatar-png.png",
    // Upload your image
    "text_2": 1,
    // How much unit you want to buy
  };

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process the data
      // You can access the formValues map to get the entered values
      print(formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Collection Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Build form fields dynamically based on the JSON
              for (var section in formSections)
                ...section['fields'].map<Widget>((field) {
                  return buildFormField(field);
                }),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFormField(Map<String, dynamic> field) {
    String fieldType = field['properties']['type'];
    String fieldKey = field['key'];

    switch (fieldType) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(
            labelText: field['properties']['label'],
            hintText: field['properties']['hintText'],
          ),
          onChanged: (value) {
            formValues[fieldKey] = value;
          },
          validator: (value) {
            if (field['properties']['minLength'] != null &&
                value!.length < field['properties']['minLength']) {
              return 'Value must be at least ${field['properties']['minLength']} characters';
            }
            if (field['properties']['maxLength'] != null &&
                value!.length > field['properties']['maxLength']) {
              return 'Value must be at most ${field['properties']['maxLength']} characters';
            }
            return null;
          },
        );
      case 'dropDownList':
        String? jsonString = field['properties']['listItems'];
        List<Map<dynamic, dynamic>> itemList = List<Map<dynamic, dynamic>>.from(
            jsonDecode(jsonString!).map((item) => {
                  'name': item['name'],
                  'value': item['value'],
                }));
        List<Map<dynamic, dynamic>> listItems =
            List<Map<dynamic, dynamic>>.from(
                itemList.map((item) => Map.from(item)));

        return DropdownButtonFormField(
          value: formValues[fieldKey],
          items: listItems.map((item) {
            return DropdownMenuItem(
              value: item['value'],
              child: Text(item['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              formValues[fieldKey] = value;
              updateValueMapping(fieldKey, value);
            });
          },
          decoration: InputDecoration(
            labelText: field['properties']['label'],
            hintText: field['properties']['hintText'],
          ),
        );

      case 'viewText':
        return Text(
          "${field['properties']['label']} :: ${formValues[fieldKey]}",
        );
      case 'imageView':
        return Image.network(
          formValues[fieldKey],
          height: 100,
        );
      case 'numberText':
        return TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: field['properties']['label'],
            hintText: field['properties']['hintText'],
          ),
          onChanged: (value) {
            formValues[fieldKey] = int.tryParse(value) ?? 0;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is required';
            }
            return null;
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void updateValueMapping(String fieldKey, dynamic value) {
    for (var mapping in formValueMapping) {
      for (var search in mapping['searchList']) {
        if (search['fieldKey'] == fieldKey) {
          for (var display in mapping['displayList']) {
            formValues[display['fieldKey']] = getProductFieldValue(
                value, search['dataColumn'], display['dataColumn']);
            print(formValues[display['fieldKey']] = getProductFieldValue(
                value, search['dataColumn'], display['dataColumn']));
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
    setState(() {});
    return "Value Not found";
  }

  List<Map<String, dynamic>> formSections = [
    {
      "name": "Details section",
      "key": "section_1",
      "fields": [
        {
          "id": 1,
          "key": "text_1",
          "properties": {
            "type": "text",
            "defaultValue": "",
            "hintText": "ex : Puran dhaka",
            "minLength": 0,
            "maxLength": 150,
            "label": "Write your address",
          },
        },
        {
          "id": 7,
          "key": "text_3",
          "properties": {
            "type": "text",
            "defaultValue": "",
            "hintText": "ex : 01XXXXXXXX",
            "minLength": 0,
            "maxLength": 11,
            "label": "Phone number",
          },
        },
        {
          "id": 2,
          "key": "list_1",
          "properties": {
            "type": "dropDownList",
            "defaultValue": "2022",
            "hintText": "Select one from the list",
            "label": "Your fav food",
            "listItems":
                "[{\"name\":\"Apples\",\"value\":1},{\"name\":\"Bananas\",\"value\":9},{\"name\":\"Blackberries\",\"value\":11},{\"name\":\"Cherries\",\"value\":16},{\"name\":\"Dates\",\"value\":20},{\"name\":\"Grapes\",\"value\":26}]",
          },
        },
        {
          "id": 3,
          "key": "viewText_1",
          "properties": {
            "type": "viewText",
            "defaultValue": "",
            "label": "Retail Price unit",
          },
        },
        {
          "id": 4,
          "key": "viewText_2",
          "properties": {
            "type": "viewText",
            "defaultValue": "",
            "label": "Cup Equivalent Unit",
          },
        },
        {
          "id": 5,
          "key": "image_1",
          "properties": {
            "type": "imageView",
            "defaultValue":
                "https://static.vecteezy.com/system/resources/previews/011/307/643/original/avocado-slice-with-avatar-png.png",
            "label": "Upload your image",
          },
        },
        {
          "id": 6,
          "key": "text_2",
          "properties": {
            "type": "numberText",
            "defaultValue": 1,
            "hintText": "ex : 1",
            "label": "How much unit you want to buy",
          },
        },
      ],
    },
  ];

  List<Map<String, dynamic>> formValueMapping = [
    {
      "searchList": [
        {
          "fieldKey": "list_1",
          "dataColumn": "ProductCode",
        },
      ],
      "displayList": [
        {
          "fieldKey": "viewText_1",
          "dataColumn": "RetailPriceUnit",
        },
        {
          "fieldKey": "viewText_2",
          "dataColumn": "CupEquivalentUnit",
        },
        {
          "fieldKey": "image_1",
          "dataColumn": "ProductImage",
        },
      ],
    },
  ];
}
