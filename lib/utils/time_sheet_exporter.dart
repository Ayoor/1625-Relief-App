import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:relief_app/utils/saveandopenPDF.dart';

class TimeSheetExporter {
  final String name;
  final String range;
  List<List<dynamic>> data;
  double total;

  TimeSheetExporter(
      {required this.name,
      required this.range,
      required this.data,
      required this.total});

  Future<File> cehTimeSheet() async {
    final pdf = Document();
    pdf.addPage(
      Page(
          build: (Context context) {
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
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Text("RELIEF WORK - TIME SHEET ",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(height: 10),
                    Text("Name: $name"),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Month: $range"),
                    ),

                    Text("Pay rate:"),
                    SizedBox(height: 20),
                    TableHelper.fromTextArray(
                      data: data,
                      headers: [
                        "DATE",
                        "START TIME",
                        "LUNCH BREAK",
                        "END TIME ",
                        "HOURS WORKED "
                      ],
                      cellAlignment: Alignment.center,
                      border: TableBorder.all(width: 1, color: PdfColors.grey),
                      tableWidth: TableWidth.max,
                      headerStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Table(
                        border:
                            TableBorder.all(width: 1, color: PdfColors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(2.86),
                          // Project column (wider)
                          1: FlexColumnWidth(1),
                          // Total Hours column// Income column
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("TOTAL NUMBER OF HOURS WORKED"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("$total"),
                            )
                          ]),
                        ]),
                    Table(
                        border:
                            TableBorder.all(width: 1, color: PdfColors.grey),
                        columnWidths: const {
                          // Project column (wider)
                          0: FlexColumnWidth(1),
                          // Total Hours column// Income column
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  "PLEASE ENSURE ALL SHIFTS WORKED ARE RECORDED AND THAT YOU SIGN BELOW. FAILURE TO DO SO WILL MEAN YOUR TIMESHEET CANNOT BE PROCESSED AND YOU WILL NOT BE PAID",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                            )
                          ]),
                        ]), //signed

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
          },
          pageFormat: PdfPageFormat.a4),
    );
    return SaveandOpenPDF().savePDF("docName", pdf);
  }

  //New
  Future<File> newCEHTimeSheet() async {
    final pdf = Document();
    final logo = (await rootBundle.load("lib/assets/1625_logo.png"))
        .buffer
        .asUint8List();

    Widget fullpage(List<List<dynamic>> timeSheetData, {double totalHrs = 0}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(MemoryImage(logo), width: 50),
              Text("Generated on Relief App", style: TextStyle(color: PdfColors.grey, fontSize: 10))
            ]
          ),
          SizedBox(height: 5),
          Table(
              border: TableBorder.all(width: 1, color: PdfColors.grey),
              columnWidths: const {
                // Project column (wider)
                0: FlexColumnWidth(1),
                // Total Hours column// Income column
              },
              children: [
                TableRow(
                    decoration: BoxDecoration(color: PdfColors.teal100),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Relief Time Sheet",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                    ]),
              ]),
          Table(
              border: TableBorder.all(width: 1, color: PdfColors.grey),
              columnWidths: const {
                // Project column (wider)
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                // Total Hours column// Income column
              },
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Name",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ]),
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Month",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(range,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ])
              ]),

          Table(
              border: TableBorder.all(width: 1, color: PdfColors.grey),
              columnWidths: const {
                // Project column (wider)
                0: FlexColumnWidth(1),
                // Total Hours column// Income column
              },
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ]),
              ]),
          TableHelper.fromTextArray(
            columnWidths: const {
              // Project column (wider)
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              // Total Hours column// Income column
            },
            data: timeSheetData,
            headers: [
              "Date",
              "Start Time",
              "Launch break",
              "End Time",
              "Total Hours",
            ],
            cellAlignment: Alignment.center,
            border: TableBorder.all(width: 1, color: PdfColors.grey),
            tableWidth: TableWidth.max,
            headerStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),

          Table(
              border: TableBorder.all(width: 1, color: PdfColors.grey),
              columnWidths: const {
                0: FlexColumnWidth(3.99),
                // Project column (wider)
                1: FlexColumnWidth(1),
                // Total Hours column// Income column
              },
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Total number of hours completed",
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text("$totalHrs")),
                  )
                ]),
              ]),

          Table(
              border: TableBorder.all(width: 1, color: PdfColors.grey),
              columnWidths: const {
                // Project column (wider)
                0: FlexColumnWidth(1),
                // Total Hours column// Income column
              },
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Continue on a separate sheet if needed\nPlease ensure all shifts completed are recorded and that your sign below. Failure to do so will mean your timesheet cannot be processed and you will not be paid.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ]),
              ]), //signed

          Padding(
            padding: const EdgeInsets.only(top: 17),
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
                SizedBox(height: 17),

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
                SizedBox(height: 17),

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

                // Note
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      );
    }

    pdf.addPage(
      MultiPage(
          build: (Context context) {
            double totalhours;
            if (data.length <= 15) {
              totalhours = total;
              return [fullpage(data, totalHrs: totalhours)];
            } else {
              int customSplitIndex = 15;
              List<List<dynamic>> dataA = data.sublist(0, customSplitIndex);
              List<List<dynamic>> dataB = data.sublist(customSplitIndex);
              print(
                dataA.length,
              );
              print(
                dataB.length,
              );

              double totalhoursA = 0;
              double totalhoursB = 0;

              for (int i = 0; i < dataA.length; i++) {
                if (dataA[i][4] != "\n") {
                  totalhoursA += dataA[i][4];
                }
              }
              for (int i = 0; i < dataB.length; i++) {
                if (dataB[i][4] != "\n") {
                  totalhoursB += dataB[i][4];
                }
              }

              if (dataB.length < 15) {
                int rowsToAdd =
                    15 - dataB.length; // Calculate how many rows to add
                List<List<dynamic>> rowsToInsert = List.generate(
                    rowsToAdd,
                    (index) => [
                          "\n",
                          "\n",
                          "\n",
                          "\n",
                          "\n"
                        ]); // Generate the rows to add

                // Add the rows to dataB outside the loop
                dataB.addAll(rowsToInsert);
              }

              return [
                fullpage(dataA, totalHrs: totalhoursA),
                fullpage(dataB, totalHrs: totalhoursB),
              ];
            }
          },
          pageFormat: PdfPageFormat.a4),
    );
    return SaveandOpenPDF().savePDF(
        " ${DateTime.now().month}-${DateTime.now().year} Timesheet", pdf);
  }
}
