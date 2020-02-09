import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';

import 'package:securenote/view/editor.dart';
import 'package:securenote/login.dart';
import 'package:securenote/model/note.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/tile.dart';
import 'package:securenote/view/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureNote',
      theme: ThemeData.light(),
      home: SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final FirebaseUser user = mainUser;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    readDocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            print("User " + widget.user.email + " LOGOUT!");
                            logout(); //Effettuo il logout
                            notes.clear(); //Rimuovo le note caricate!
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          }),
                      Expanded(
                        child: SizedBox(),
                      ),
                      AppTitle(),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => readDocs(),
                        iconSize: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          newNote().then((note) {
                            print("Modifico la nota appena creata");
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Editor(note)));
                          });
                        },
                        iconSize: 30,
                      ),
                    ],
                  )),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: whitetheme.backgroundColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, i) {
                        return Tiles(notes[i]);
                      },
                    )),
              )
            ],
          ),
        ));
  }

  Future<Note> newNote() async {
    var note = new Note(title: "", body: "", id: "", isLocked: true, color: Colors.yellow.shade700);
    print("Creo una nuova nota!");
    await Firestore.instance
        .collection("utenti")
        .document(widget.user.email)
        .collection("note")
        .add({
      'title': note.title,
      'body': note.body,
      'locked': note.isLocked,
      'color': note.color.value.toString()
    }).then((doc) {
      note.id = doc.documentID;
    });
    return note;
  }

  void readDocs() {
    notes.clear();
    print("READ_DOCS");
    List<DocumentSnapshot> snap = new List();
    Firestore.instance
        .collection("utenti")
        .document(mainUser.email)
        .collection("note")
        .getDocuments()
        .then((s) {
      snap = s.documents;
      //notes.clear();
      for (DocumentSnapshot doc in snap) {
        Note temp = new Note(
            id: doc.documentID,
            title: doc.data['title'],
            body: doc.data['body'],
            isLocked: doc.data["locked"],
            color: Color(int.parse(doc.data["color"])));
        setState(() {
          notes.add(temp);
          print("Nota aggiunta: " + temp.title);
        });
      }
    });
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }
}
