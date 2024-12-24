import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {"CEH": widget.CEH, "SGH": widget.SGH, "Woodleaze":widget.woodleaze};

    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 2000),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: [
        Colors.orangeAccent,
        Colors.grey.shade300,
        Colors.blue.shade300,
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 15,
      centerText: "Total ${widget.total}",
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
