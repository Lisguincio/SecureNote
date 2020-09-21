import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securenote/auth.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/view/archive.dart';
import 'package:securenote/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

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
                        color: Theme.of(context).canvasColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        children: <Widget>[
                          //Aggiungi in coda le nuove note
                          //Tema Scuro
                          ListTile(
                              title: Text("Tema Scuro"),
                              subtitle:
                                  Text("Attiva se desideri un tema scuro"),
                              trailing: Switch(
                                  value: darkTheme,
                                  onChanged: (s) async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("darkTheme", s);
                                    darkTheme = s;
                                    runApp(MyApp());
                                  })),
                          //Tipo di passkey
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Tipo di passkey"),
                                DropdownButton<String>(
                                    value: passKey,
                                    onChanged: (next) async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("passKey", next);
                                      setState(() {
                                        passKey = next;
                                        print(("Selezionato: " + passKey));
                                      });
                                    },
                                    items: [
                                      if (btype.isNotEmpty)
                                        DropdownMenuItem(
                                          child: Text("Fingerprint"),
                                          value: "fingerprint",
                                        ),
                                      DropdownMenuItem(
                                        child: Text("Pin"),
                                        value: "pin",
                                      ),
                                    ])
                              ],
                            ),
                          ),
                          //Archive
                          ListTile(
                            title: Text("Archivio"),
                            onTap: () {
                              print("GOTO: Archivio");
                              navArchive(); //Apro l'archivio
                            },
                          ),
                          //Logout
                          ListTile(
                            title: Text("Esci"),
                            subtitle: Text("Effettua il logout!"),
                            onTap: () {
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

  void navArchive() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Archive()));
  }

  void logout() async {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Sicuro di voler uscire da questo account?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Si, voglio uscire")),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("No, non voglio"))
          ],
        );
      },
    ).then((r) {
      if (r == true) {
        FirebaseAuth.instance.signOut();
        Navigator.popUntil(context, (route) {
          return route.isFirst;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }
}

bool darkTheme = false;
bool newOnBottom = false;
String passKey = "pin";

Future<void> initPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("passKey")) passKey = prefs.getString("passKey");
  if (prefs.containsKey("darkTheme")) darkTheme = prefs.getBool("darkTheme");
  if (prefs.containsKey("newOnBottom"))
    newOnBottom = prefs.getBool("newOnBottom");
}
