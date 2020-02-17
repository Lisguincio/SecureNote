import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:securenote/auth.dart';
import 'package:securenote/model/note.dart';
import 'package:securenote/view/editor.dart';

import 'package:local_auth/local_auth.dart';



class Tiles extends StatefulWidget {

  final Note note;

  Tiles(this.note);

  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> {

  LocalAuthentication localauth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0 ,2),
                color: Colors.black26,
                blurRadius: 10
              )
            ]
          ),
          child: ListTile(
            leading: Icon(Icons.brightness_1, color: widget.note.color, size: 45),
            title: Text(widget.note.title, style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: widget.note.isLocked ? Icon(Icons.lock_outline) : Icon(Icons.lock_open),
            onTap: ()async{
              if(widget.note.isLocked){
                if(LocalAuthenticationService.btype.isNotEmpty)
                  auth.authenticate().then((b){
                    if(b)
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Editor(widget.note)));
                    });
                
                //else PIN/PATTERN
                  


              }
              else
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Editor(widget.note)));
            }
            
            
            
            
          )
        ),
      );
  }
}