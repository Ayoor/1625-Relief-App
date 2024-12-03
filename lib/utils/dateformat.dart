import 'package:intl/intl.dart';

class ReadableDate{
  DateTime dateTime;

  ReadableDate({required this.dateTime});


  String date () {
    String formattedDate ="";
    // Define the date format
    formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }


  String dateAndTime () {
    String formattedDate ="";
    // Define the date format
     formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
      return formattedDate;
  }


  String time () {
    String formattedDate ="";
    // Define the date format
    formattedDate = DateFormat('hh:mm a').format(dateTime);
      return formattedDate;
  }
}