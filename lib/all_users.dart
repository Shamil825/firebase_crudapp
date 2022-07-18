import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/main.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {

  const AllUsers({Key? key}) : super(key: key); 

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {

  @override
  Widget build(BuildContext context) {
        Stream<List<User>>readUsers()=>FirebaseFirestore.instance.collection('users').snapshots().map((snapshots) => snapshots.docs.map((doc) => User.fromJson(doc.data())).toList());

    return Scaffold(
      body: StreamBuilder<List<User>>(
          stream: readUsers(), builder: (context, snapshots) {
            if(snapshots.hasError){
 return  Text('something went wrong! ${snapshots.error}');
            } 
           else if(snapshots.hasData){
             
              final users=snapshots.data!;

              return ListView(
                children: users.map(buildUser).toList()
              );
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }),
      appBar: AppBar(
        title: const Text("All Users"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
 
 
  Widget buildUser(User user)=>ListTile(
    leading: CircleAvatar(child: Text('${user.age}')
    ),
    title:Text(user.name??"No name"),
  
  );
}
