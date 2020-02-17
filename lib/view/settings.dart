import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/view/login.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),
                    AppTitle("Secure", "Settings"),
                    Expanded(child: SizedBox()),
                  ],
                )),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: whitetheme.backgroundColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                      ListTile(
                        title: Text("Aggiungi in coda le nuove note"),
                        trailing: Switch(value: newoNbottom, onChanged: (b)=>setState((){
                          newoNbottom = b;
                        })),
                      ),
                      ListTile(
                        title: Text("Tema Scuro"),
                        subtitle: Text("Attiva se desideri un tema scuro"),
                        trailing: Switch(value: darkTheme, onChanged:(s)=>setState((){
                          if(s==true)
                            darkTheme = true;
                          else
                            darkTheme = false;
                        })),
                      ),
                      ListTile(
                        title: Text("Esci"),
                        subtitle: Text("Effettua il logout!"),
                        onTap: (){
                            print("User " + mainUser.email + " LOGOUT!");
                            logout(); //Effettuo il logout
                        },
                      )
                    ])))
          ],
        ),
      ),
    );
  }

  void logout() async {
    showDialog<bool>(context: context,
    builder: (context){
      return AlertDialog(
        content: Text("Sicuro di voler uscire da questo account?"),
        actions: <Widget>[
          FlatButton(onPressed:(){Navigator.pop(context,true);} , child: Text("Si, voglio uscire")),
          FlatButton(onPressed: (){Navigator.pop(context,false);}, child: Text("No, non voglio"))
        ],
      );
    },
    ).then((r){
      if (r == true){
        FirebaseAuth.instance.signOut();
        Navigator.popUntil(context,(route){return route.isFirst;});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      }
    });
  }

  bool newoNbottom = false;
  
}