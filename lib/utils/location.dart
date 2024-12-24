import 'package:flutter/material.dart';

class LocationIncomeHistory extends ChangeNotifier {
  double Jan = 0, Feb = 0, Mar = 0, Apr = 0, May = 0, Jun = 0;
  double Jul = 0, Aug = 0, Sep = 0, Oct = 0, Nov = 0, Dec = 0;

  // Reset all months to 0
  void reInitialiseMonthlyValues() {
    Jan = Feb = Mar = Apr = May = Jun = Jul = Aug = Sep = Oct = Nov = Dec = 0;
  }

  // Accumulate value for a specific month
  void accumulateMonthlyValue(int monthIndex, double value) {
    switch (monthIndex) {
      case 1:
        Jan += value;
        break;
      case 2:
        Feb += value;
        break;
      case 3:
        Mar += value;
        break;
      case 4:
        Apr += value;
        break;
      case 5:
        May += value;
        break;
      case 6:
        Jun += value;
        break;
      case 7:
        Jul += value;
        break;
      case 8:
        Aug += value;
        break;
      case 9:
        Sep += value;
        break;
      case 10:
        Oct += value;
        break;
      case 11:
        Nov += value;
        break;
      case 12:
        Dec += value;
        break;
      default:
        break;
    }
    notifyListeners();
  }
}
