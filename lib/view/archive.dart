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
                      leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: ()=>Navigator.pop(context)),
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
                          color: whitetheme.backgroundColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: StreamBuilder(
                        stream: archiveStream,
                        builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                          else{
                            if(snapshot.data.documents.isEmpty){
                              return Center(child:Text("Ancora nulla"));
                            }
                            else
                            return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, i) {
                                final key = snapshot.data.documents[i].documentID;
                                return Dismissible(
                                  key: Key(key),
                                  background: slideToLeft(" Unarchive", Icons.unarchive),
                                  secondaryBackground: slideToRight("Delete ", Icons.delete),
                                  onDismissed: (direction){
                                    if(direction == DismissDirection.endToStart)
                                      removeNote(key, context,"archive");
                                    else
                                      unArchiveNote(key, context);
                                  },
                                    child: Tiles(
                                    Note(
                                      id: snapshot.data.documents[i].documentID,
                                      title: snapshot.data.documents[i]['title'],
                                      color: Color(int.parse(snapshot.data.documents[i]['color'])),
                                      isLocked: snapshot.data.documents[i]["locked"],
                                      body: snapshot.data.documents[i]['body']  
                                    )
                                  ),
                                );
                              },
                            );
                          }
                        }
                      )),
                )));
  }

  final Stream<QuerySnapshot> archiveStream = Firestore.instance.collection("utenti").document(mainUser.email).collection("archive").snapshots();

}