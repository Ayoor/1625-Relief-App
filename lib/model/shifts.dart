class Shifts {
  DateTime startTime;
  DateTime endTime;
  String location;
  String shiftType;
  double rate;
  String duration;

  Shifts(
      {required this.startTime,
      required this.endTime,
      required this.location,
      required this.shiftType,
      required this.rate,
      required this.duration});
}
