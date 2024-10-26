import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:colour/colour.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/viewmodel/provider.dart';

class NewShift extends StatefulWidget {
  const NewShift({super.key});

  @override
  State<NewShift> createState() => _NewShiftState();
}

String dateFormater(DateTime datetime) {
  // Define the date format
  String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(datetime);
  return formattedDate;
}

class _NewShiftState extends State<NewShift> {
  TextEditingController locationController = TextEditingController();
  String selectedLocation = "";
  final List<String> locations = [
    "Charles England House",
    "St. George's House",
    "Woodleaze"
  ]; // Default location
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 8));
  final controller = BoardDateTimeController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colour("#e8f3fa"),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 14,
              ),
              // Shift start time
              const Text('Add a new Shift',
                  style: TextStyle(
                    fontSize: 22,
                      color: Colors.black45
                  )),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius of the shadow
                      blurRadius: 1, // Blur radius
                      offset: Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shift Starts at',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Row(
                        children: [
                          Text(dateFormater(startTime), style: TextStyle(color: Colors.blue),),
                          IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height / 2,
                                    child: Column(
                                      children: [
                                        // Give the date picker a fixed height so that it doesn't push the button off the screen.
                                        SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height / 3,
                                          // Adjust the height as needed
                                          child: CupertinoDatePicker(
                                            onDateTimeChanged: (DateTime value) {
                                              setState(() {
                                                startTime = value;
                                              });
                                            },
                                            initialDateTime: DateTime.now(),
                                            use24hFormat: false,
                                            showDayOfWeek: true,
                                            maximumDate: DateTime.now()
                                                .add(Duration(days: 40)),
                                            minimumDate: DateTime.now()
                                                .subtract(Duration(days: 40)),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // Add some space between the picker and the button
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the modal
                                          },
                                          child: Text(
                                            "OK",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.orange,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius of the shadow
                      blurRadius: 1, // Blur radius
                      offset: Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shift Closes at',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Row(
                        children: [
                          Text(dateFormater(endTime),style: TextStyle(color: Colors.blue)),
                          IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height / 2,
                                    child: Column(
                                      children: [
                                        // Give the date picker a fixed height so that it doesn't push the button off the screen.
                                        SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height / 3,
                                          // Adjust the height as needed
                                          child: CupertinoDatePicker(
                                            onDateTimeChanged: (DateTime value) {
                                              setState(() {
                                                endTime = value;
                                              });
                                            },
                                            initialDateTime: DateTime.now(),
                                            use24hFormat: false,
                                            showDayOfWeek: true,
                                            maximumDate: DateTime.now()
                                                .add(Duration(days: 40)),
                                            minimumDate: DateTime.now()
                                                .subtract(Duration(days: 40)),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // Add some space between the picker and the button
                                        TextButton(
                                          onPressed: () {
                                            setState(() {});
                                            Navigator.of(context)
                                                .pop(); // Close the modal
                                          },
                                          child: Text(
                                            "OK",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                size: 25,
                                color: Colors.orange,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text("Location is", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
              SizedBox(height: 5,),

              // Location dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius of the shadow
                      blurRadius: 1, // Blur radius
                      offset: Offset(0, 3), // Offset of the shadow
                    ),
                  ],
                ),
                child: DropdownFlutter<String>(
                  decoration: CustomDropdownDecoration(prefixIcon: Icon(Icons.house, color: Colors.grey,size: 18,),
                     ),
                  hintText: 'Location',
                  initialItem: locations[0],
                  items: locations,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        selectedLocation = value;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.orange)),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    provider.addNewShift("Early", DateTime.now().add(Duration(minutes: 300)), DateTime.now().add(Duration(minutes: 600)), "Woodleaze" , context);

                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
