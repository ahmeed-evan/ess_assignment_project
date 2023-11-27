import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceController extends GetxController {
  File? pdfFile;

  pw.TableRow _itemInfoLayout(Map<String, dynamic> pdfMap, String key) {
    return pw.TableRow(children: [
      pw.Text(key.toString(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Text(pdfMap[key].toString(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    ]);
  }

  Future<void> savePdf(Map<String, dynamic> pdfMap) async {
    pw.Document pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) =>
          pw.Table(
            children:
            pdfMap.keys.map((key) => _itemInfoLayout(pdfMap, key)).toList(),
          ),
    ));

    final Uint8List bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final file = File(
        '$tempPath/${DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()}.pdf');
    // final file = File('/storage/emulated/0/Download/example.pdf');
    pdfFile = await file.writeAsBytes(bytes);
    print(pdfFile?.path);
  }

  // Future<void> sendEmailWithAttachment() async {
  //   final smtpServer = gmail('ahmeed.evan.3826@gmail.com', 'evan3826');
  //
  //   final message = Message()
  //     ..from = Address()
  //     ..recipients.add('ahmeed.evan@gmail.com')
  //     ..subject = 'Invoice'
  //     ..html = 'Please find attached the invoice.';
  //     // ..attachments.add(FileAttachment(
  //     //   File('invoice.pdf')
  //     //     ..writeAsBytesSync(pdfBytes),
  //     //   fileName: 'invoice.pdf',
  //     // ));
  //
  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     print('Message not sent. ${e.message}');
  //   }
  // }


  Future<void> sendEmailWithAttachment() async {
    // Replace these values with your email and SMTP server configuration
    final String username = 'test.mail.demo3826@gmail.com';
    final String password = 'Test00@@';
    final String recipient = 'ahmeed.evan@gmail.com';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(recipient)
      ..subject = 'Invoice'
      ..html = 'Attached is your invoice.';
      // ..attachments.add(FileAttachment('invoice.pdf', attachment));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}