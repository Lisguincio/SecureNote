
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

List<Note> notes = new List();

Future<void> removeNote(String id, BuildContext context)async{

  final temp = await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").document(id).get();
  await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").document(id).delete();  
  Scaffold.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Nota eliminata"),
      action: SnackBarAction(
        label: "Annulla",
        onPressed: () async {return await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").add(temp.data);},
      ),
    )
  );
}

Future<void> archiveNote(String id, context)async{
  final temp = await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").document(id).get();
  
  await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").document(id).delete();
  await Firestore.instance.collection('utenti').document(mainUser.email).collection("archive").add(temp.data);
  
  Scaffold.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
      content: Text("Nota Archiviata"),
      action: SnackBarAction(
        label: "Annulla",
        onPressed: () async {
          await Firestore.instance.collection("utenti").document(mainUser.email).collection("archive").document(id).delete();
          return await Firestore.instance.collection('utenti').document(mainUser.email).collection("note").add(temp.data);},
      ),
    )
  );

}