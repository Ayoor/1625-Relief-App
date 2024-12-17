import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

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

    print("File saved to: $filePath");
    return file;
  }
  Future <void> openPDF(File file) async{
    final path = file.path;
    await OpenFile.open(path);
  }
}