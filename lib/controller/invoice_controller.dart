import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class InvoiceController extends GetxController {
  File? pdfFile;

  Future<void> sendInvoiceToUser(Map<String, dynamic> pdfMap) async {
    final tempPath = await _getTempPath();
    final filePath =
        '$tempPath/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';
    print(filePath);
    await _savePdf(filePath, pdfMap);
    sendEmailWithAttachment();
  }

  Future<String?> _getTempPath() async {
    try {
      final tempDir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getTemporaryDirectory();
      return tempDir.path;
    } catch (err) {
      print("Error getting temp directory: $err");
      return null;
    }
  }

  Future<void> savePdfInLocalStorage(Map<String, dynamic> pdfMap) async {
    PermissionStatus permissionStatus;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt > 32) {
        permissionStatus = await Permission.photos.request();
      } else {
        permissionStatus = await Permission.storage.request();
      }
    } else {
      permissionStatus = await Permission.storage.request();
    }

    if (permissionStatus.isGranted) {
      final savingPath = await _getSavingPath();
      final filePath =
          '$savingPath/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf';
      await _savePdf(filePath, pdfMap);
    } else {
      print("Permission denied");
    }
  }

  pw.TableRow _itemInfoLayout(Map<String, dynamic> pdfMap, String key) {
    return pw.TableRow(children: [
      pw.Text(key.toString(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Text(pdfMap[key].toString(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
    ]);
  }

  Future<void> _savePdf(String filePath, Map<String, dynamic> pdfMap) async {
    print(pdfMap);
    pw.Document pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (context) => pw.Table(
        children:
            pdfMap.keys.map((key) => _itemInfoLayout(pdfMap, key)).toList(),
      ),
    ));

    final Uint8List bytes = await pdf.save();
    final file = File(filePath);
    pdfFile = await file.writeAsBytes(bytes);
    print(pdfFile?.path);
  }

  Future<void> sendEmailWithAttachment() async {
    final smtpServer = SmtpServer('smtp-relay.brevo.com',
        username: 'ahmeed.3826@gmail.com',
        password: 'Zz7GyV5Oqw0X8fAN',
        port: 587,
        ssl: false,
        allowInsecure: true);

    final message = Message()
      ..from = const Address('ahmeed.3826@gmail.com', 'Evan Ahmed')
      ..recipients.add('ahmeed.evan@gmail.com')
      ..subject = 'Invoice'
      ..html = 'Check your Invoice in the attachment section'
      ..attachments.add(FileAttachment(pdfFile!));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      print('Response: ${sendReport.toString()}');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String?> _getSavingPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        print(directory.path);
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
