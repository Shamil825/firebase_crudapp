import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/all_users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(name: "", age: "", date: "", id: ""),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  MyHomePage(
      {Key? key,
      required this.name,
      required this.age,
      required this.date,
      required this.id})
      : super(key: key);

  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name;
  String age;
  String id;
  String date;

  dataset() {
    if (name != "") {
      controllerName.text = name;
      controllerDate.text = date;
      controllerAge.text = age;
    }
  }

  String onname = "";
  String onage = "";
  String ondate = "";

  @override
  Widget build(BuildContext context) {
    dataset();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AllUsers()));
              },
              icon: const Icon(Icons.list_alt_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: ((value) {
                  onname = value;
                }),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This name is required";
                  } else if (val[0] == " ") {
                    return "ithonnum patoola";
                  }

                  return null;
                },
                controller: controllerName,
                decoration: const InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "This Age is required";
                  } else if (val[0] == " ") {
                    return "ithonnum patoola";
                  }

                  return null;
                },
                controller: controllerAge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Age",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              DateTimeField(
                  onChanged: ((value) {
                    ondate = value.toString();
                  }),
                  validator: (val) {
                    if (val.toString() == null || val.toString().isEmpty) {
                      return "This birthdate is required";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Birthdate  ",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: controllerDate,
                  format: DateFormat("yyyy-MM-dd"),
                  onShowPicker: (context, currentvalue) {
                    return showDatePicker(
                        context: context,
                        initialDate: currentvalue ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                  }),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // DateTime dt =
                      // DateTime.parse(controllerDate.text);
                      // var userDay = dt.day;
                      // var userMonth = dt.month;
                      // var userYear = dt.year;

                      final user = User(
                          name: onname == "" ? onname : controllerName.text,
                          age: int.parse(controllerAge.text),
                          birthday: controllerDate.text);
                      name != ""
                          ? update(onname, onage, ondate)
                          : createuser(user, id);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllUsers()));
                    }
                  },
                  child: Text("Save"),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.red)))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future update(String name, String age, String date) async {
    var collection = FirebaseFirestore.instance.collection('users');
    collection.doc(id).update(
      {
        'name': name,
        'age': age,
        'birthday': date,
      },
    );
  }

  Future createuser(User user, var idd) async {
    final docUser = idd == ""
        ? FirebaseFirestore.instance.collection('users').doc()
        : FirebaseFirestore.instance.collection('users').doc(idd);

    user.id = idd == "" ? docUser.id : idd;
    final json = user.toJson();

    await docUser.set(json, SetOptions(merge: true));
  }
}

class User {
  String? id;
  final String? name;
  final int? age;
  final String? birthday;

  User({this.id = "", this.name, this.age, this.birthday});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };

  static User fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        birthday: (json['birthday']));
  }
}
