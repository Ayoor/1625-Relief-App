class Shifts {
  DateTime startTime;
  DateTime endTime;
  String location;
  String shiftType;
  double rate;
  String duration;
  String status;
  String dateofAction;
  Shifts({required this.startTime,
    required this.endTime,
    required this.location,
    required this.shiftType,
    required this.rate,
    required this.status,
    required this.duration,
    required this.dateofAction,

  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'shiftType': shiftType,
      'rate': rate,
      'duration': duration,
      'status': status,
      'dateofAction': dateofAction,
    };
  }
}