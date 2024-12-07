import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:relief_app/utils/saveandopenPDF.dart';

class PdfApi {
  final String name;
  final String range;
  List<List<String>> data;
  double total;

  PdfApi({required this.name, required this.range, required this.data, required this.total});

  Future<File> generateSimplePdf() async {
    final pdf = Document();
    pdf.addPage(
      Page(build: (Context context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
        Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
        Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Charles England House",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text("RELIEF WORK - TIME SHEET ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ]) ),
        SizedBox(height: 10),
        Text("Name: $name"),
        Padding(padding: EdgeInsets.symmetric(vertical: 10), child:Text("Month: $range"), ),

        Text("Pay rate:"),
        SizedBox(height: 20),
        TableHelper.fromTextArray(
        data: data,
        headers: ["DATE", "START TIME", "LUNCH BREAK",
        "END TIME ", "HOURS WORKED "],
        cellAlignment: Alignment.center,
        border: TableBorder.all(width: 1, color: PdfColors.grey),
        tableWidth: TableWidth.max,
        headerStyle: TextStyle(
        fontSize: 11, fontWeight: FontWeight.bold,
        ),
        ),
        Table(
          border: TableBorder.all(width: 1, color: PdfColors.grey),
        columnWidths: const {
        0: FlexColumnWidth(2.86), // Project column (wider)
        1: FlexColumnWidth(1), // Total Hours column// Income column
        },
          children: [
            TableRow(children: [
              Padding(padding: EdgeInsets.all(10), child:
              Text("TOTAL NUMBER OF HOURS WORKED"),
              ),

              Padding(padding: EdgeInsets.all(10), child:
              Text("$total"),
              )
            ]),
          ]
        ),        Table(
                  border: TableBorder.all(width: 1, color: PdfColors.grey),
                  columnWidths: const { // Project column (wider)
                    0: FlexColumnWidth(1), // Total Hours column// Income column
                  },
                  children: [
                    TableRow(children: [
                      Padding(padding: EdgeInsets.all(10), child:
                      Text("PLEASE ENSURE ALL SHIFTS WORKED ARE RECORDED AND THAT YOU SIGN BELOW. FAILURE TO DO SO WILL MEAN YOUR TIMESHEET CANNOT BE PROCESSED AND YOU WILL NOT BE PAID",
                      style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                      )
                    ]),
                  ]
              ),//signed

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Signed
                    Row(
                      children: [
                        Text(
                          "SIGNED:",
                                                  ),
                        Expanded(
                          child: Divider(
                            color: PdfColors.grey,
                            thickness: 1,
                            endIndent: 8,
                            indent: 8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Manager's Signature
                    Row(
                      children: [
                        Text(
                          "MANAGERS SIGNATURE:",
                                                 ),
                        Expanded(
                          child: Divider(
                            color: PdfColors.grey,
                            thickness: 1,
                            endIndent: 8,
                            indent: 8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Manager's Name
                    Row(
                      children: [
                        Text(
                          "MANAGERS NAME:",

                        ),
                        Expanded(
                          child: Divider(
                            color: PdfColors.grey,
                            thickness: 1,
                            endIndent: 8,
                            indent: 8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Note
                    Text(
                      "Continue on separate sheet if needed. If so, staple multiple sheets together and ensure all details are completed",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )

            ],
        ))
        ],
        );
      }
          , pageFormat: PdfPageFormat.a4
      ),
    );
    return SaveandOpenPDF().savePDF("docName", pdf);
  }
}
