import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:relief_app/utils/timesheet_html.dart';

class SaveandOpenPDF {
  Future<File> savePDF(String docName, Document document) async {
    Directory? targetDirectory;

    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.manageExternalStorage.request();

      while (status.isDenied) {
        // Keep requesting permission
        status = await Permission.manageExternalStorage.request();
      }

      if (status.isGranted) {
        targetDirectory = Directory('/storage/emulated/0/Download');
      } else if (status.isPermanentlyDenied) {
        // Open settings if permission is permanently denied
        openAppSettings();
        throw Exception("Storage permission permanently denied. Please enable it in settings.");
      } else {
        throw Exception("Storage permission not granted.");
      }
    } else if (Platform.isIOS) {
      targetDirectory = await getApplicationDocumentsDirectory();
    }

    if (targetDirectory == null) {
      throw Exception("Could not determine the storage directory.");
    }

    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final filePath = "${targetDirectory.path}/$docName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await document.save());

    return file;
  }

  Future<void> openPDF(File file) async {
    await OpenFile.open(file.path);
  }

  Future<void> sendEmailWithAttachment(File attachment) async {
    String username = 'gbengajohn4god@gmail.com';
    String password = 'kdpe awvy jzaf sexs'; // Use an App Password instead of raw password

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, '1625 relief')
      ..recipients.add('gbengajohn4god@yahoo.com')
      ..subject = 'Your May 10-Jun 10 CEH Timesheet'
      ..html = TimeSheetHTML().htmlContent
      ..attachments.add(FileAttachment(attachment));

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }
}
