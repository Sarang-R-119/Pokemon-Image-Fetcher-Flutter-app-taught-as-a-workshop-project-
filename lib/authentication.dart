import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/home_page.dart';
import 'package:sample_app/main.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _pass = "";

  void goToHomePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => const MyHomePage(title: "Pokemon App")));
  }

  Future<bool> register() async {
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pass);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> login() async {
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pass);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
    return register();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN/REGISTER",
                    style: TextStyle(fontSize: 36),
                  ),
                  TextFormField(
                    onChanged: (value) => {_email = value},
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter stuff please';
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    onChanged: (value) => {_pass = value},
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6)
                        return 'Please enter stuff please, and more than length of 6';
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      child: Text('Login'),
                      onPressed: () async {
                        bool success = await login();
                        if (success) goToHomePage();
                      },
                    ),
                  )
                ])));
  }
}
