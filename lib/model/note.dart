
import 'package:flutter/material.dart';

class Note{
  String id = "";
  String title = "";
  String body = "";
  Color color;
  bool isLocked;

  

  Note({this.id, this.title,this.body, this.isLocked = false, this.color = const Color(4294688813)});
}

List<Note> notes = new List();