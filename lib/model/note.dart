
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:securenote/model/user.dart';

class Note{
  String id = "";
  String title = "";
  String body = "";
  Color color;
  bool isLocked;

  

  Note({this.id = "", this.title = "",this.body= "", this.isLocked = false, this.color = const Color(4294688813)});
}

List<Note> notes = [];

Future<void> removeNote(String id, BuildContext context, String from)async{

  var temp;
  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection(from).doc(id).get().then((doc)=>temp = doc);
  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection(from).doc(id).delete();  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Nota eliminata"),
    )
  );
}

Future<void > unArchiveNote(String id, context)async{

  final temp = await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection("archive").doc(id).get();
  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection('archive').doc(id).delete();  
  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection("note").add(temp.data());

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nota ripristinata")));
}

Future<void> archiveNote(String id, context)async{
  final temp = await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection("note").doc(id).get();

  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection("note").doc(id).delete();
  await FirebaseFirestore.instance.collection('utenti').doc(mainUser.email).collection("archive").add(temp.data());
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Nota Archiviata"),
    )
  );

}