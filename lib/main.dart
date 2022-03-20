import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_app/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_app/authentication.dart';
import 'package:sample_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

late final FirebaseAuth auth;
late final FirebaseFirestore db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instance;
  db = FirebaseFirestore.instance;

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null)
      print('User has logged out');
    else
      print('User is signed in');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: auth.currentUser == null
          ? Authentication()
          : const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
