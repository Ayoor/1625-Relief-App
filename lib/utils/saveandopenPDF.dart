import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class SaveandOpenPDF{

  Future<File> savePDF(String docName, Document document) async {
    // Determine the root directory based on the platform
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    if (root == null) {
      throw Exception("Could not determine the storage directory.");
    }

    // Construct the file path
    final filePath = "${root.path}/$docName.pdf";

    // Create a File instance
    final file = File(filePath);

    // Write the PDF bytes to the file
    await file.writeAsBytes(await document.save());

    return file;
  }

  Future <void> openPDF(File file) async{
    final path = file.path;
    await OpenFile.open(path);
  }
}