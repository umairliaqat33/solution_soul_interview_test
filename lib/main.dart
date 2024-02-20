import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solution_soul_interview_test/chat_screen.dart';
import 'package:solution_soul_interview_test/firebase%20_and_firestore.dart';
import 'package:solution_soul_interview_test/firebase_options.dart';
import 'package:solution_soul_interview_test/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAndFirestore firebaseAndFirestore = FirebaseAndFirestore();
  bool loginStatus = false;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return loginStatus ? ChatScreen() : const LoginScreen();
  }

  void checkIfLoggedIn() {
    loginStatus = firebaseAndFirestore.checkLoginStatus();
  }
}
