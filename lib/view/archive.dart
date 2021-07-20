import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:securenote/model/note.dart';
import 'package:securenote/model/tile.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/theme.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
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
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context)),
                //actions: <Widget>[
                //],
                backgroundColor: whitetheme.accentColor,
                floating: true,
                pinned: true,
                title: AppTitle("Archive", "Note"),
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
                  stream: archiveStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      if (snapshot.data.docs.isEmpty) {
                        return Center(child: Text("Ancora nulla"));
                      } else
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, i) {
                            final key = snapshot.data.docs[i].id;
                            return Dismissible(
                              key: UniqueKey(),
                              background:
                                  slideToLeft(" Unarchive", Icons.unarchive),
                              secondaryBackground:
                                  slideToRight("Delete ", Icons.delete),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart)
                                  removeNote(key, context, "archive");
                                else
                                  unArchiveNote(key, context);
                              },
                              child: Tiles(Note(
                                  id: snapshot.data.docs[i].id,
                                  title: snapshot.data.docs[i]['title'],
                                  color: Color(int.parse(
                                      snapshot.data.docs[i]['color'])),
                                  isLocked: snapshot.data.docs[i]
                                      ["locked"],
                                  body: snapshot.data.docs[i]['body'])),
                            );
                          },
                        );
                    }
                  })),
        )));
  }

  final Stream<QuerySnapshot> archiveStream = FirebaseFirestore.instance
      .collection("utenti")
      .doc(mainUser.email)
      .collection("archive")
      .snapshots();
}
