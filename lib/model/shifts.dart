class Shifts {
  DateTime startTime;
  DateTime endTime;
  String location;
  String shiftType;
  double rate;
  String durationText;
  String status;
  String dateofAction;
  double duration;
  Shifts({required this.startTime,
    required this.endTime,
    required this.location,
    required this.shiftType,
    required this.rate,
    required this.status,
    required this.durationText,
    required this.dateofAction,
    required this.duration
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'shiftType': shiftType,
      'rate': rate,
      'durationText': durationText,
      'status': status,
      'dateofAction': dateofAction,
      'duration': duration,
    };
  }
}