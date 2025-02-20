import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/userData.dart';
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
  String centerText = "";


  Future<void> getCenterText() async {

    final provider = Provider.of<AppProvider>(context, listen: false);
  ReliefUser?  user = await provider.fetchUser(context);
    var formatter = NumberFormat.currency(
        locale: "en_UK", decimalDigits: 2, symbol: "£");
if(mounted){ //avoid memory leak
  if (user!.target == null) {
    setState(() {
      centerText = "Total: ${formatter.format(widget.total)}";
    });
  }
  else {
    setState(() {
      centerText = "Total ${formatter.format(widget.total)} of ${user.target}";
    });
  }
}

    }


  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"CEH": widget.CEH, "SGH": widget.SGH, "Woodleaze":widget.woodleaze};
getCenterText();
    return PieChart(

      centerTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
        legendTextStyle: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface
        ),
      ),
      chartValuesOptions: ChartValuesOptions(

        showChartValueBackground: false,
        showChartValues: true,chartValueStyle: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        decimalPlaces: 2,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    );
  }
}
