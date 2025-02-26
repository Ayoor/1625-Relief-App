// import 'package:drop_down_list/model/selected_list_item.dart';
// import 'package:drop_down_list/drop_down_list.dart';
// import 'package:flutter/material.dart';
//
// class CustomDropDown extends StatefulWidget {
//   const CustomDropDown({super.key});
//
//   @override
//   State<CustomDropDown> createState() => _CustomDropDownState();
// }
//
// class _CustomDropDownState extends State<CustomDropDown> {
//   // Example list of cities
//   final List<SelectedListItem> cities = [
//     SelectedListItem(name: "New York"),
//     SelectedListItem(name: "London"),
//     SelectedListItem(name: "Paris"),
//     // Add more cities if needed
//   ];
//
//   void showDropDown(BuildContext context) {
//     DropDownState(
//       DropDown(
//         bottomSheetTitle: const Text(
//           "Cities",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20.0,
//           ),
//         ),
//         submitButtonChild: const Text(
//           'Done',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         data: cities,
//         onSelected: (List<dynamic> selectedList) {
//           List<String> list = [];
//           for (var item in selectedList) {
//             if (item is SelectedListItem) {
//               list.add(item.name);
//             }
//           }
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Selected: ${list.join(', ')}')),
//           );
//         },
//         enableMultipleSelection: true,
//       ),
//     ).showModal(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dropdown Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDropDown(context);
//           },
//           child: const Text('Show Dropdown'),
//         ),
//       ),
//     );
//   }
// }
