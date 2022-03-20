import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_app/main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Getting the stream of data -> QuerySnapshot
  // Getting snapshot, current collection of data
  final Stream<QuerySnapshot> _pokemonListStream =
      db.collection('pokemonlist').snapshots();

  @override
  Widget build(BuildContext context) {
    // Using the stream builder to track the changes and pass it down to the child widgets
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _pokemonListStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Image.network(
                      data['imageUrl'],
                      width: 600,
                      height: 400,
                      errorBuilder: (ctx, curr, error) {
                        // currPokemon = Pokemon(name: "", imageUrl: "");
                        return Text('😅');
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
