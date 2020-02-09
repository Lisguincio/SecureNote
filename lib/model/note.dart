
import 'package:flutter/material.dart';

class Note{
  String id = "";
  String title = "";
  String body = "";
  Color color = Colors.yellow.shade700;
  bool isLocked = false;

  Note({this.id, this.title,this.body, this.isLocked, this.color});
}

List<Note> notes = new List();