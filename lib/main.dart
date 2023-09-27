import 'package:flutter/material.dart';
import 'package:master/Pages/development.dart';

import 'package:master/Pages/keys.dart';
import 'package:master/Pages/login.dart';


void main() {
WidgetsFlutterBinding.ensureInitialized();
// Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Login2(),
    );
  }
}
