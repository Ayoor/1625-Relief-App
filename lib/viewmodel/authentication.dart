import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Authentication extends ChangeNotifier{

  Future<bool> checkEmailExists(String email) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    final DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      final users = snapshot.value as Map;
      notifyListeners();
      return users.values.any((user) => user['email'] == email);
    }
    notifyListeners();
    return false;
  }

  // void submitSignup(){
  //   if (_formKey.currentState!.validateForm()) {
  //     // Handle successful validation
  //     print("Name: ${_nameController.text}");
  //     print("Email: ${_emailController.text}");
  //     print("Password: ${_passwordController.text}");
  //   }
  // }
}