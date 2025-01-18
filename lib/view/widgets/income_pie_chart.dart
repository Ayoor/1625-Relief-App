import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:relief_app/services/firebase_auth.dart';
import 'package:toastification/toastification.dart';

import '../../viewmodel/provider.dart';

class IncomePieChart extends StatefulWidget {
  IncomePieChart({super.key,required this.CEH, required this.SGH, required this.woodleaze,required this.total});
  double CEH;
  double SGH;
  double woodleaze;
  double total;

  @override
  State<IncomePieChart> createState() => _IncomePieChartState();
}


class _IncomePieChartState extends State<IncomePieChart> {
  double _target = 0;
  String centerText = "";


  Future<void> getCenterText() async {

    var email = await AppProvider().userEmail();
    final DatabaseReference dbRef =
    FirebaseDatabase.instance.ref().child("Users/$email/");
    var formatter = NumberFormat.currency(
        locale: "en_UK", decimalDigits: 2, symbol: "£");
    final DataSnapshot snapshot = await dbRef.get();
    if (snapshot.exists) {
      final users = snapshot.value as Map;
      if (users["Target"] == null) {
        setState(() {
          centerText = "Total: ${formatter.format(widget.total)}";
        });
      }
      else {
        setState(() {
          centerText = "Total ${formatter.format(widget.total)} of ${formatter.format(users["Target"])}";
        });
      }
    }



  }


  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"CEH": widget.CEH, "SGH": widget.SGH, "Woodleaze":widget.woodleaze};
getCenterText();
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 4000),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: [
        Colors.orangeAccent,
        Colors.grey.shade300,
        Colors.blue.shade300,
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 10,
      centerText: centerText,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.left,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(fontSize: 11
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,chartValueStyle: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        decimalPlaces: 2,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    );
  }
}
