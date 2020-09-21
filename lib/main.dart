import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';

import 'package:securenote/view/editor.dart';
import 'package:securenote/model/note.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/model/tile.dart';
import 'package:securenote/view/settings.dart';
import 'package:securenote/view/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureNote',
      debugShowCheckedModeBanner: false,
      theme: darkTheme ? ThemeData.dark() : ThemeData.light(),
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
    //readDocs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: SafeArea(
            child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool a) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 70,
                centerTitle: true,
                actionsIconTheme: IconThemeData(color: Colors.black),
                leading: IconButton(
                    icon: Icon(Icons.settings, color: Colors.black),
                    onPressed: navSetting),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                    ),
                    onPressed: newNote,
                  )
                ],
                backgroundColor: whitetheme.accentColor,
                floating: true,
                pinned: true,
                title: AppTitle("Secure", "Note"),
              )
            ];
          },
          body: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: StreamBuilder(
                  stream: mainStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      if (snapshot.data.documents.isEmpty) {
                        return Center(child: Text("Ancora nulla"));
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, i) {
                            final key = snapshot.data.documents[i].documentID;
                            return Dismissible(
                              key: UniqueKey(),
                              background:
                                  slideToLeft(" Archive", Icons.archive),
                              secondaryBackground:
                                  slideToRight("Delete ", Icons.delete),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart)
                                  removeNote(key, context, "note");
                                else
                                  archiveNote(key, context);
                              },
                              child: Tiles(Note(
                                  id: snapshot.data.documents[i].documentID,
                                  title: snapshot.data.documents[i]['title'],
                                  color: Color(int.parse(
                                      snapshot.data.documents[i]['color'])),
                                  isLocked: snapshot.data.documents[i]
                                      ["locked"],
                                  body: snapshot.data.documents[i]['body'])),
                            );
                          },
                        );
                    }
                  })),
        )));
  }

  void newNote() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Editor(Note())));
  }

  void navSetting() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }

  final Stream<QuerySnapshot> mainStream = Firestore.instance
      .collection("utenti")
      .document(mainUser.email)
      .collection("note")
      .snapshots();

  //AGGIUNTO STREAMBUILDER

  /* void readDocs() {
    print("READ_DOCS");
    List<DocumentSnapshot> snap = new List();
    Firestore.instance
        .collection("utenti")
        .document(mainUser.email)
        .collection("note")
        .getDocuments()
        .timeout(Duration(seconds: 30), onTimeout: () {
      Toast.show("Richiesta TimeOut", context, duration: 2);
      return null;
    }).then((s) {
      snap = s.documents;
      notes.clear();
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
  } */
}
