// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// class InvoiceScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Invoice'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             // Generate PDF invoice
//             final Uint8List pdfBytes = generateInvoice() as Uint8List;
//
//             // Send email with PDF attachment
//             await sendEmailWithAttachment(pdfBytes);
//           },
//           child: Text('Send Invoice'),
//         ),
//       ),
//     );
//   }
//
//   Future<Uint8List> generateInvoice() {
//     final pw.Document pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text('Your Invoice Content Here'),
//           );
//         },
//       ),
//     );
//
//     return pdf.save();
//   }
//
//   Future<void> sendEmailWithAttachment(Uint8List attachment) async {
//     // Replace these values with your email and SMTP server configuration
//     final String username = 'your_email@gmail.com';
//     final String password = 'your_email_password';
//     final String recipient = 'customer_email@example.com';
//
//     final smtpServer = gmail(username, password);
//
//     final message = Message()
//       ..from = Address(username, 'Your Name')
//       ..recipients.add(recipient)
//       ..subject = 'Invoice'
//       ..html = 'Attached is your invoice.'
//       ..attachments.add(FileAttachment('invoice.pdf', attachment));
//
//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ${sendReport.sent}');
//     } catch (e) {
//       print('Error sending email: $e');
//     }
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: InvoiceScreen(),
//   ));
// }
