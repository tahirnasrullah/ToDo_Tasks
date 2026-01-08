import 'package:flutter/material.dart';
import 'package:to_do/Authorization_pages/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:to_do/home_page.dart';

import 'firebase_options.dart';

// Future<void> main() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI_Project',
      theme: ThemeData(),
      home: home_page(),
      // home: login_page(),
    );
  }
}
