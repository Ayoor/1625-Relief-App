import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/provider.dart';

class HistoryTable extends StatefulWidget {

  const HistoryTable({super.key});

  @override
  State<HistoryTable> createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).shiftHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, provider, child) {
      return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                // Apply the border to the container
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ClipRRect( // to enforce the border radius
                borderRadius: BorderRadius.circular(10),
                child: Table(

                  columnWidths: const {
                    0: FlexColumnWidth(), // Month column (wider)
                    1: FlexColumnWidth(1), // SGH column
                    2: FlexColumnWidth(1), // CEH column
                    3: FlexColumnWidth(1), // Woodleaze column
                    4: FlexColumnWidth(1), // Total column
                  },
                  children: _buildTableRows(provider),
                ),
              )
          )
      );
    }
    );
  }

  // Function to build table rows
  List<TableRow> _buildTableRows(AppProvider provider) {

    final formatter = NumberFormat.currency(locale: "en_GB", symbol: "£");

    final data = [
      [
        "Jan",
        formatter.format(provider.SGH.Jan),
        formatter.format(provider.CEH.Jan),
        formatter.format(provider.WL.Jan),
        formatter.format(provider.SGH.Jan + provider.CEH.Jan + provider.WL.Jan)
      ],

      [
        "Feb",
        formatter.format(provider.SGH.Feb),
        formatter.format(provider.CEH.Feb),
        formatter.format(provider.WL.Feb),
        formatter.format(provider.SGH.Feb + provider.CEH.Feb + provider.WL.Feb)
      ],

      [
        "Mar",
        formatter.format(provider.SGH.Mar),
        formatter.format(provider.CEH.Mar),
        formatter.format(provider.WL.Mar),
        formatter.format(provider.SGH.Mar + provider.CEH.Mar + provider.WL.Mar)
      ],

      [
        "Apr",
        formatter.format(provider.SGH.Apr),
        formatter.format(provider.CEH.Apr),
        formatter.format(provider.WL.Apr),
        formatter.format(provider.SGH.Apr + provider.CEH.Apr + provider.WL.Apr)
      ],

      [
        "May",
        formatter.format(provider.SGH.May),
        formatter.format(provider.CEH.May),
        formatter.format(provider.WL.May),
        formatter.format(provider.SGH.May + provider.CEH.May + provider.WL.May)
      ],

      [
        "Jun",
        formatter.format(provider.SGH.Jun),
        formatter.format(provider.CEH.Jun),
        formatter.format(provider.WL.Jun),
        formatter.format(provider.SGH.Jun + provider.CEH.Jun + provider.WL.Jun)
      ],

      [
        "Jul",
        formatter.format(provider.SGH.Jul),
        formatter.format(provider.CEH.Jul),
        formatter.format(provider.WL.Jul),
        formatter.format(provider.SGH.Jul + provider.CEH.Jul + provider.WL.Jul)
      ],

      [
        "Aug",
        formatter.format(provider.SGH.Aug),
        formatter.format(provider.CEH.Aug),
        formatter.format(provider.WL.Aug),
        formatter.format(provider.SGH.Aug + provider.CEH.Aug + provider.WL.Aug)
      ],

      [
        "Sep",
        formatter.format(provider.SGH.Sep),
        formatter.format(provider.CEH.Sep),
        formatter.format(provider.WL.Sep),
        formatter.format(provider.SGH.Sep + provider.CEH.Sep + provider.WL.Sep)
      ],

      [
        "Oct",
        formatter.format(provider.SGH.Oct),
        formatter.format(provider.CEH.Oct),
        formatter.format(provider.WL.Oct),
        formatter.format(provider.SGH.Oct + provider.CEH.Oct + provider.WL.Oct)
      ],

      [
        "Nov",
        formatter.format(provider.SGH.Nov),
        formatter.format(provider.CEH.Nov),
        formatter.format(provider.WL.Nov),
        formatter.format(provider.SGH.Nov + provider.CEH.Nov + provider.WL.Nov)
      ],

      [
        "Dec",
        formatter.format(provider.SGH.Dec),
        formatter.format(provider.CEH.Dec),
        formatter.format(provider.WL.Dec),
        formatter.format(provider.SGH.Dec + provider.CEH.Dec + provider.WL.Dec)
      ],

      [
        "Total",
        formatter.format(
            provider.SGH.Jan + provider.SGH.Feb + provider.SGH.Mar +
                provider.SGH.Apr + provider.SGH.May + provider.SGH.Jun +
                provider.SGH.Jul + provider.SGH.Aug + provider.SGH.Sep +
                provider.SGH.Oct + provider.SGH.Nov + provider.SGH.Dec),
        formatter.format(
            provider.CEH.Jan + provider.CEH.Feb + provider.CEH.Mar +
                provider.CEH.Apr + provider.CEH.May + provider.CEH.Jun +
                provider.CEH.Jul + provider.CEH.Aug + provider.CEH.Sep +
                provider.CEH.Oct + provider.CEH.Nov + provider.CEH.Dec),
        formatter.format(provider.WL.Jan + provider.WL.Feb + provider.WL.Mar +
            provider.WL.Apr + provider.WL.May + provider.WL.Jun +
            provider.WL.Jul + provider.WL.Aug + provider.WL.Sep +
            provider.WL.Oct + provider.WL.Nov + provider.WL.Dec),
        formatter.format(provider.SGH.Jan + provider.SGH.Feb + provider.SGH
            .Mar + provider.SGH.Apr + provider.SGH.May + provider.SGH.Jun +
            provider.SGH.Jul + provider.SGH.Aug + provider.SGH.Sep +
            provider.SGH.Oct + provider.SGH.Nov + provider.SGH.Dec +
            provider.CEH.Jan + provider.CEH.Feb + provider.CEH.Mar +
            provider.CEH.Apr + provider.CEH.May + provider.CEH.Jun +
            provider.CEH.Jul + provider.CEH.Aug + provider.CEH.Sep +
            provider.CEH.Oct + provider.CEH.Nov + provider.CEH.Dec +
            provider.WL.Jan + provider.WL.Feb + provider.WL.Mar +
            provider.WL.Apr + provider.WL.May + provider.WL.Jun +
            provider.WL.Jul + provider.WL.Aug + provider.WL.Sep +
            provider.WL.Oct + provider.WL.Nov + provider.WL.Dec),
      ],
    ];

    List<TableRow> rows = [];

    // Add the header row
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.blue.shade200),
        children: [
          _buildCell("Month", isHeader: true),
          _buildCell("SGH", isHeader: true),
          _buildCell("CEH", isHeader: true),
          _buildCell("Woodleaze", isHeader: true),
          _buildCell("Total", isHeader: true),
        ],
      ),
    );

    // Add body rows
    for (int i = 0; i < data.length - 1; i++) {
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: i.isOdd ? Colors.grey.shade200 : Colors
                .white, // Striped rows
          ),
          children: data[i]
              .map((cell) => _buildCell(cell, isHeader: false))
              .toList(),
        ),
      );
    }

    // Add the footer row (last row)
    rows.add(
      TableRow(
        decoration: BoxDecoration(color: Colors.amberAccent.shade100),
        children: data.last
            .map((cell) => _buildCell(cell, isHeader: true))
            .toList(),
      ),
    );

    return rows;
  }

  // Helper function to build table cells
  Widget _buildCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
