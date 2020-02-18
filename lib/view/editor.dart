import 'dart:convert';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:securenote/model/note.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/theme.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  final Note note;

  Editor(this.note);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ZefyrController _controller;
  TextEditingController _title;
  bool isEditing = false;
  bool isNew = false;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    if(widget.note.id == ""){
      print("Nota nuova");
      isNew = true;
    }

    _title =
        new TextEditingController(); //Inizializzo il nuovo TextEditingController per il titolo
    
    NotusDocument document; //Inizializzo il nuovo documento

    
    if (!isNew) document = _loadDocument();
    else document = new NotusDocument();

    
    _controller = ZefyrController(document);

    _controller.addListener(() {
      if (isEditing == false) {
        isEditing = true;
        print("Documento modificato!");
      }
    });
    _title.addListener(() {
      if (isEditing == false) {
        isEditing = true;
        print("Titolo modificato");
      }
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return SafeArea(
      child: WillPopScope(
          onWillPop:willpop,
          child: Scaffold(
          backgroundColor: widget.note.color,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.color_lens,
                          ),
                          onPressed: showColorPicker),
                      AppTitle(isNew ? "New" : "Editor", "Note"),
                      Expanded(child: SizedBox()),
                      IconButton(
                        icon: widget.note.isLocked
                            ? Icon(Icons.lock_outline)
                            : Icon(Icons.lock_open),
                        onPressed: () => setState(() {
                          widget.note.isLocked = !widget.note.isLocked;
                          isEditing = true;
                          print("Il documento è stato modificato!");
                          Toast.show(
                              widget.note.isLocked
                                  ? "Messaggio Criptato"
                                  : "Messaggio Non Criptato",
                              context);
                        }),
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          done();
                        },
                      )
                    ],
                  )),
              Container(
                decoration: BoxDecoration(
                    color: whitetheme.backgroundColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: TextField(
                  controller: _title,
                  autofocus: false,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: "Title"),
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: whitetheme.backgroundColor),
                  padding: EdgeInsets.all(10),
                  child: ZefyrScaffold(
                    child: ZefyrEditor(
                      autofocus: false,
                      padding: EdgeInsets.all(16),
                      controller: _controller,
                      focusNode: _focusNode,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void newNote() {
    print("Nuova nota - Aggiungo!");
    try {
      Firestore.instance
        .collection("utenti")
        .document(mainUser.email)
        .collection("note")
        .add({
      'title': _title.text,
      'body': jsonEncode(_controller.document),
      'locked': widget.note.isLocked,
      'color': widget.note.color.value.toString()
    });
    } catch (e) {
      Toast.show(e.message, context,duration: 2);
    }
    
  }

  void _saveDocument(BuildContext context) {
    print("Nota modificata, Aggiorno!");
    FocusScope.of(context).requestFocus(FocusNode()); //Chiude la tastiera
    final contents =
        jsonEncode(_controller.document); //Codifica il contenuto del corpo
    try {
      Firestore.instance
          .collection("utenti")
          .document(mainUser.email) //?
          .collection("note")
          .document(widget.note.id)
          .updateData({
        'title': _title.text,
        'body': contents,
        'locked': widget.note.isLocked,
        'color': widget.note.color.value.toString()
      });
    } catch (e) {
      Toast.show(e.message, context, duration: 2);
      print(e.message);
    }
  }

  NotusDocument _loadDocument() {
    _title = new TextEditingController(text: widget.note.title);
    if(widget.note.body == null) return NotusDocument();
    List data = json.decode(widget.note.body);
    return NotusDocument.fromJson(data);
  }

  void done() {
    try {
      if (_title.text.isEmpty)
        throw Exception("Il titolo non può essere vuoto");

      if (isNew) {
        newNote();
      }
      else
        if (isEditing) _saveDocument(context);

      Navigator.pop(context);
    } catch (e) {
      Toast.show(e.message, context, duration: 2);
      print(e.message);
    }
  }

  void showColorPicker() {
    Color selected = widget.note.color;
    print("selected = " + selected.toString());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            title: Text("Scegli il colore della nota"),
            content: MaterialColorPicker(
              selectedColor: widget.note.color,
              allowShades: false,
              elevation: 10,
              shrinkWrap: true,
              onMainColorChange: (sel) {
                print("Selezionato il colore numero" + sel.toString());
                selected = sel;
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    setState(() {
                      widget.note.color = Color.fromRGBO(selected.red, selected.green, selected.blue, 1);
                      print("Ora la nota ha colore: " +
                          widget.note.color.toString());
                    });
                    Navigator.pop(context);
                    isEditing = true;
                  },
                  child: Text("Fatto"))
            ],
          );
        });
  }

  Future<bool> willpop()async{
    if (isEditing == false)
      return true;
    return showDialog<bool>(context: context,
    builder: (context){
      return AlertDialog(
        title: Text("Sei sicuro di voler uscire?"),
        content: Text("Sicuro di voler tornare indietro? I cambiamenti effettuati non verrano salvati!"),
        actions: <Widget>[
          FlatButton(onPressed: ()=>Navigator.pop(context, false), child: Text("No, Grazie")),
          FlatButton(onPressed: (){
            Navigator.pop(context, true);
          }, child: Text("Esci")),
        ],
      );
    });
  }
}
