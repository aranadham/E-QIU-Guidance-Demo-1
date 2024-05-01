// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends ChangeNotifier {
  String username = "";
  String email = "";
  String password = "";


  void setUserName(String value) {
    username = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  String? validateUserName(String? value) {
    if (value == null) {
      return 'Enter Staff Name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null ||
        value.length < 6 ||
        value.length > 10 ||
        !value.contains(RegExp(r'[0-9]')) ||
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'must be 6-10 also contain symbols and numbers';
    }
    return null;
  }

  Future<void> registerStaff(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userUid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection("Staff")
          .doc(userUid)
          .set({"Staff Name": username, "role": "Staff"});

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Staff Registered Successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: Text("Unable To Register Staff $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> registerStudent(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Student Registered Successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: Text("Unable To Register Student $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }
}
