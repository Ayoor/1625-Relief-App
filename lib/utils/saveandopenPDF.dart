import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:relief_app/utils/timesheet_html.dart';

class SaveandOpenPDF{

  Future<File> savePDF(String docName, Document document) async {
    Directory? targetDirectory;

    // Check the platform
    if (Platform.isAndroid) {
      // Request storage permissions on Android
      final status = await Permission.storage.request();
      if (status.isGranted) {
        // Use the Downloads directory on Android
        targetDirectory = Directory('/storage/emulated/0/Download');
      } else {
        throw Exception("Storage permission not granted.");
      }
    } else if (Platform.isIOS) {
      // Use the app's document directory on iOS
      targetDirectory = await getApplicationDocumentsDirectory();
    }

    // Ensure the target directory is not null
    if (targetDirectory == null) {
      throw Exception("Could not determine the storage directory.");
    }

    // Ensure the directory exists
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    // Construct the file path
    final filePath = "${targetDirectory.path}/$docName.pdf";

    // Create a File instance
    final file = File(filePath);

    // Write the PDF bytes to the file
    await file.writeAsBytes(await document.save());

    // sendEmailWithAttachment(file);

    return file;
  }

  Future <void> openPDF(File file) async{
    final path = file.path;
    await OpenFile.open(path);
  }

  Future<void> sendEmailWithAttachment(File attachment) async {
    // SMTP Server Configuration
    String username = 'gbengajohn4god@gmail.com'; // Your email address
    String password = 'kdpe awvy jzaf sexs'; // Your email password or app-specific password (for Gmail)
    final smtpServer = gmail(username, password); // Gmail SMTP server

    // Compose the Email
    final message = Message()
      ..from = Address(username, '1625 relief') // Sender
      ..recipients.add('gbengajohn4god@yahoo.com') // Recipient
      ..subject = 'Your May 10-Jun 10 CEH Timesheet'
      ..html = TimeSheetHTML().htmlContent
      ..attachments.add(FileAttachment(attachment)); // Attach a file

    try {
      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {
      print('Failed to send email: $e');
    }
  }

}