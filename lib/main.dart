// import 'package:to_do/Authorization_pages/login_page.dart';

import 'package:to_do/Authorization_pages/signup_page.dart';

import 'package:to_do/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI_Project',
      theme: ThemeData(),
      // home: HomePage(),
      home: SignupPage(),
    );
  }
}
