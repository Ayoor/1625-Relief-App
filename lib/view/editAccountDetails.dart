import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../viewmodel/authentication.dart';
import '../viewmodel/provider.dart';
import 'account.dart';

class EditAccount extends StatefulWidget {
  String detail;
  String? target;

  EditAccount({super.key, required this.detail, this.target});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  String targetText ="";
  @override
  Widget build(BuildContext context) {
    setState(() {
      if(widget.target==null){
        targetText = "Your current target has not been set";
      }
      else{


        targetText = "Your current target is ${widget.target}";
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            "lib/assets/1625_logo.png",
            width: 120,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          // Adjust the height as needed
          child: Container(
            color: Colors.grey, // Set your desired border color
            height: 1.0, // Set your desired border thickness
          ),
        ),
      ),
      body: detailToEdit(widget.detail),
    );
  }

  bool isLoading = false;
  String? errorText;

  Widget detailToEdit(String detail) {
    switch (detail) {
      //email
      case "Email":
        final TextEditingController emailController = TextEditingController();

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: email(detail, emailController),
        );
      //monthly target
      case "Monthly Target":
        final TextEditingController _targetController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: monthlyTarget(detail, _targetController),
        );

        case "First Name":
          final TextEditingController nameController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: name(detail, nameController),
        );
        case "Last Name":
          final TextEditingController nameController = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: name(detail, nameController),
        );
      // Add more cases as needed for other details
      default:
        return Center(
          child: Text(
            "No detail available for $detail",
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }

  Column monthlyTarget(String detail, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Change $detail",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Text(
          targetText, style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 25),
        Center(
          child: Text(
            "Your can choose a target between 50 to 9999",
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SizedBox(
            width: 400,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Your target",
                border: const OutlineInputBorder(),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    "lib/assets/target.png",
                    width: 30,
                  ),
                ),
                errorText: errorText, // Show real-time error
              ),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                CustomNumberInputFormatter()
                // Allows up to 4 digits before the decimal and 2 digits after;
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (controller.text.isEmpty) {
                  setState(() {
                    errorText = "You need to enter a target first";
                    isLoading = false;
                    return;
                  });
                }
                double value = double.parse(controller.text);
                if (value < 50) {
                  setState(() {
                    errorText = "Minimum monthly target is 50";
                    isLoading = false;
                  });
                  return;
                } else {
                  setState(() {
                    errorText = null;
                    isLoading = false;
                  });
                  String target = formatter.format(value);
                  await setMonthlyTarget(target, context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Account(),
                    ),
                  );
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                      strokeWidth: 2,
                    )
                  : Text(
                      "Set Monthly Target",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Column name(String detail, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Update $detail",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),

        const SizedBox(height: 25),

        Center(
          child: SizedBox(
            width: 400,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: detail,
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.grey,),
                errorText: errorText, // Show real-time error
              ),
              keyboardType:
              TextInputType.name,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (controller.text.isEmpty) {
                  setState(() {
                    errorText = "Enter your first name";
                    isLoading = false;
                  });
                  return;
                }
                  await changeUserName(controller.text.trim(), detail, context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Account(),
                    ),
                  );
                },
              child: isLoading
                  ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface,
                strokeWidth: 2,
              )
                  :  Text(
                "Update",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ),
        )
      ],
    );
  }


  //email
  Column email(String detail, TextEditingController _emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Change $detail",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(height: 10),
        Text(
          "Your current email is gbengajohn4god@gmail.com",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 25),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "New Email",
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            errorText: errorText, // Show real-time error
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                validateEmail(_emailController.text);
                if (errorText == null) {
                  setState(() {
                    isLoading = false;
                  });
                  Fluttertoast.showToast(msg: "Good");
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  return;
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                      strokeWidth: 2,
                    )
                  : Text(
                      "Update Email",
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> validateEmail(String value) async {
    final Authentication auth = Authentication();

    if (value.isEmpty) {
      setState(() {
        errorText = 'Please enter your email';
      });
      return;
    } else {
      setState(() {
        errorText = null;
      });
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        errorText = 'Please enter a valid email';
      });
      return;
    } else {
      setState(() {
        errorText = null;
      });
    }
    bool exists = await auth.checkEmailExists(value);
    if (exists) {
      setState(() {
        errorText = exists ? 'Email already exists' : null;
      });
    } else {
      setState(() {
        errorText = null;
      });
    }
  }
}

var formatter =
    NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");

Future<void> setMonthlyTarget(String target, BuildContext context) async {
  var email = await AppProvider().userEmail();

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child("Users/$email/");
  final DataSnapshot snapshot = await dbRef.get();
  try {
    if (snapshot.exists) {
      await dbRef.child("Target").set(target);
    }
    AppProvider().showMessage(
        context: context,
        message: "Your target has now been set to $target",
        type: ToastificationType.success,
        bgColor: Colors.green,
        icon: Icons.check_circle);
  } catch (e) {
    Fluttertoast.showToast(msg: "An error occurred try again later");
  }
}

Future<void> changeUserName(String name, String detail, BuildContext context) async {
  var email = await AppProvider().userEmail();

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref().child("Users/$email/");
  final DataSnapshot snapshot = await dbRef.get();
  try {
    if (snapshot.exists) {
      if(detail=="First Name") {
        await dbRef.child("First Name").set(name);
      }
      else if(detail=="Last Name") {
        await dbRef.child("Last Name").set(name);
      }
      else{
        return;
      }
    }
    else{
      AppProvider().showMessage(
          context: context,
          message: "Invalid email",
          type: ToastificationType.success,
          bgColor: Colors.red.shade200,
          icon: Icons.cancel);
      return;
    }

    AppProvider().showMessage(
        context: context,
        message: "Your $detail has now been updated",
        type: ToastificationType.success,
        bgColor: Colors.green,
        icon: Icons.check_circle);
  } catch (e) {
    Fluttertoast.showToast(msg: "An error occurred try again later");
  }
}


class CustomNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Check if the new input matches the desired format
    final isValid = RegExp(r'^\d{0,4}(\.\d{0,2})?$').hasMatch(newText);

    // If valid, allow the input; otherwise, keep the old value
    return isValid ? newValue : oldValue;
  }
}
