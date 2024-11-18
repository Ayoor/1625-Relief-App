import 'package:flutter/material.dart';
import 'package:relief_app/viewmodel/provider.dart';

class ShiftTile extends StatefulWidget {
  final AppProvider provider;
  final String shiftType;

  const ShiftTile({super.key, required this.provider, required this.shiftType});

  @override
  State<ShiftTile> createState() => _ShiftTileState();
}

class _ShiftTileState extends State<ShiftTile> {
  late List<bool> _isCheckedList;

  @override
  void initState() {
    super.initState();

    // The .filled() constructor creates a list with a specified length,
    // and every element in the list is initialized with the same value.
    _isCheckedList = List<bool>.filled(widget.provider.scheduledShifts.length, false);
  }
  String formatDate(String dateTimeString) {
    // Parse the input string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date as dd-MM-yyyy
    String formattedDate = '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';

    return formattedDate;
  }
  @override
  Widget build(BuildContext context) {
    Widget shiftTile = Placeholder();
    if(widget.shiftType == "Scheduled"){
      shiftTile = ListView.builder(
        itemCount: widget.provider.scheduledShifts.length,
        itemBuilder: (context, index) {
          final shift = widget.provider.scheduledShifts[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/1625_logo.png",
                  width: 50,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shift.shiftType,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red[300]),
                          onPressed: () {
                            widget.provider.updateShiftStatus(index, formatDate(shift.startTime.toString()), context);
                          },
                        ),
                        const Text("Cancel Shift", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Start time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.startTime)}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("End time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.endTime)}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${shift.location}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Hrs:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(shift.duration),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Rate:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${shift.rate}"),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _isCheckedList[index],
                              onChanged: (value) {
                                setState(() {
                                  _isCheckedList[index] = value ?? false;
                                });
                              },
                            ),
                            const Text("Mark Completed", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                contentPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.white,
                selectedTileColor: Colors.grey[100],
              ),
            ),
          );
        },
      );
    }


//Cancelled

    if(widget.shiftType == "Cancelled"){
      shiftTile = ListView.builder(
        itemCount: widget.provider.cancelledShifts.length,
        itemBuilder: (context, index) {
          final shift = widget.provider.cancelledShifts[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/1625_logo.png",
                  width: 50,
                ),
                title: Text(
                  shift.shiftType,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Start time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.startTime)},",style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("End time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.endTime)}",style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${shift.location}",style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Hrs:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(shift.duration,style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Rate:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${shift.rate}",style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                        const Text("Cancelled",style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                contentPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.white,
                selectedTileColor: Colors.grey[100],
              ),
            ),
          );
        },
      );
    }

//Completed
    if(widget.shiftType == "Completed"){
      shiftTile = ListView.builder(
        itemCount: widget.provider.completedShifts.length,
        itemBuilder: (context, index) {
          final shift = widget.provider.completedShifts[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Image.asset(
                  "lib/assets/1625_logo.png",
                  width: 50,
                ),
                title: Text(
                  shift.shiftType,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Start time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.startTime)}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("End time:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${widget.provider.dateFormater(shift.endTime)}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(" ${shift.location}"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Hrs:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(shift.duration),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Rate:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${shift.rate}"),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: Colors.green,),
                            const Text("Completed", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                contentPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.white,
                selectedTileColor: Colors.grey[100],
              ),
            ),
          );
        },
      );
    }

    return shiftTile;
  }
}
