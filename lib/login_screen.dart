import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solution_soul_interview_test/chat_screen.dart';
import 'package:solution_soul_interview_test/FirebaseAndFirestore.dart';
import 'package:solution_soul_interview_test/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                      child: Text(
                    "Login",
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
                      const Text('Don\'t have an account? '),
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
                          "Sign Up",
                        ),
                      ),
                    ],
                  ),
                  _showSpinner
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          color: Colors.green,
                          onPressed: () => login(),
                          child: const Text(
                            "Login",
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

  Future<void> login() async {
    setState(() {
      _showSpinner = true;
    });
    final FirebaseAndFirestore firebaseFirestore = FirebaseAndFirestore();
    UserCredential? userCred;
    try {
      userCred = await firebaseFirestore.signIn(
          _emailController.text, _passController.text);
      if (userCred != null) {
        moveToNextScreen();
      } else {
        Fluttertoast.showToast(msg: "Login Failed");
      }
    } catch (e) {
      log("Login Failed");
      Fluttertoast.showToast(msg: "Something went wrong");
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
