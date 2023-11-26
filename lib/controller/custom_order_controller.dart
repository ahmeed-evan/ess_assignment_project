import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/form_data.dart';

class CustomOrderController extends GetxController {
  late List<List<dynamic>> csvFile;
  late DynamicFormData dynamicFormData;

  Future<DynamicFormData> loadFormData() async {
    final jsonString = await rootBundle.loadString("assets/api_reponse.json");
    DynamicFormData.fromJson(json.decode(jsonString));
    return DynamicFormData.fromJson(json.decode(jsonString));
  }

  Future<List<List<dynamic>>> loadCSV() async {
    final rawData = await rootBundle.loadString("assets/Fruit Prices.csv");
    List<List> value = const CsvToListConverter().convert(rawData);
    return value;
  }

  String getValue(String columnName, int productCode) {
    // Get the index of the ProductCode column
    int productCodeIndex = csvFile[0].indexOf("ProductCode");

    int columnIndex = csvFile[0].indexOf(columnName);

    // Iterate through the products to find the desired entry
    for (int i = 1; i < csvFile.length; i++) {
      if (csvFile[i][productCodeIndex] == productCode) {
        return csvFile[i][columnIndex].toString();
      }
    }
    return "Value Not Found";
  }

  @override
  void onInit() async {
    csvFile = await loadCSV();
    dynamicFormData = await loadFormData();
    super.onInit();
  }
}
