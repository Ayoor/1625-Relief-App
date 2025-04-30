import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';

class BoardDateTime{
  List<int> hours = [1,2,3,4,5,6,7,8,9,10,11,12];
  List<int> mins = [00,15,30,45];
  void _pickShiftTime(BuildContext context) async {
    final result = await showBoardDateTimePicker(
        context: context,
        pickerType: DateTimePickerType.datetime,
        isDismissible: true,
        enableDrag: false,
        radius: 30,
        useSafeArea: true,
        initialDate: DateTime.now(),
        minimumDate: DateTime.now().subtract(Duration(days: 40)),
        maximumDate: DateTime.now().add(Duration(days: 40)),
        options: BoardDateTimeOptions(
            boardTitle: "Shift End Date",
            showDateButton: false,
            languages: BoardPickerLanguages(locale: "en"),
            inputable: false,
            customOptions: BoardPickerCustomOptions(hours: hours, minutes: mins),
            startDayOfWeek: DateTime.sunday,
            withSecond: false,
            pickerSubTitles: BoardDateTimeItemTitles(
                day: "Day",
                hour: "Hr",
                year: "Year",
                month: "Month",
                minute: "Min"),
            pickerFormat: PickerFormat.mdy));

    // if (result != null) {
    //   setState(() {
    //     endTime = result;
    //   });
    // }
  }
}