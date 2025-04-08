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
  double userTarget = 1;

  Future<void> getCenterText() async {

    final provider = Provider.of<AppProvider>(context, listen: false);
  ReliefUser?  user = await provider.fetchUser(context);

    var formatter = NumberFormat.currency(
        locale: "en_UK", decimalDigits: 2, symbol: "£");
if(mounted){ //avoid memory leak
  if (user!.target == null || user.target == 0) {
    setState(() {
      centerText = "No target set";
    });
  }
  else {

    setState(() {
      centerText = "Total ${formatter.format(widget.total)} of ${user.target}";
      user.target= user.target?.replaceAll("£", "");
      user.target= user.target?.replaceAll(",", "");
      userTarget = double.parse(user.target!) ;
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
        Colors.deepOrangeAccent.shade100,
        Colors.grey.shade300,
        Colors.blue.shade300,
      ],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 10,
      centerWidget: centerWidget(),
      // centerText: centerText,
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

  Widget centerWidget() {
    double total = widget.total;
    double value = total/userTarget;
    Color indicatorColor = Colors.pinkAccent.shade700;
    setState(() {
      if(total < (userTarget*0.5)){
        indicatorColor= Colors.pinkAccent.shade700;
      }
      else if(total < userTarget){
        indicatorColor= Colors.orangeAccent;
      }
      else {
        indicatorColor = Colors.green;
      }
    });

    return
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(centerText),
        SizedBox(height: 10),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            color: indicatorColor,
            value: value,
            minHeight: 4,
          ),
        )

      ],
    );
  }
}
