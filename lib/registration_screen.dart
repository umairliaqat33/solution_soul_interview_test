import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solution_soul_interview_test/chat_screen.dart';
import 'package:solution_soul_interview_test/firebase%20_and_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                children: [
                  const Center(
                      child: Text(
                    "Rgistration",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  )),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: _passController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must have minimum 8 characters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Already have an account? '),
                      TextButton(
                        style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                        ),
                      ),
                    ],
                  ),
                  _showSpinner
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          color: Colors.green,
                          onPressed: () => signUp(),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future<void> signUp() async {
    setState(() {
      _showSpinner = true;
    });
    final FirebaseAndFirestore firebaseFirestore = FirebaseAndFirestore();
    UserCredential? userCred;
    userCred = await firebaseFirestore.signUp(
        _emailController.text, _passController.text);
    if (userCred != null) {
      moveToNextScreen();
    } else {
      Fluttertoast.showToast(msg: "Signup Failed");
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void moveToNextScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ChatScreen(),
      ),
      (route) => false,
    );
  }
}
