import 'package:ess_assignment_project/controller/custom_order_controller.dart';
import 'package:ess_assignment_project/controller/invoice_controller.dart';
import 'package:ess_assignment_project/model/form_data.dart';
import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/screen/pdf_downloader_helper.dart';
import 'package:ess_assignment_project/view/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceScreen extends StatelessWidget {
  Map<String, dynamic> formValues;

  InvoiceScreen(this.formValues, {super.key});

  Map<String, dynamic> pdfMap = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invoice",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back)),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            ...formValues.keys.map((key) => _itemInfoLayout(key)).toList(),
            customSpacerHeight(height: 40),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: customButton(
                        buttonText: "Save Invoice",
                        onClickAction: () async{
                          await Get.find<InvoiceController>().savePdf(pdfMap);
                        })),
                customSpacerWidth(width: 8),
                Expanded(
                    child: customButton(
                        buttonText: "Send Mail", onClickAction: () {
                          Get.find<InvoiceController>().sendEmailWithAttachment();
                    })),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? getLabelByKey(String key) {
    for (var section
        in Get.find<CustomOrderController>().dynamicFormData.sections!) {
      var fields = section.fields!;
      for (var field in fields) {
        if (field.key == key) {
          return field.properties?.label;
        }
      }
    }
    return null; // Return null if no match is found
  }

  Widget _itemInfoLayout(String key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(getLabelByKey(key) ?? "Item::"),
        key == "image_1"
            ? Image.network(
                formValues[key].toString(),
                height: 90,
                width: 90,
              )
            : Text(formValues[key].toString())
      ],
    );
  }
}
