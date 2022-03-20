import 'dart:convert';
import 'package:sample_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/main.dart';
import 'package:sample_app/pokemon.dart';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currName = "";
  String toSearch = "";
  Pokemon currPokemon = Pokemon(name: "", imageUrl: "");

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference pList =
      FirebaseFirestore.instance.collection('pokemonlist');

  Future<void> addPokemon() {
    return pList
        .add(currPokemon.toJson())
        .then((value) => print("Pokemon Added"))
        .catchError((error) => print("Failed to add pokemon: $error"));
  }

  void favPokemon() async {
    if (currPokemon.name.isNotEmpty && currPokemon.imageUrl.isNotEmpty) {}
  }

  void setPokemon(String val) {
    currName = val;
    toSearch = "https://pokeapi.co/api/v2/pokemon/$val";
  }

  Future<Pokemon> searchPokemonHelper() async {
    final res = await http.get(Uri.parse(toSearch));

    return Pokemon.fromJson(currName, jsonDecode(res.body));
  }

  void searchPokemon() async {
    searchPokemonHelper().then((value) {
      setState(() {
        currPokemon = value;
      });
    });
  }

  void goToProfilePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const Profile()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(auth.currentUser?.email ?? "Unknown"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "SEARCH POKEMON",
                    ),
                    onChanged: (value) {
                      setPokemon(value);
                    },
                  ),
                ),
                TextButton(onPressed: searchPokemon, child: Text("SEARCH"))
              ],
            ),
            Image.network(
              currPokemon.imageUrl,
              width: 600,
              height: 400,
              errorBuilder: (ctx, curr, error) {
                // currPokemon = Pokemon(name: "", imageUrl: "");
                return Text('😅');
              },
            ),
            ElevatedButton(onPressed: goToProfilePage, child: Text("Profile"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPokemon,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
