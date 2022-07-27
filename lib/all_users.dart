import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/main.dart';
import 'package:flutter/material.dart';

final index = 0;

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    Stream<List<User>> readUsers() => FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshots) {
          return snapshots.docs.map((doc) {
                      print("object:********************${doc.data()}");

            return User.fromJson(doc.data());
          }).toList();
        });

            

    return Scaffold(
      body: StreamBuilder<List<User>>(
          stream: readUsers(),
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return Text('something went wrong! ${snapshots.error}');
            } else if (snapshots.hasData) {
              final users = snapshots.data!;

              return ListView(children: users.map(buildUser).toList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      appBar: AppBar(
        title: const Text("All Users"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        age: "",
                        date: "",
                        id: "",
                        name: "",
                      )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildUser(User user) => ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        age: user.age.toString(),
                        date: user.birthday.toString(),
                        name: user.name.toString(),
                        id: user.id.toString(),
                      )));
                      
                      
                      
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final docUser =
                FirebaseFirestore.instance.collection('users').doc(user.id);

            docUser.delete();
          },
        ),
        leading: CircleAvatar(child: Text('${user.age}')),
        title: Text(user.name ?? "No name"),
      );
      



}
